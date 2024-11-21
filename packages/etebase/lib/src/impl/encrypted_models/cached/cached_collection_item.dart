import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../api/exceptions/api_missuse.dart';

part 'cached_collection_item.freezed.dart';

@Freezed(fromJson: false, toJson: false)
@internal
sealed class CachedCollectionItem with _$CachedCollectionItem {
  static const _cacheFormatVersion = 1;

  const factory CachedCollectionItem({
    required Uint8List uid,
    required int version,
    required Uint8List? encryptionKey,
    required Uint8List? etag,
    required Uint8List revision,
  }) = _CachedCollectionItem;

  factory CachedCollectionItem.fromJson(List<dynamic> json) {
    if (json[0] != _cacheFormatVersion) {
      throw ApiMissuse('Cannot restore cache format version ${json[0]}');
    }

    return CachedCollectionItem(
      uid: json[1] as Uint8List,
      version: json[2] as int,
      encryptionKey: json[3] as Uint8List?,
      etag: json[4] as Uint8List?,
      revision: json[5] as Uint8List,
    );
  }

  const CachedCollectionItem._();

  List<dynamic> toJson() => [
        _cacheFormatVersion,
        uid,
        version,
        encryptionKey,
        etag,
        revision,
      ];
}
