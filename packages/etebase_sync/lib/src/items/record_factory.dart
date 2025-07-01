part of 'items.dart';

abstract interface class _RecordFactory<TRecord extends ItemRecord> {
  Future<TRecord> _createRecord(
    Item item, {
    bool created = false,
    _RecordState? forceState,
  });
}
