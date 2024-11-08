import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'chunk.freezed.dart';

@internal
@Freezed(fromJson: false, toJson: false)
sealed class Chunk with _$Chunk {
  const factory Chunk(String uid, Uint8List? data) = _Chunk;

  const Chunk._();

  factory Chunk.fromJson(List<dynamic> json) =>
      Chunk(json[0] as String, json[1] as Uint8List?);

  List<dynamic> toJson() => [uid, data];
}
