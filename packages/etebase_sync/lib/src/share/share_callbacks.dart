import 'dart:async';

import 'package:meta/meta.dart';

import 'user_info.dart';

enum CollectionRemovedAction { delete, keepLocalCopy }

abstract interface class ShareCallbacks {
  FutureOr<bool> validateUserForInvite(String colUid, UserInfo user);

  Future<CollectionRemovedAction> onCollectionRemoved(String colUid);
}

@internal
class UnimplementedShareCallbacks implements ShareCallbacks {
  const UnimplementedShareCallbacks();

  @override
  FutureOr<bool> validateUserForInvite(String colUid, UserInfo user) =>
      _throwUnsupported();

  @override
  Future<CollectionRemovedAction> onCollectionRemoved(String colUid) =>
      _throwUnsupported();

  Never _throwUnsupported() => throw UnsupportedError(
    'You have not provided an ShareCallbacks implementation. Pass '
    'one to the EtebaseSync constructor to make use of the sharing feature.',
  );
}
