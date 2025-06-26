import 'dart:typed_data';

import 'package:etebase/etebase.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:msgpack_codec/msgpack_codec.dart';

import 'exceptions/item_deleted.dart';
import '../items/item_record.dart';

abstract class ProxyRecord<T extends Object> extends ItemRecord {
  late T _data;

  ProxyRecord(super.repository, super.item);

  @nonVirtual
  T get value => isDeleted ? throw ItemDeleted(uid) : _data;

  @nonVirtual
  set value(T value) {
    if (isDeleted) {
      throw ItemDeleted(uid);
    }

    if (_data == value) {
      return;
    }

    _data = value;
    meta = updateMeta(meta, value);
  }

  @override
  @visibleForTesting
  @nonVirtual
  // ignore: invalid_override_of_non_virtual_member only to change visibility
  set meta(ItemMetadata meta) => super.meta = meta;

  @override
  @mustCallSuper
  Future<void> delete() async {
    if (isDeleted) {
      return;
    }

    meta = updateMeta(meta, null);
    await super.delete();
  }

  @override
  @nonVirtual
  Uint8List serialize() => msgPack.encode(encode(_data));

  @override
  @nonVirtual
  void deserialize(Uint8List data) => _data = decode(msgPack.decode(data));

  @visibleForOverriding
  dynamic encode(T data);

  @visibleForOverriding
  T decode(dynamic data);

  @visibleForOverriding
  ItemMetadata updateMeta(ItemMetadata meta, T? value);
}
