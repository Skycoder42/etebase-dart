import 'package:meta/meta.dart';

// ignore: no_self_package_imports
import '../../../../gen/pubspec.g.dart';

@internal
abstract base class UserAgent {
  static String build(String clientName) => throw UnimplementedError();

  static String buildFromValues(
    String clientName, {
    Iterable<String> values = const [],
    String? suffix,
  }) {
    final sb = StringBuffer()
      ..write(clientName)
      ..write(' (');

    final allValues = ['package:${Pubspec.name}/${Pubspec.version.canonical}']
        .followedBy(values);
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
