import 'dart:convert';
import 'dart:ffi';

import 'package:meta/meta.dart';
import 'package:msgpack_dart/msgpack_dart.dart' as msg_pack;
import 'package:sodium/sodium_sumo.dart';

import '../../api/managers/etebase_account.dart';
import '../../api/managers/etebase_client.dart';
import '../../api/models/etebase_user.dart';
import '../crypto/crypto_arena.dart';
import '../crypto/crypto_manager.dart';
import '../crypto/crypto_service.dart';
import '../crypto/crypto_utils.dart';
import '../crypto/main_crypto_manager.dart';
import '../crypto/sync/crypto_service_sync.dart';
import '../rest/etebase_api_client.dart';
import '../rest/models/challenge_request.dart';
import '../rest/models/challenge_response.dart';
import '../rest/models/login_request.dart';
import '../rest/models/login_response.dart';
import '../rest/models/signup_request.dart';
import 'account.dart';

@internal
class Client implements EtebaseClient {
  final EtebaseApiClient apiClient;
  final CryptoService _cryptoService;

  Client(
    this.apiClient,
    this._cryptoService,
  );

  factory Client.create(
    SodiumSumo sodium, [
    Uri? serverUrl,
  ]) =>
      Client(
        EtebaseApiClient(baseUrl: serverUrl),
        CryptoServiceSync(sodium), // TODO allow async
      );

  void dispose() {
    apiClient.dispose();
  }

  @override
  Future<bool> checkEtebaseServer() async {
    final response = await apiClient.authentication.isEtebase();
    return response.isSuccessful;
  }

  Future<EtebaseAccount> signup(
    EtebaseUser user,
    String password,
  ) async {
    final arena = CryptoArena();
    try {
      final salt = _cryptoService.keyDerivator.randomSalt();
      final mainKey = arena(
        await _cryptoService.keyDerivator(
          password: password,
          salt: salt,
        ),
      );

      final mainCryptoManager =
          arena(await _cryptoService.createMainCryptoManager(mainKey));
      final loginCryptoManager =
          arena(await mainCryptoManager.createLoginCryptoManager());
      final identityCryptoManager =
          arena(await _cryptoService.createIdentityCryptoManager());

      final accountKey =
          arena(_cryptoService.secureRandom(CryptoManager.keySize));
      final encryptedKeys = await accountKey.runUnlockedAsync(
        (accountKeyData) async =>
            (await identityCryptoManager.privKey).runUnlockedAsync(
          (privKeyBytes) async => await mainCryptoManager.encrypt(
            CryptoUtils.concat([accountKeyData, privKeyBytes]),
          ),
        ),
      );

      final response = await apiClient.authentication.signup(
        SignupRequest(
          user: user,
          salt: salt,
          loginPubkey: await loginCryptoManager.pubKey,
          pubkey: await identityCryptoManager.pubKey,
          encryptedContent: encryptedKeys,
        ),
      );

      return await _createAccount(mainCryptoManager, response);
    } finally {
      await arena.dispose();
    }
  }

  Future<EtebaseAccount> login(
    String username,
    String password,
  ) async {
    final challenge = await apiClient.authentication
        .loginChallenge(ChallengeRequest(username: username));

    final mainKey = await _cryptoService.keyDerivator(
      password: password,
      salt: challenge.salt,
    );
    final mainCryptoManager = await _cryptoService.createMainCryptoManager(
      mainKey,
      version: challenge.version,
    );
    final loginCryptoManager =
        await mainCryptoManager.createLoginCryptoManager();

    final response = ChallengeResponse.login(
      username: username,
      challenge: challenge.challenge,
      host: apiClient.baseUrl.host,
    );
    final encodedResponse = msg_pack.serialize(response.toJson());
    final signature = await loginCryptoManager.signDetached(encodedResponse);
    final loginResponse = await apiClient.authentication.login(
      LoginRequest(
        response: encodedResponse,
        signature: signature,
      ),
    );

    return await _createAccount(mainCryptoManager, loginResponse);
  }

  Future<Account> _createAccount(
    MainCryptoManager mainCryptoManager,
    LoginResponse response,
  ) async {
    final (k1, k2) = CryptoUtils.split2(
      await mainCryptoManager.decrypt(response.user.encryptedContent),
      CryptoManager.keySize,
    );
    return Account(
      this,
      await mainCryptoManager
          .createAccountCryptoManager(_cryptoService.secureCopy(k1)),
      await mainCryptoManager
          .createIdentityCryptoManager(_cryptoService.secureCopy(k2)),
      response.token,
    );
  }
}

void main(List<String> args) async {
  final sodium = await SodiumSumoInit.init(
    () => DynamicLibrary.open('/usr/lib/aarch64-linux-gnu/libsodium.so.23'),
  );
  final userName = base64Url.encode(sodium.randombytes.buf(18));
  print(userName);
  final c = Client.create(sodium, Uri.http('127.0.0.1:3735'));
  final account = await c.signup(
    EtebaseUser(
      username: userName,
      email: '$userName@mail.de',
    ),
    userName,
  );
  c.dispose();
}
