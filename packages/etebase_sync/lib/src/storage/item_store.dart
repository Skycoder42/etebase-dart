import 'dart:async';

import 'package:etebase/etebase.dart';

import 'save_result.dart';

abstract interface class ItemStore<TItem extends Item> {
  Future<String?> getStoken();

  Future<void> saveStoken(String? stoken);

  Stream<String> listItems();

  Future<TItem?> getItem(String uid, {bool forUpload = false});

  Future<SaveResult<TItem>> saveRemote(TItem item);

  Future<SaveResult<TItem>> saveLocal(
    TItem item, {
    required String? expectedEtag,
    String? remoteEtag,
  });

  Future<SaveResult<TItem>> saveUploaded(TItem item);

  Stream<String> stream();
}
