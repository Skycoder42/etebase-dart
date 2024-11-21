import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../api/exceptions/api_missuse.dart';
import '../../../api/models/etebase_collection_access_level.dart';

part 'cached_collection.freezed.dart';

@Freezed(fromJson: false, toJson: false)
@internal
sealed class CachedCollection with _$CachedCollection {
  static const _cacheFormatVersion = 1;

  const factory CachedCollection({
    required Uint8List collectionKey,
    required EtebaseCollectionAccessLevel accessLevel,
    required String? stoken,
    required Uint8List item,
    required Uint8List collectionType,
  }) = _CachedCollection;

  factory CachedCollection.fromJson(List<dynamic> json) {
    if (json[0] != _cacheFormatVersion) {
      throw ApiMissuse('Cannot restore cache format version ${json[0]}');
    }

    return CachedCollection(
      collectionKey: json[1] as Uint8List,
      accessLevel: EtebaseCollectionAccessLevel.values
          .singleWhere((e) => e.value == json[2] as int),
      stoken: json[3] as String?,
      item: json[4] as Uint8List,
      collectionType: json[5] as Uint8List,
    );
  }

  const CachedCollection._();

  List<dynamic> toJson() => [
        _cacheFormatVersion,
        collectionKey,
        accessLevel.value,
        stoken,
        item,
        collectionType,
      ];
}
