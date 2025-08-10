import 'dart:async';

import 'package:meta/meta.dart';

import 'user_info.dart';

abstract interface class InvitationUserValidator {
  FutureOr<bool> validateUserForInvite(String colUid, UserInfo user);
}

@internal
class RejectValidator implements InvitationUserValidator {
  const RejectValidator();

  @override
  FutureOr<bool> validateUserForInvite(
    String colUid,
    UserInfo user,
  ) => throw UnsupportedError(
    'You have not provided an InvitationUserValidator implementation. Pass '
    'one to the EtebaseSync constructor to make use of the sharing feature.',
  );
}
