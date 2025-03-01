import 'package:etebase/src/api/exceptions/unauthorized.dart';
import 'package:etebase/src/impl/models/auth_token.dart';
import 'package:test/test.dart';

void main() {
  group('$AuthToken', () {
    test('header returns token header', () {
      const token = AuthToken('test-token');

      expect(token.header, 'Token test-token');
    });

    test('throws if token is empty', () {
      expect(() => AuthToken.empty.header, throwsA(isA<Unauthorized>()));
    });

    test('hides token value from printing', () {
      expect(
        const AuthToken('very-secret-value').toString(),
        've***************',
      );
    });
  });
}
