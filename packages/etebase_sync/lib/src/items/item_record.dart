part of 'items.dart';

abstract class ItemRecord {
  final Repository _repository;
  final bool automaticTimestamps;

  // internal repository stuff
  Item _item;
  late String? _cacheEtag;
  RecordState _state = RecordState.uninitialized;

  late ItemMetadata _currentMeta;

  ItemRecord(
    Repository repository,
    this._item, {
    this.automaticTimestamps = true,
  }) : _repository = repository;

  @nonVirtual
  String get uid => _item.uid;

  bool get isReadOnly => switch (_state) {
    RecordState.ready => _repository.isReadOnly,
    _ => true,
  };

  @nonVirtual
  String get etag => _item.etag;

  @nonVirtual
  ItemMetadata get meta {
    _checkInitialized();
    return _currentMeta;
  }

  @protected
  @nonVirtual
  set meta(ItemMetadata meta) {
    _checkWritable();
    _currentMeta = meta;
  }

  @protected
  bool get wasDeleted => _item.isDeleted;

  @mustCallSuper
  Future<void> init({required bool created}) async {
    if (_state != RecordState.uninitialized) {
      throw StateError('Record has already been initialized');
    }

    _currentMeta = await _item.getMeta();
    if (!created && !_item.isDeleted) {
      deserialize(await _item.getContent());
    }
    _cacheEtag = created ? null : _item.etag;
    _state = RecordState.ready;
  }

  @mustCallSuper
  void dispose() {
    if (_state case RecordState.disposed || RecordState.detached) {
      return;
    }

    _item.dispose();
    _state = RecordState.disposed;
  }

  void _detach() {
    _state = RecordState.detached;
  }

  @mustCallSuper
  Future<void> refresh({bool sync = false}) async {
    _checkUnlocked();

    // created items cannot be refresh until saved once
    if (_cacheEtag == null) {
      return;
    }

    await _repository._refresh(this, sync);
  }

  @mustCallSuper
  Future<void> save() async {
    _checkWritable();

    if (_item.isDeleted) {
      throw ItemDeleted(uid);
    }

    await _item.setContent(serialize());
    await _updateMeta();

    if (_state == RecordState.conflictResolving) {
      return;
    }

    await _repository._persist(this);
  }

  @mustCallSuper
  Future<void> delete() async {
    _checkWritable();

    if (_item.isDeleted) {
      return;
    }

    await _item.delete();
    await _updateMeta();

    if (_state == RecordState.conflictResolving) {
      return;
    }

    await _repository._persist(this);
    dispose();
  }

  @mustCallSuper
  Stream<void> sync() async* {
    _checkUnlocked();
  }

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

    if (item.isDeleted) {
      throw ItemDeleted(uid);
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

  void _checkInitialized() {
    switch (_state) {
      case RecordState.uninitialized:
        throw StateError('Record has not been initialized yet');
      case RecordState.disposed || RecordState.detached:
        throw StateError('Record has been disposed');
      case _:
        break;
    }
  }

  void _checkUnlocked() {
    _checkInitialized();
    if (_state case RecordState.locked) {
      // TODO real exception
      throw StateError('Record is locked!');
    }
  }

  void _checkWritable() {
    _checkUnlocked();
    if (_repository.isReadOnly) {
      throw ReadOnly(_repository.uid, EtebaseTarget.collection);
    }
  }
}
