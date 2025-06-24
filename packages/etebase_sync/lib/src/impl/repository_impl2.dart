import 'dart:typed_data';

import 'package:etebase/etebase.dart';

import '../api/item_record.dart';
import '../api/repository.dart';
import '../api/repository_adapter.dart';

class RepositoryImpl<TRecord extends ItemRecord>
    implements Repository<TRecord> {
  final RepositoryAdapter<TRecord> _adapter;
  final ItemManager _itemManager;

  RepositoryImpl(this._adapter, this._itemManager);

  @override
  Future<TRecord> create() async {
    final item = await _itemManager.create(const ItemMetadata(), Uint8List(0));
    final record = _adapter.createRecord(item);
    await record.init(created: true);
    return record;
  }

  @override
  Future<TRecord?> open(String uid) async {
    final Item item;
    final record = _adapter.createRecord(item);
    await record.init(created: false);
    return record;
  }
}
