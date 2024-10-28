import 'dart:ffi';

import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../../api/managers/etebase_account.dart';
import '../../api/managers/etebase_client.dart';
import '../../api/models/etebase_user.dart';
import '../crypto/crypto_manager.dart';
import '../crypto/crypto_manager_factory.dart';
import '../crypto/crypto_utils.dart';
import '../crypto/key_derivator.dart';
import '../crypto/sync/crypto_manager_factory_sync.dart';
import '../rest/etebase_api_client.dart';
import '../rest/models/signup_request.dart';

@internal
class Client implements EtebaseClient {
  final EtebaseApiClient _apiClient;
  final SodiumSumo _sodium;
  final KeyDerivator _keyDerivator;
  final CryptoManagerFactory _cryptoManagerFactory;

  Client(
    this._apiClient,
    this._sodium,
    this._keyDerivator,
    this._cryptoManagerFactory,
  );

  factory Client.create(
    SodiumSumo sodium, [
    Uri? serverUrl,
  ]) =>
      Client(
        EtebaseApiClient(baseUrl: serverUrl),
        sodium,
        KeyDerivator(sodium),
        CryptoManagerFactorySync(sodium), // TODO allow async
      );

  void dispose() {
    _apiClient.dispose();
  }

  @override
  Future<bool> checkEtebaseServer() async {
    final response = await _apiClient.authentication.isEtebase();
    return response.isSuccessful;
  }

  Future<EtebaseAccount> signup(
    EtebaseUser user,
    String password,
  ) async {
    SecureKey? mainKey;
    SecureKey? accountKey;
    try {
      final salt = _sodium.randombytes.buf(_sodium.crypto.pwhash.saltBytes);
      mainKey = await _keyDerivator(
        password: password,
        salt: salt,
      );

      final mainCryptoManager =
          await _cryptoManagerFactory.createMainCryptoManager(mainKey);
      final loginCryptoManager =
          await mainCryptoManager.createLoginCryptoManager();
      final identityCryptoManager =
          await _cryptoManagerFactory.createBoxCryptoManager();

      accountKey = _sodium.secureRandom(CryptoManager.keySize);
      final encryptedKeys = await mainCryptoManager.encrypt(
        CryptoUtils.concat([
          accountKey.extractBytes(),
          (await identityCryptoManager.privKey).extractBytes(),
        ]),
      );

      final response = await _apiClient.authentication.signup(
        SignupRequest(
          user: user,
          salt: salt,
          loginPubkey: await loginCryptoManager.pubKey,
          pubkey: await identityCryptoManager.pubKey,
          encryptedContent: encryptedKeys,
        ),
      );

      print(response);
      // TODO construct account from result
      throw UnimplementedError();
    } catch (_) {
      // mainKey?.dispose();
      // accountKey?.dispose();
      rethrow;
    }
  }
}

void main(List<String> args) async {
  final c = Client.create(
    await SodiumSumoInit.init(
      () => DynamicLibrary.open('/usr/lib/aarch64-linux-gnu/libsodium.so.23'),
    ),
  );
  await c.signup(
    const EtebaseUser(username: 'username', email: 'email'),
    'password',
  );
}
