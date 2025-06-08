import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../api/exceptions/api_missuse.dart';
import '../../../api/models/collection_access_level.dart';

part 'cached_collection.freezed.dart';

@Freezed(fromJson: false, toJson: false)
@internal
sealed class CachedCollection with _$CachedCollection {
  @visibleForTesting
  static const cacheFormatVersion = 1;

  const factory CachedCollection({
    required Uint8List collectionKey,
    required CollectionAccessLevel accessLevel,
    required String? stoken,
    required Uint8List item,
    required Uint8List collectionType,
  }) = _CachedCollection;

  factory CachedCollection.fromJson(List<dynamic> json) {
    if (json[0] != cacheFormatVersion) {
      throw ApiMissuse('Cannot restore cache format version ${json[0]}');
    }

    return CachedCollection(
      collectionKey: json[1] as Uint8List,
      accessLevel: CollectionAccessLevel.values.singleWhere(
        (e) => e.value == json[2] as int,
      ),
      stoken: json[3] as String?,
      item: json[4] as Uint8List,
      collectionType: json[5] as Uint8List,
    );
  }

  const CachedCollection._();

  List<dynamic> toJson() => [
    cacheFormatVersion,
    collectionKey,
    accessLevel.value,
    stoken,
    item,
    collectionType,
  ];
}
