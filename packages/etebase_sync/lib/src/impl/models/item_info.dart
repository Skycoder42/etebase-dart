import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

part 'item_info.freezed.dart';

@freezed
@internal
sealed class ItemInfo with _$ItemInfo {
  const factory ItemInfo({required Uint8List data, String? originalEtag}) =
      _ItemInfo;
}

@internal
class ItemInfoAdapter extends TypeAdapter<ItemInfo> {
  final int _typeIdOffset;

  const ItemInfoAdapter(this._typeIdOffset);

  @override
  int get typeId => _typeIdOffset + 1;

  @override
  ItemInfo read(BinaryReader reader) {
    final data = reader.readByteList();
    final originalEtag = reader.read() as String?;
    return ItemInfo(data: data, originalEtag: originalEtag);
  }

  @override
  void write(BinaryWriter writer, ItemInfo obj) => writer
    ..writeByteList(obj.data)
    ..write(obj.originalEtag);
}
