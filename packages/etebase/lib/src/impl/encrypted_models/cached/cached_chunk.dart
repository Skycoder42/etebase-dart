import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'cached_chunk.freezed.dart';

@Freezed(fromJson: false, toJson: false)
@internal
sealed class CachedChunk with _$CachedChunk {
  const factory(Uint8List uid, [Uint8List? data]) = _CachedChunk;

  factory fromJson(List<dynamic> json) => CachedChunk(
    json[0] as Uint8List,
    json.length >= 2 ? json[1] as Uint8List? : null,
  );

  const new _();

  List<dynamic> toJson() => [uid, if (data != null) data];
}
