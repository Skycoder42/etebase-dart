import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:sodium/sodium.dart';

import '../../api/exceptions/api_missue.dart';
import '../../api/managers/etebase_account.dart';
import '../../api/managers/etebase_collection_invitation_manager.dart';
import '../../api/managers/etebase_collection_manager.dart';
import '../../api/models/etebase_user.dart';
import '../crypto/crypto_arena.dart';
import '../crypto/crypto_manager.dart';
import '../crypto/crypto_service.dart';
import '../crypto/crypto_utils.dart';
import '../crypto/main_crypto_manager.dart';
import '../models/account_data.dart';
import '../models/account_data_stored.dart';
import '../models/challenge_request.dart';
import '../models/challenge_response.dart';
import '../models/login_request.dart';
import '../models/signup_request.dart';
import '../models/user.dart';
import '../rest/interceptors/auth_interceptor.dart';
import 'client.dart';

@internal
class Account implements EtebaseAccount {
  final Client _client;

  MainCryptoManager _mainCryptoManager;
  User _user;
  AuthToken _authToken;

  var _disposed = false;

  Account(
    this._client,
    this._mainCryptoManager,
    this._user,
    String authToken,
  ) : _authToken = AuthToken(authToken);

  static Future<Account> signup(
    Client client,
    EtebaseUser user,
    String password,
  ) async {
    final arena = CryptoArena();
    try {
      final salt = client.crypto.keyDerivator.randomSalt();
      final mainKey = await client.crypto.keyDerivator(
        password: password,
        salt: salt,
      );

      final mainCryptoManager =
          arena(client.crypto.createMainCryptoManager(mainKey));
      final loginCryptoManager =
          arena(await mainCryptoManager.createLoginCryptoManager());
      final identityCryptoManager =
          arena(client.crypto.createIdentityCryptoManager());

      final encryptedKeys = await mainCryptoManager.encrypt(
        CryptoUtils.concatSecure([
          arena(client.crypto.secureRandom(CryptoManager.keySize)),
          identityCryptoManager.privKey,
        ]),
      );

      final response = await client.api.authentication.signup(
        SignupRequest(
          user: user,
          salt: salt,
          loginPubkey: loginCryptoManager.pubKey,
          pubkey: identityCryptoManager.pubKey,
          encryptedContent: encryptedKeys,
        ),
      );

      return Account(
        client,
        arena.detach(mainCryptoManager),
        response.user,
        response.token,
      );
    } finally {
      await arena.dispose();
    }
  }

  static Future<Account> login(
    Client client,
    String username,
    String password,
  ) async {
    final arena = CryptoArena();
    try {
      final challenge = await client.api.authentication
          .loginChallenge(ChallengeRequest(username: username));

      final mainKey = await client.crypto.keyDerivator(
        password: password,
        salt: challenge.salt,
      );
      final mainCryptoManager = arena(
        client.crypto.createMainCryptoManager(
          mainKey,
          version: challenge.version,
        ),
      );

      final loginResponse = await client.api.authentication.login(
        await _signStaticChallenge(
          client,
          mainCryptoManager,
          username,
          ChallengeResponse.login(
            username: username,
            challenge: challenge.challenge,
            host: client.api.baseUrl.host,
          ),
        ),
      );

      return Account(
        client,
        arena.detach(mainCryptoManager),
        loginResponse.user,
        loginResponse.token,
      );
    } finally {
      await arena.dispose();
    }
  }

  @override
  Future<void> dispose() async {
    _authToken = AuthToken.empty;

    if (_disposed) {
      return;
    }

    _disposed = true;
    await _mainCryptoManager.dispose();
  }

  @override
  Future<void> fetchToken() async {
    final challenge = await _client.api.authentication
        .loginChallenge(ChallengeRequest(username: _user.username));

    final loginResponse = await _client.api.authentication.login(
      await _signChallenge(
        ChallengeResponse.login(
          username: _user.username,
          challenge: challenge.challenge,
          host: _client.api.baseUrl.host,
        ),
      ),
    );

    _authToken = AuthToken(loginResponse.token);
  }

  @override
  Future<void> logout() async {
    await _client.api.authentication.logout(_authToken);
    await dispose();
  }

  @override
  Future<void> changePassword(String password) async {
    final arena = CryptoArena();
    try {
      final challenge = await _client.api.authentication
          .loginChallenge(ChallengeRequest(username: _user.username));

      final newMainKey = await _client.crypto.keyDerivator(
        password: password,
        salt: challenge.salt,
      );
      final newMainCryptoManager =
          arena(_client.crypto.createMainCryptoManager(newMainKey));
      final newLoginCryptoManager =
          arena(await newMainCryptoManager.createLoginCryptoManager());

      final newEncryptedContent = await newMainCryptoManager.encrypt(
        await _mainCryptoManager.decrypt(_user.encryptedContent),
      );
      final response = ChallengeResponse.changePassword(
        username: _user.username,
        challenge: challenge.challenge,
        host: _client.api.baseUrl.host,
        loginPubkey: newLoginCryptoManager.pubKey,
        encryptedContent: newEncryptedContent,
      );

      await _client.api.authentication.changePassword(
        _authToken,
        await _signChallenge(response),
      );

      arena(_mainCryptoManager);
      _mainCryptoManager = arena.detach(newMainCryptoManager);
      _user = _user.copyWith(encryptedContent: newEncryptedContent);
    } finally {
      await arena.dispose();
    }
  }

  @override
  Future<Uri> fetchDashboardUrl() async {
    final response =
        await _client.api.authentication.getDashboardUrl(_authToken);
    return response.url;
  }

  @override
  Future<String> save([SecureKey? encryptionKey]) async {
    final arena = CryptoArena();
    try {
      final cryptoManager = arena(
        _client.crypto.createStorageCryptoManager(
          encryptionKey?.copy() ??
              _client.crypto.secureCopy(Uint8List(CryptoManager.keySize)),
        ),
      );

      final accountData = AccountData(
        user: _user,
        authToken: _authToken.value,
        serverUrl: _client.api.baseUrl,
        version: CryptoService.currentVersion,
        key: await _mainCryptoManager.mainKey
            .runUnlockedAsync(cryptoManager.encrypt),
      );

      final encryptedAccountData = await cryptoManager.encrypt(
        _client.msgPack.encode(accountData),
        CryptoUtils.uint32ToUint8List(_mainCryptoManager.version),
      );

      return _client.msgPack.encode64(
        AccountDataStored(
          version: CryptoService.currentVersion,
          encryptedData: encryptedAccountData,
        ),
      );
    } finally {
      await arena.dispose();
    }
  }

  static Future<Account> restore(
    Client client,
    String accountDataStored, [
    SecureKey? encryptionKey,
  ]) async {
    final arena = CryptoArena();
    try {
      final decodedStoredData = client.msgPack.decode64(
        accountDataStored,
        AccountDataStored.fromJson,
      );

      final cryptoManager = arena(
        client.crypto.createStorageCryptoManager(
          encryptionKey?.copy() ??
              client.crypto.secureCopy(Uint8List(CryptoManager.keySize)),
          version: decodedStoredData.version,
        ),
      );

      final accountData = client.msgPack.decode(
        await cryptoManager.decrypt(
          decodedStoredData.encryptedData,
          CryptoUtils.uint32ToUint8List(decodedStoredData.version),
        ),
        AccountData.fromJson,
      );

      if (accountData.serverUrl != client.api.baseUrl) {
        throw ApiMissuse(
          'The account data belongs to ${accountData.serverUrl}, but the '
          'current client used to restore it uses ${client.api.baseUrl}',
        );
      }

      return Account(
        client,
        client.crypto.createMainCryptoManager(
          client.crypto.secureCopy(
            await cryptoManager.decrypt(accountData.key),
          ),
          version: accountData.version,
        ),
        accountData.user,
        accountData.authToken,
      );
    } finally {
      await arena.dispose();
    }
  }

  @override
  // TODO: implement collectionManager
  EtebaseCollectionManager get collectionManager => throw UnimplementedError();

  @override
  // TODO: implement invitationManager
  EtebaseCollectionInvitationManager get invitationManager =>
      throw UnimplementedError();

  Future<LoginRequest> _signChallenge(ChallengeResponse response) async =>
      await _signStaticChallenge(
        _client,
        _mainCryptoManager,
        _user.username,
        response,
      );

  static Future<LoginRequest> _signStaticChallenge(
    Client client,
    MainCryptoManager mainCryptoManager,
    String username,
    ChallengeResponse response,
  ) async {
    final loginCryptoManager =
        await mainCryptoManager.createLoginCryptoManager();
    try {
      final encodedResponse = client.msgPack.encode(response);
      final signature = await loginCryptoManager.signDetached(encodedResponse);
      return LoginRequest(
        response: encodedResponse,
        signature: signature,
      );
    } finally {
      await loginCryptoManager.dispose();
    }
  }

  // static Future<Account> _createAccount(
  //   Client client,
  //   CryptoArena arena,
  //   MainCryptoManager mainCryptoManager,
  //   LoginResponse response,
  // ) async {
  //   final (accountKey, identityKey) = arena(
  //     CryptoUtils.split2Secure(
  //       client.crypto,
  //       await mainCryptoManager.decrypt(response.user.encryptedContent),
  //       CryptoManager.keySize,
  //     ),
  //   );
  //   final accountCryptoManager = arena(
  //     await mainCryptoManager.createAccountCryptoManager(accountKey),
  //   );
  //   final identityCryptoManager = arena(
  //     await mainCryptoManager.createIdentityCryptoManager(identityKey),
  //   );

  //   return Account(
  //     client,
  //     arena.detach(mainCryptoManager),
  //     arena.detach(accountCryptoManager),
  //     arena.detach(identityCryptoManager),
  //     response.user.username,
  //     response.token,
  //   );
  // }
}
