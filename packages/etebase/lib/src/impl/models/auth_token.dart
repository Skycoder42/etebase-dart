import 'package:freezed_annotation/freezed_annotation.dart';

import '../../api/exceptions/unauthorized.dart';

part 'auth_token.freezed.dart';

@internal
@Freezed(toStringOverride: false)
sealed class AuthToken with _$AuthToken {
  static const empty = AuthToken('');

  const factory AuthToken(String value) = _AuthToken;

  const AuthToken._();

  String get header =>
      value.isEmpty
          ? throw Unauthorized('The account is logged out!')
          : 'Token $value';

  @override
  String toString() => '${value.substring(0, 2)}${'*' * (value.length - 2)}';
}
