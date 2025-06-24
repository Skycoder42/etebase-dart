import 'package:freezed_annotation/freezed_annotation.dart';
import 'exceptions/item_deleted.dart';
import 'item_record.dart';

abstract class ProxyRecord<T extends Object> extends ItemRecord {
  late T _data;

  ProxyRecord(super._item);

  @nonVirtual
  T get value => isDeleted ? throw ItemDeleted(uid) : _data;

  @nonVirtual
  set value(T value) => isDeleted ? throw ItemDeleted(uid) : _data = value;

  @override
  @nonVirtual
  dynamic serialize() => encode(_data);

  @override
  @nonVirtual
  void deserialize(dynamic data) => _data = decode(data);

  @visibleForOverriding
  dynamic encode(T data);

  @visibleForOverriding
  T decode(dynamic data);
}
