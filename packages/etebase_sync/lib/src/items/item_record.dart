part of 'items.dart';

abstract class ItemRecord implements ScopeDisposable {
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
    RecordState.ready => _repository.isReadOnly || _item.isDeleted,
    _ => true,
  };

  @nonVirtual
  String get etag => _item.etag;

  @nonVirtual
  bool get isDeleted => _item.isDeleted || _state == RecordState.destroyed;

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

  @mustCallSuper
  @visibleForOverriding
  Future<void> init({required bool created}) async {
    if (_state != RecordState.uninitialized) {
      throw StateError('Record has already been initialized');
    }

    _repository.attach(this);
    _currentMeta = await _item.getMeta();
    if (!created && !_item.isDeleted) {
      deserialize(await _item.getContent());
    }
    _cacheEtag = created ? null : _item.etag;
    _state = RecordState.ready;
  }

  // Must use Null instead of void to conform to the interface
  @override
  @mustCallSuper
  Null dispose() {
    if (_state case RecordState.disposed || RecordState.detaching) {
      return;
    }

    _item.dispose();
    _state = RecordState.disposed;
    _repository.detach(this);
  }

  void _detach() {
    _state = RecordState.detaching;
    dispose();
    _state = RecordState.disposed;
    _repository.detach(this);
  }

  @mustCallSuper
  Future<bool> refresh({bool sync = false}) async {
    _checkUnlocked();

    // created items cannot be refresh until saved once
    if (_cacheEtag == null) {
      return false;
    }

    return await _repository._refresh(this, sync);
  }

  Stream<String> watch({bool sync = false}) {
    final syncStream = sync
        ? Stream.value(null).asyncMap((_) => _repository.sync()).cast<String?>()
        : null;

    final watchEtagStream = _repository.syncEvents
        .where((e) => e.uid == _item.uid)
        .map(
          (event) => switch (event) {
            SyncUploadedEvent(:final etag) ||
            SyncDownloadedEvent(:final etag) => etag,
            _ => null,
          },
        );

    final mergeStream = syncStream != null
        ? MergeStream([syncStream, watchEtagStream])
        : watchEtagStream;
    return mergeStream.whereNotNull().asyncMap((etag) async {
      if (etag == _item.etag) {
        return null;
      }
      if (!await refresh()) {
        return null;
      }
      return _item.etag;
    }).whereNotNull();
  }

  @mustCallSuper
  Future<void> save() async {
    _checkWritable();

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

    await _item.delete();
    await _updateMeta();

    if (_state == RecordState.conflictResolving) {
      return;
    }

    try {
      await _repository._persist(this);
    } on ItemDeleted {
      // ignore, because the desired state has been reached
    }
  }

  @visibleForOverriding
  Uint8List serialize();

  @visibleForOverriding
  void deserialize(Uint8List data);

  @visibleForOverriding
  Future<void> resolveConflict(
    covariant ItemRecord other,
    ConflictOrigin origin,
  ) => Future.value();

  Future<void> _updateItem(Item item, String cacheEtag) async {
    _checkInitialized();

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

  void _checkInitialized() {
    switch (_state) {
      case RecordState.uninitialized:
        throw StateError('Record has not been initialized yet');
      case RecordState.disposed || RecordState.detaching:
        throw StateError('Record has been disposed');
      case _:
        break;
    }
  }

  void _checkUnlocked() {
    _checkInitialized();
    switch (_state) {
      case RecordState.locked:
        throw RecordLocked(uid);
      case RecordState.destroyed:
        throw ItemDeleted(uid);
      case _:
        break;
    }
  }

  void _checkWritable() {
    _checkUnlocked();
    if (_repository.isReadOnly) {
      throw ReadOnly(_repository.uid, EtebaseTarget.collection);
    } else if (_item.isDeleted) {
      throw ItemDeleted(uid);
    }
  }
}
