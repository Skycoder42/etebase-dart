import 'package:freezed_annotation/freezed_annotation.dart';

part 'etebase_user.freezed.dart';
part 'etebase_user.g.dart';

/// A user object.
@freezed
sealed class EtebaseUser with _$EtebaseUser {
  /// Default constructor.
  const factory EtebaseUser({
    /// The username.
    required String username,

    /// The email address.
    required String email,
  }) = _EtebaseUser;

  factory EtebaseUser.fromJson(Map<String, dynamic> json) =>
      _$EtebaseUserFromJson(json);
}
