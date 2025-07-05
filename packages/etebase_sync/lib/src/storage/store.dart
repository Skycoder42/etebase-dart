import 'dart:async';

import 'package:etebase/etebase.dart';

import 'save_result.dart';

abstract interface class Store<TItem extends Item> {
  Stream<String> listUids();

  Future<TItem?> getItem(String uid, {bool forUpload = false});

  Future<SaveResult<TItem>> saveRemote(TItem item);

  Future<SaveResult<TItem>> saveLocal(
    TItem item, {
    required String? expectedEtag,
    String? remoteEtag,
  });

  Future<SaveResult<TItem>> saveUploaded(TItem item);

  Stream<String> stream();

  Iterable<String> getPendingUploads();
}
