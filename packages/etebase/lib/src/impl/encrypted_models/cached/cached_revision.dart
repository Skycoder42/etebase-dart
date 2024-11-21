import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'cached_chunk.dart';

part 'cached_revision.freezed.dart';

@Freezed(fromJson: false, toJson: false)
@internal
sealed class CachedRevision with _$CachedRevision {
  const factory CachedRevision({
    required Uint8List uid,
    required Uint8List meta,
    required bool deleted,
    required List<CachedChunk> chunks,
  }) = _CachedRevision;

  factory CachedRevision.fromJson(List<dynamic> json) => CachedRevision(
        uid: json[0] as Uint8List,
        meta: json[1] as Uint8List,
        deleted: json[2] as bool,
        chunks: (json[3] as List)
            .cast<List<dynamic>>()
            .map(CachedChunk.fromJson)
            .toList(),
      );

  const CachedRevision._();

  List<dynamic> toJson() => [
        uid,
        meta,
        deleted,
        chunks.map((c) => c.toJson()).toList(),
      ];
}
