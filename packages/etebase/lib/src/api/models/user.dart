// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// A user object.
@freezed
sealed class User with _$User {
  /// Default constructor.
  const factory User({
    /// The username.
    required String username,

    /// The email address.
    required String email,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
