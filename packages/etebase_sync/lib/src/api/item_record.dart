import 'dart:async';
import 'dart:typed_data';

import 'package:etebase/etebase.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../impl/repository_impl2.dart';
import 'exceptions/item_deleted.dart';
import 'exceptions/unresolved_conflict.dart';
import 'models/conflict_origin.dart';
import 'repository.dart';

abstract class ItemRecord {
  final RepositoryImpl _repository;

  final bool automaticTimestamps;

  @internal
  Item item;

  @internal
  String lastEtag;

  late ItemMetadata _currentMeta;

  ItemRecord(
    Repository repository,
    this.item, {
    this.automaticTimestamps = true,
  }) : _repository = repository as RepositoryImpl,
       lastEtag = item.etag;

  @nonVirtual
  String get uid => item.uid;

  @nonVirtual
  String get etag => item.etag;

  @nonVirtual
  bool get isDeleted => item.isDeleted;

  @nonVirtual
  ItemMetadata get meta => _currentMeta;

  @protected
  @nonVirtual
  set meta(ItemMetadata meta) => _currentMeta = meta;

  @mustCallSuper
  Future<void> init({required bool created}) async {
    _currentMeta = await item.getMeta();
    if (!created && !item.isDeleted) {
      deserialize(await item.getContent());
    }
  }

  @mustCallSuper
  void dispose() => item.dispose();

  @mustCallSuper
  Future<void> refresh() async {}

  @mustCallSuper
  Future<void> save() async {
    if (item.isDeleted) {
      throw ItemDeleted(uid);
    }

    await item.setContent(serialize());
    await _updateMeta();
    final update = await _repository.persist(this);
    await _updateItem(update);
  }

  @mustCallSuper
  Future<void> delete() async {
    if (item.isDeleted) {
      return;
    }

    await item.delete();
    await _updateMeta();
    final update = await _repository.persist(this);
    await _updateItem(update);
  }

  @mustCallSuper
  Stream<void> sync() async* {}

  @nonVirtual
  Future<void> replaceFrom(covariant ItemRecord other) async {
    // TODO make normal error
    assert(
      identical(_repository, other._repository),
      'Cannot replace with record from different repository',
    );

    await _updateItem(other.item, other.lastEtag);
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
    ConflictTarget.item,
    // TODO better message
    'Content of item with uid "$uid" has been modified '
    'locally and on the remote (Origin: ${origin.name})',
    uid: uid,
    origin: origin,
  );

  Future<void> _updateItem(Item item, [String? lastEtag]) async {
    this.item = item;
    this.lastEtag = lastEtag ?? item.etag;
    _currentMeta = await item.getMeta();
    if (!item.isDeleted) {
      deserialize(await item.getContent());
    }
  }

  Future<void> _updateMeta() async {
    if (automaticTimestamps) {
      _currentMeta = _currentMeta.copyWith(mtime: DateTime.now().toUtc());
    }
    await item.setMeta(_currentMeta);
  }
}
