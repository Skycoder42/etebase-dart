import 'package:meta/meta.dart';

import '../../api/exceptions/unauthorized.dart';

@internal
class AuthToken {
  final String value;

  static const empty = AuthToken('');

  const AuthToken(this.value);

  String get header =>
      value.isEmpty
          ? throw Unauthorized('The account is logged out!')
          : 'Token $value';
}
