part of 'items.dart';

abstract class ItemRecord {
  final Repository _repository;
  final bool automaticTimestamps;

  // internal repository stuff
  Item _item;
  String _cacheEtag;
  bool _readOnly = false;
  bool _inConflictResolution = false;

  late ItemMetadata _currentMeta;

  ItemRecord(
    Repository repository,
    this._item, {
    this.automaticTimestamps = true,
  }) : _repository = repository,
       _cacheEtag = _item.etag;

  @nonVirtual
  String get uid => _item.uid;

  bool get isReadOnly => _readOnly;

  @nonVirtual
  String get etag => _item.etag;

  @nonVirtual
  bool get isDeleted => _item.isDeleted;

  @nonVirtual
  ItemMetadata get meta => _currentMeta;

  @protected
  @nonVirtual
  set meta(ItemMetadata meta) {
    _checkWritable();
    _currentMeta = meta;
  }

  @mustCallSuper
  Future<void> init({required bool created}) async {
    _currentMeta = await _item.getMeta();
    if (!created && !_item.isDeleted) {
      deserialize(await _item.getContent());
    }
  }

  @mustCallSuper
  void dispose() => _item.dispose();

  @mustCallSuper
  Future<void> refresh() async {}

  @mustCallSuper
  Future<void> save() async {
    _checkWritable();

    if (_item.isDeleted) {
      throw ItemDeleted(uid);
    }

    await _item.setContent(serialize());
    await _updateMeta();

    if (_inConflictResolution) {
      return;
    }

    await _repository.persist(this);
  }

  @mustCallSuper
  Future<void> delete() async {
    _checkWritable();

    if (_item.isDeleted) {
      return;
    }

    await _item.delete();
    await _updateMeta();

    if (_inConflictResolution) {
      return;
    }

    await _repository.persist(this);
  }

  @mustCallSuper
  Stream<void> sync() async* {}

  @visibleForOverriding
  Uint8List serialize();

  @visibleForOverriding
  void deserialize(Uint8List data);

  @visibleForOverriding
  Future<void> resolveConflict(
    covariant ItemRecord other,
    ConflictOrigin origin,
  ) => throw UnresolvedConflict(
    EtebaseTarget.item,
    // TODO better message
    'Content of item with uid "$uid" has been modified '
    'locally and on the remote (Origin: ${origin.name})',
    uid: uid,
    origin: origin,
  );

  Future<void> _updateItem(Item item, String cacheEtag) async {
    _cacheEtag = cacheEtag;
    if (identical(_item, item)) {
      return;
    }

    _item.dispose();
    _item = item;

    _currentMeta = await item.getMeta();
    if (!item.isDeleted) {
      deserialize(await item.getContent());
    }
  }

  Future<void> _updateMeta() async {
    if (automaticTimestamps) {
      _currentMeta = _currentMeta.copyWith(mtime: DateTime.now().toUtc());
    }
    await _item.setMeta(_currentMeta);
  }

  void _checkWritable() {
    if (isReadOnly) {
      throw ReadOnly(uid, EtebaseTarget.item);
    } else if (_repository.isReadOnly) {
      throw ReadOnly(_repository.uid, EtebaseTarget.collection);
    }
  }
}
