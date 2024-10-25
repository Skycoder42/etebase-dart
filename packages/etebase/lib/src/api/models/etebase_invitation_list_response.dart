import 'etebase_signed_invitation.dart';

/// The dart binding of the EtebaseInvitationListResponse rust class
abstract class EtebaseInvitationListResponse {
  /// Iterator for the list response
  ///
  /// @param this_ the object handle
  String get iterator;

  /// List of invitations included in the response
  ///
  /// @param this_ the object handle
  /// @param[out] data the array to store the items in
  List<EtebaseSignedInvitation> get data;

  /// Indicates whether there is no more data to fetch
  ///
  /// @param this_ the object handle
  bool get isDone;
}
