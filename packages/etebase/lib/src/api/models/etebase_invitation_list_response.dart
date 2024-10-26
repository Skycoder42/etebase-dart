import 'base/etebase_iterable_response.dart';
import 'etebase_signed_invitation.dart';

/// The dart binding of the EtebaseInvitationListResponse rust class
abstract class EtebaseInvitationListResponse
    implements EtebaseIterableResponse<EtebaseSignedInvitation> {
  /// Iterator for the list response
  ///
  /// @param this_ the object handle
  @override
  String get iterator;

  /// List of invitations included in the response
  ///
  /// @param this_ the object handle
  /// @param[out] data the array to store the items in
  @override
  List<EtebaseSignedInvitation> get data;

  /// Indicates whether there is no more data to fetch
  ///
  /// @param this_ the object handle
  @override
  bool get isDone;
}
