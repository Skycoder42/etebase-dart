// coverage:ignore-file

import 'dart:typed_data';

import 'etebase_collection_access_level.dart';

/// A signed invitation to join a collection.
abstract class EtebaseSignedInvitation {
  /// The uid of the invitation.
  String get uid;

  /// The username this invitation is for.
  String get username;

  /// The uid of the collection this invitation is for.
  String get collection;

  /// The access level offered in this invitation.
  EtebaseCollectionAccessLevel get accessLevel;

  /// The username this invitation is from.
  String? get fromUsername;

  /// The public key of the inviting user.
  Uint8List get fromPubKey;
}
