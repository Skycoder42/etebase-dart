import 'dart:async';
import 'dart:typed_data';

import 'package:etebase/etebase.dart';
import 'package:hive/hive.dart';
import 'package:synchronized/synchronized.dart';

import '../storage.dart';

class HiveStorage implements Storage {
  final EtebaseItemManager _etebaseItemManager;
  final LazyBox<Uint8List> _box;

  final _lock = Lock();
  final _errorStreamController = StreamController.broadcast();

  HiveStorage(this._etebaseItemManager, this._box);

  Future<void> dispose() async {
    await _lock.synchronized(_box.close).catchError(_onError);
    await _errorStreamController.close();
  }

  // TODO rethink locking once the rest is implemented

  @override
  Future<EtebaseItem?> load(String uid) async {
    final data = await _lock.synchronized(() => _box.get(uid));
    if (data == null) {
      return null;
    }

    return _etebaseItemManager.cacheLoad(data);
  }

  @override
  void save(EtebaseItem item) => unawaited(
        _lock.synchronized<void>(() async {
          final id = await item.getUid();
          final data = await _etebaseItemManager.cacheSaveWithContent(item);
          await _box.put(id, data);
        }).catchError(_onError),
      );

  @override
  void delete(String uid) => unawaited(
        _lock.synchronized<void>(() => _box.delete(uid)).catchError(_onError),
      );

  // ignore: prefer_void_to_null
  void _onError(Object error, StackTrace stackTrace) {
    if (_errorStreamController.hasListener) {
      _errorStreamController.addError(error, stackTrace);
    } else {
      Zone.current.handleUncaughtError(error, stackTrace);
    }
  }
}
