import 'dart:typed_data';

import 'base/etebase_cloneable.dart';
import 'etebase_collection_access_level.dart';

/// The dart binding of the EtebaseSignedInvitation rust class
abstract class EtebaseSignedInvitation
    implements EtebaseCloneable<EtebaseSignedInvitation> {
  /// Clone the invitation object
  ///
  /// @param this_ the object handle
  @override
  EtebaseSignedInvitation clone();

  /// The uid of the invitation
  ///
  /// @param this_ the object handle
  String get uid;

  /// The username this invitation is for
  ///
  /// @param this_ the object handle
  String get username;

  /// The uid of the collection this invitation is for
  ///
  /// @param this_ the object handle
  String get collection;

  /// The access level offered in this invitation
  ///
  /// @param this_ the object handle
  EtebaseCollectionAccessLevel get accessLevel;

  /// The username this invitation is from
  ///
  /// @param this_ the object handle
  String get fromUsername;

  /// The public key of the inviting user
  ///
  /// @param this_ the object handle
  Uint8List get fromPubkey;
}
