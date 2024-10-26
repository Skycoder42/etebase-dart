import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:meta/meta_meta.dart';

@internal
@Target({TargetKind.constructor})
class ByteArrayConverter extends JsonConverter<Uint8List, Uint8List> {
  const ByteArrayConverter();

  @override
  Uint8List fromJson(Uint8List json) => json;

  @override
  Uint8List toJson(Uint8List object) => object;
}

/// @nodoc
@internal
const msgPackBytes = ByteArrayConverter();
