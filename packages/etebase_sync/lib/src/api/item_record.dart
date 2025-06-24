import 'package:etebase/etebase.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

abstract class ItemRecord {
  final Item _item;
  final String _lastEtag;

  ItemRecord(this._item) : _lastEtag = _item.etag;

  @nonVirtual
  String get uid => _item.uid;

  @nonVirtual
  String get etag => _item.etag;

  @nonVirtual
  bool get isDeleted => _item.isDeleted;

  @mustCallSuper
  Future<void> init({required bool created}) async {}

  @mustCallSuper
  void dispose() => _item.dispose();

  @nonVirtual
  Future<void> refresh() async {}

  @nonVirtual
  Future<void> save() async {}

  @nonVirtual
  Future<void> delete() async {}

  @nonVirtual
  Stream<void> sync() async* {}

  @visibleForOverriding
  dynamic serialize();

  @visibleForOverriding
  void deserialize(dynamic data);

  @visibleForOverriding
  ItemMetadata? updateMeta(ItemMetadata? current);
}
