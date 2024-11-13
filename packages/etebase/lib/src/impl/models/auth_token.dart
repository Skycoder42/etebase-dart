import 'package:meta/meta.dart';

import '../../api/exceptions/api_missuse.dart';

@internal
class AuthToken {
  final String value;

  static const empty = AuthToken('');

  const AuthToken(this.value);

  String get header => value.isEmpty
      ? throw ApiMissuse('The account is logged out!')
      : 'Token $value';
}
