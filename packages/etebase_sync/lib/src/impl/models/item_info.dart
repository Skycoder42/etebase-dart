import 'dart:typed_data';

import 'package:hive_ce/hive.dart';
import 'package:meta/meta.dart';

@internal
typedef ItemInfo = ({Uint8List data, bool needsUpload});

@internal
class ItemInfoAdapter extends TypeAdapter<ItemInfo> {
  final int _typeIdOffset;

  const ItemInfoAdapter(this._typeIdOffset);

  @override
  int get typeId => _typeIdOffset + 1;

  @override
  ItemInfo read(BinaryReader reader) {
    final data = reader.readByteList();
    final needsUpload = reader.readBool();
    return (data: data, needsUpload: needsUpload);
  }

  @override
  void write(BinaryWriter writer, ItemInfo obj) => writer
    ..writeByteList(obj.data)
    ..writeBool(obj.needsUpload);
}
