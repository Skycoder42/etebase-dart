// coverage:ignore-file

import 'package:json_annotation/json_annotation.dart';

/// The access level to a collection.
@JsonEnum(valueField: 'value')
enum CollectionAccessLevel {
  /// Read only access.
  readOnly(0),

  /// Admin access.
  admin(1),

  /// Read and write access.
  readWrite(2);

  /// The numeric value of the access level.
  final int value;

  new(this.value);
}
