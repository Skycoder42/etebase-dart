import 'dart:ui';

import 'package:etebase/etebase.dart';
import 'package:material_ui/material_ui.dart';

/// Helper factory to create [ItemMetadata] with a [color] value that is a
/// [Color]
///
/// In addition to the usual parameters of [ItemMetadata], [withAlpha] can be
/// specified. See [ItemMetadataExtensions.copyWithColor] for more details.
ItemMetadata flutterItemMetadata({
  required Color color,
  String? description,
  DateTime? mtime,
  String? name,
  String? itemType,
  bool? withAlpha,
}) => ItemMetadata(
  description: description,
  mtime: mtime,
  name: name,
  itemType: itemType,
).copyWithColor(color, withAlpha: withAlpha);

/// Extension on [ItemMetadata] to get and set [Color] values directly.
extension ItemMetadataExtensions<T extends ItemMetadata> on T {
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

  /// Copies the metadata and updates its [ItemMetadata.color] to the
  /// stringified value of [color].
  ///
  /// The [withAlpha] parameter can be used to control whether the color is
  /// saved with or without it's [Color.a] value. If unspecified, the alpha
  /// channel is only saved if it is not `FF`.
  T copyWithColor(Color color, {bool? withAlpha}) {
    final colorBuffer = StringBuffer()
      ..write('#')
      ..write(_toHex(color.r))
      ..write(_toHex(color.g))
      ..write(_toHex(color.b));
    if (withAlpha ?? (color.a != 1.0)) {
      colorBuffer.write(_toHex(color.a));
    }
    return copyWith(color: colorBuffer.toString()) as T;
  }

  static String _toHex(double value) => (value * 0xFF)
      .clamp(0, 0xFF)
      .toInt()
      .toRadixString(16)
      .padLeft(2, '0')
      .toUpperCase();
}
