import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../api/managers/etebase_account.dart';
import '../../api/managers/etebase_collection_invitation_manager.dart';
import '../../api/managers/etebase_collection_manager.dart';

@internal
class Account implements EtebaseAccount {
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
