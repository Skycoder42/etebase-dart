import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../api/managers/etebase_account.dart';
import '../../api/managers/etebase_collection_invitation_manager.dart';
import '../../api/managers/etebase_collection_manager.dart';
import '../crypto/account_crypto_manager.dart';
import '../crypto/box_crypto_manager.dart';
import '../rest/models/login_response.dart';
import 'client.dart';

@internal
class Account implements EtebaseAccount {
  final Client _client; // TODO ???
  final AccountCryptoManager _accountCryptoManager;
  final BoxCryptoManager _identityCryptoManager;
  final String _authToken;

  Account(
    this._client,
    this._accountCryptoManager,
    this._identityCryptoManager,
    this._authToken,
  );

  @override
  Future<void> changePassword(String password) {
    // TODO: implement changePassword
    throw UnimplementedError();
  }

  @override
  // TODO: implement collectionManager
  EtebaseCollectionManager get collectionManager => throw UnimplementedError();

  @override
  Future<Uri> fetchDashboardUrl() {
    // TODO: implement fetchDashboardUrl
    throw UnimplementedError();
  }

  @override
  Future<void> fetchToken() {
    // TODO: implement fetchToken
    throw UnimplementedError();
  }

  @override
  void forceServerUrl(Uri serverUrl) {
    // TODO: implement forceServerUrl
  }

  @override
  // TODO: implement invitationManager
  EtebaseCollectionInvitationManager get invitationManager =>
      throw UnimplementedError();

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  String save([Uint8List? encryptionKey]) {
    // TODO: implement save
    throw UnimplementedError();
  }
}
