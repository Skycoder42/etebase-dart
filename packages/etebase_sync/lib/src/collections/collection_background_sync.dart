import 'package:etebase/etebase.dart';

import '../api/models/conflict_origin.dart';
import '../sync/background_sync.dart';

final class CollectionBackgroundSync extends BackgroundSync<Collection> {
  final CollectionManager _collectionManager;

  CollectionBackgroundSync(
    super.etebaseSync,
    super.store,
    this._collectionManager,
  );

  @override
  Future<void> sync() {
    // TODO: implement sync
    throw UnimplementedError();
  }

  @override
  Stream<ItemListResponse<Collection>> streamRemote() {
    // TODO: implement streamRemote
    throw UnimplementedError();
  }

  @override
  Future<void> upload(Collection item) async =>
      await _collectionManager.upload(item);

  @override
  Future<Collection> download(String uid) async =>
      await _collectionManager.fetch(uid);

  @override
  Future<void> resolveConflict(
    Collection target,
    Collection conflicted,
    ConflictOrigin origin,
  ) {
    throw UnimplementedError();
  }
}
