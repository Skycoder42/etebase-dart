import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:sodium/sodium.dart';

import '../../api/exceptions/api_missuse.dart';
import '../../api/managers/etebase_account.dart';
import '../../api/models/etebase_user.dart';
import '../crypto/account_crypto_manager.dart';
import '../crypto/box_crypto_manager.dart';
import '../crypto/crypto_arena.dart';
import '../crypto/crypto_utils.dart';
import '../crypto/main_crypto_manager.dart';
import '../models/account_data.dart';
import '../models/account_data_stored.dart';
import '../models/auth_token.dart';
import '../models/challenge_request.dart';
import '../models/challenge_response.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/signup_request.dart';
import '../models/user.dart';
import '../online_managers/base_manager.dart';
import '../online_managers/collection_invitation_manager_online.dart';
import '../online_managers/collection_manager_online.dart';
import 'client.dart';
import 'collection_invitation_manager.dart';
import 'collection_manager.dart';

@internal
class Account implements EtebaseAccount, AuthTokenSource {
  final Client _client;

  MainCryptoManager _mainCryptoManager;
  User _user;
  AuthToken _authToken;

  final AccountCryptoManager accountCryptoManager;
  final BoxCryptoManager identityCryptoManager;

  @override
  AuthToken get authToken => _authToken;

  Account(
    this._client,
    this._mainCryptoManager,
    this._user,
    String authToken,
    this.accountCryptoManager,
    this.identityCryptoManager,
  ) : _authToken = AuthToken(authToken);

  factory Account._create(
    CryptoArena arena,
    Client client,
    MainCryptoManager mainCryptoManager,
    LoginResponse response,
  ) {
    final (accountKey, identityKey) = CryptoUtils.split2Secure(
      client.crypto,
      arena(mainCryptoManager.decryptKey(response.user.encryptedContent)),
      CryptoUtils.symmetricKeySize,
    );
    return Account(
      client,
      arena.detach(mainCryptoManager),
      response.user,
      response.token,
      mainCryptoManager.createAccountCryptoManager(accountKey),
      mainCryptoManager.createIdentityCryptoManager(identityKey),
    );
  }

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

      final mainCryptoManager = arena(
        client.crypto.createMainCryptoManager(mainKey),
      );
      final loginCryptoManager = arena(
        mainCryptoManager.createLoginCryptoManager(),
      );
      final identityCryptoManager = arena(
        client.crypto.createIdentityCryptoManager(),
      );

      final encryptedKeys = mainCryptoManager.encryptKey(
        arena(
          CryptoUtils.concatSecure(client.crypto, [
            arena(client.crypto.secureRandom(CryptoUtils.symmetricKeySize)),
            identityCryptoManager.privkey,
          ]),
        ),
      );

      final response = await client.authenticator.signup(
        SignupRequest(
          user: user,
          salt: salt,
          loginPubkey: loginCryptoManager.pubkey,
          pubkey: identityCryptoManager.pubkey,
          encryptedContent: encryptedKeys,
        ),
      );

      return Account._create(arena, client, mainCryptoManager, response);
    } finally {
      arena.dispose();
    }
  }

  static Future<Account> login(
    Client client,
    String username,
    String password,
  ) async {
    final arena = CryptoArena();
    try {
      final challenge = await client.authenticator.loginChallenge(
        ChallengeRequest(username: username),
      );

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

      final loginResponse = await client.authenticator.login(
        await _signStaticChallenge(
          client,
          mainCryptoManager,
          username,
          ChallengeResponse.login(
            username: username,
            challenge: challenge.challenge,
            host: client.baseUrl.host,
          ),
        ),
      );

      return Account._create(arena, client, mainCryptoManager, loginResponse);
    } finally {
      arena.dispose();
    }
  }

  static Future<Account> restore(
    Client client,
    String accountDataStored, [
    SecureKey? encryptionKey,
  ]) async {
    final arena = CryptoArena();
    try {
      final decodedStoredData = client.converter.decode64<AccountDataStored>(
        accountDataStored,
      );

      final cryptoManager = arena(
        client.crypto.createStorageCryptoManager(
          encryptionKey?.copy() ??
              client.crypto.secureCopy(Uint8List(CryptoUtils.symmetricKeySize)),
          version: decodedStoredData.version,
        ),
      );

      final accountData = client.converter.decode<AccountData>(
        await cryptoManager.decrypt(
          decodedStoredData.encryptedData,
          Uint8List.fromList([decodedStoredData.version]),
        ),
      );

      if (accountData.serverUrl != client.baseUrl) {
        throw ApiMissuse(
          'The account data belongs to ${accountData.serverUrl}, but the '
          'current client used to restore it uses ${client.baseUrl}',
        );
      }

      final mainCryptoManager = arena(
        client.crypto.createMainCryptoManager(
          cryptoManager.decryptKey(accountData.key),
          version: accountData.version,
        ),
      );

      return Account._create(
        arena,
        client,
        mainCryptoManager,
        LoginResponse(token: accountData.authToken, user: accountData.user),
      );
    } finally {
      arena.dispose();
    }
  }

  @override
  void dispose() {
    _authToken = AuthToken.empty;
    _mainCryptoManager.dispose();
    accountCryptoManager.dispose();
    identityCryptoManager.dispose();
  }

  @override
  late final collectionManager = CollectionManager(
    _client,
    accountCryptoManager,
    CollectionManagerOnline(client: _client, authTokenSource: this),
  );

  @override
  late final invitationManager = CollectionInvitationManager(
    _client,
    this,
    CollectionInvitationManagerOnline(client: _client, authTokenSource: this),
  );

  @override
  Future<void> fetchToken() async {
    final challenge = await _client.authenticator.loginChallenge(
      ChallengeRequest(username: _user.username),
    );

    final loginResponse = await _client.authenticator.login(
      await _signChallenge(
        ChallengeResponse.login(
          username: _user.username,
          challenge: challenge.challenge,
          host: _client.baseUrl.host,
        ),
      ),
    );

    _authToken = AuthToken(loginResponse.token);
  }

  @override
  Future<void> logout() async {
    await _client.authenticator.logout(_authToken);
    dispose();
  }

  @override
  Future<void> changePassword(String password) async {
    final arena = CryptoArena();
    try {
      final challenge = await _client.authenticator.loginChallenge(
        ChallengeRequest(username: _user.username),
      );

      final newMainKey = await _client.crypto.keyDerivator(
        password: password,
        salt: challenge.salt,
      );
      final newMainCryptoManager = arena(
        _client.crypto.createMainCryptoManager(newMainKey),
      );
      final newLoginCryptoManager = arena(
        newMainCryptoManager.createLoginCryptoManager(),
      );

      final newEncryptedContent = await newMainCryptoManager.encrypt(
        await _mainCryptoManager.decrypt(_user.encryptedContent),
      );
      final response = ChallengeResponse.changePassword(
        username: _user.username,
        challenge: challenge.challenge,
        host: _client.baseUrl.host,
        loginPubkey: newLoginCryptoManager.pubkey,
        encryptedContent: newEncryptedContent,
      );

      await _client.authenticator.changePassword(
        _authToken,
        await _signChallenge(response),
      );

      arena(_mainCryptoManager);
      _mainCryptoManager = arena.detach(newMainCryptoManager);
      _user = _user.copyWith(encryptedContent: newEncryptedContent);
    } finally {
      arena.dispose();
    }
  }

  @override
  Future<Uri> fetchDashboardUrl() =>
      _client.authenticator.getDashboardUrl(_authToken);

  @override
  Future<String> save([SecureKey? encryptionKey]) async {
    final arena = CryptoArena();
    try {
      final cryptoManager = arena(
        _client.crypto.createStorageCryptoManager(
          encryptionKey?.copy() ??
              _client.crypto.secureCopy(
                Uint8List(CryptoUtils.symmetricKeySize),
              ),
        ),
      );

      final accountData = AccountData(
        user: _user,
        authToken: _authToken.value,
        serverUrl: _client.baseUrl,
        version: CryptoUtils.currentVersion,
        key: cryptoManager.encryptKey(_mainCryptoManager.mainKey),
      );

      final encryptedAccountData = await cryptoManager.encrypt(
        _client.converter.encode(accountData),
        Uint8List.fromList([_mainCryptoManager.version]),
      );

      return _client.converter.encode64(
        AccountDataStored(
          version: CryptoUtils.currentVersion,
          encryptedData: encryptedAccountData,
        ),
      );
    } finally {
      arena.dispose();
    }
  }

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
    final loginCryptoManager = mainCryptoManager.createLoginCryptoManager();
    try {
      final encodedResponse = client.converter.encode(response);
      final signature = await loginCryptoManager.signDetached(encodedResponse);
      return LoginRequest(response: encodedResponse, signature: signature);
    } finally {
      loginCryptoManager.dispose();
    }
  }
}
