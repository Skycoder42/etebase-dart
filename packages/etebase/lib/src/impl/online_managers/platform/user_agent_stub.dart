import 'package:meta/meta.dart';

@internal
abstract base class UserAgent {
  static String build(String clientName) => throw UnimplementedError();

  static String buildFromValues(
    String clientName, {
    Iterable<String> values = const [],
    String? suffix,
  }) {
    final sb =
        StringBuffer()
          ..write(clientName)
          ..write(' (');

    final allValues = ['package:etebase/2.0.0'].followedBy(values);
    var first = true;
    for (final value in allValues) {
      if (first) {
        first = false;
      } else {
        sb.write('; ');
      }
      sb.write(value);
    }

    sb.write(')');

    if (suffix case String()) {
      sb
        ..write(' ')
        ..write(suffix);
    }
    return sb.toString();
  }
}
