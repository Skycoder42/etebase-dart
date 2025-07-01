import 'dart:typed_data';

import 'package:etebase/etebase.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:msgpack_codec/msgpack_codec.dart';

import '../api/exceptions/item_deleted.dart';
import 'items.dart';

abstract class ProxyRecord<T extends Object> extends ItemRecord {
  late T _data;

  ProxyRecord(super.repository, super._item, {super.automaticTimestamps});

  @nonVirtual
  T get value => wasDeleted ? throw ItemDeleted(uid) : _data;

  @nonVirtual
  set value(T value) {
    if (wasDeleted) {
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
    if (wasDeleted) {
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
