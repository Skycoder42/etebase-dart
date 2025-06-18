import 'dart:typed_data';

import 'package:hive_ce/hive.dart';
import 'package:meta/meta.dart';

@internal
typedef CollectionInfo = ({Uint8List collection, bool needsUpload});

@internal
class CollectionInfoAdapter extends TypeAdapter<CollectionInfo> {
  final int _typeIdOffset;

  const CollectionInfoAdapter(this._typeIdOffset);

  @override
  int get typeId => _typeIdOffset + 1;

  @override
  CollectionInfo read(BinaryReader reader) {
    final collection = reader.readByteList();
    final needsUpload = reader.readBool();
    return (collection: collection, needsUpload: needsUpload);
  }

  @override
  void write(BinaryWriter writer, CollectionInfo obj) => writer
    ..writeByteList(obj.collection)
    ..writeBool(obj.needsUpload);
}
