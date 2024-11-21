import 'dart:ui';

import 'package:etebase/etebase.dart';

/// Extension on [EtebaseItemMetadata] to get and set [Color] values directly.
extension MetadataExtensions<T extends EtebaseItemMetadata> on T {
  static final _colorRegExp = RegExp(
    r'^#([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})?$',
    caseSensitive: false,
  );

  /// Returns the value of [color] as a [Color] value.
  ///
  /// If the [color] cannot be parsed because it has an invalid format, a
  /// [ApiMissuse] exception is thrown.
  Color? get colorValue {
    final hex = color;
    if (hex == null) {
      return null;
    }

    final match = _colorRegExp.firstMatch(hex);
    if (match == null) {
      throw ApiMissuse('Expected color to be of format #RRGGBB or #RRGGBBAA');
    }

    return Color.fromARGB(
      switch (match[4]) {
        final String value => int.parse(value, radix: 16),
        _ => 0xFF,
      },
      int.parse(match[1]!, radix: 16),
      int.parse(match[2]!, radix: 16),
      int.parse(match[3]!, radix: 16),
    );
  }

  /// Copies the metadata and updates its [EtebaseItemMetadata.color] to the
  /// stringified value of [color].
  ///
  /// The [withAlpha] parameter can be used to control whether the color is
  /// saved with or without it's [Color.alpha] value. If unspecified, the alpha
  /// channel is only saved if it is not `FF`.
  T copyWithColor(Color color, {bool? withAlpha}) {
    final colorBuffer = StringBuffer()
      ..write('#')
      ..write(_toHex(color.red))
      ..write(_toHex(color.green))
      ..write(_toHex(color.blue));
    if (withAlpha ?? (color.alpha != 0xFF)) {
      colorBuffer.write(_toHex(color.alpha));
    }
    return copyWith(color: colorBuffer.toString()) as T;
  }

  static String _toHex(int value) =>
      value.toRadixString(16).padLeft(2, '0').toUpperCase();
}
