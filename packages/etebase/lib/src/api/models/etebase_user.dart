import 'package:freezed_annotation/freezed_annotation.dart';

part 'etebase_user.freezed.dart';

/// The dart binding of the EtebaseUser rust class
@freezed
sealed class EtebaseUser with _$EtebaseUser {
  /// Return a new user instance
  ///
  /// Should be destroyed with `etebase_user_destroy`
  ///
  /// @param username the user's username
  /// @param email the user's email
  const factory EtebaseUser({
    /// Get the username
    ///
    /// @param this_ the object handle
    required String username,

    /// Get the email address
    ///
    /// @param this_ the object handle
    required String email,
  }) = _EtebaseUser;
}
