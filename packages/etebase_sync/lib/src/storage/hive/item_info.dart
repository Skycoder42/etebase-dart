import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

part 'item_info.freezed.dart';

@internal
@freezed
sealed class ItemInfoBase with _$ItemInfoBase {
  const factory ItemInfoBase.item({
    required Uint8List data,
    required String localEtag,
    required String? remoteEtag,
  }) = ItemInfo;

  const factory ItemInfoBase.collection({
    required String collectionType,
    required Uint8List data,
    required String localEtag,
    required String? remoteEtag,
    @Default(false) bool isRemoved,
  }) = CollectionInfo;
}

@internal
extension ItemInfoCopyWith<T extends ItemInfoBase> on T {
  T withRemoteEtag(String? remoteEtag) => switch (this) {
    final ItemInfo info => info.copyWith(remoteEtag: remoteEtag) as T,
    final CollectionInfo info => info.copyWith(remoteEtag: remoteEtag) as T,
  };
}

typedef _BaseData = ({Uint8List data, String localEtag, String? remoteEtag});

abstract base class _ItemInfoBaseAdapter<T extends ItemInfoBase>
    extends TypeAdapter<T> {
  @override
  final int typeId;

  const _ItemInfoBaseAdapter(this.typeId);

  _BaseData _readBase(BinaryReader reader) {
    final data = reader.readByteList();
    final localEtag = reader.readString();
    final remoteEtag = reader.availableBytes > 0 ? reader.readString() : null;
    return (data: data, localEtag: localEtag, remoteEtag: remoteEtag);
  }

  void _writeBase(BinaryWriter writer, T obj) {
    writer
      ..writeByteList(obj.data)
      ..writeString(obj.localEtag);
    if (obj.remoteEtag case final String remoteEtag) {
      writer.writeString(remoteEtag);
    }
  }
}

@internal
final class ItemInfoAdapter extends _ItemInfoBaseAdapter<ItemInfo> {
  const ItemInfoAdapter(int typeIdOffset) : super(typeIdOffset + 1);

  @override
  ItemInfo read(BinaryReader reader) {
    final (:data, :localEtag, :remoteEtag) = _readBase(reader);
    return ItemInfo(data: data, localEtag: localEtag, remoteEtag: remoteEtag);
  }

  @override
  void write(BinaryWriter writer, ItemInfo obj) => _writeBase(writer, obj);
}

@internal
final class CollectionInfoAdapter extends _ItemInfoBaseAdapter<CollectionInfo> {
  const CollectionInfoAdapter(int typeIdOffset) : super(typeIdOffset + 2);

  @override
  CollectionInfo read(BinaryReader reader) {
    final collectionType = reader.readString();
    final isRemoved = reader.readBool();
    final (:data, :localEtag, :remoteEtag) = _readBase(reader);
    return CollectionInfo(
      collectionType: collectionType,
      data: data,
      localEtag: localEtag,
      remoteEtag: remoteEtag,
      isRemoved: isRemoved,
    );
  }

  @override
  void write(BinaryWriter writer, CollectionInfo obj) {
    writer
      ..writeString(obj.collectionType)
      ..writeBool(obj.isRemoved);
    _writeBase(writer, obj);
  }
}
