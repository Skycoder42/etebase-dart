import 'dart:async';

import 'package:etebase/etebase.dart';

import 'save_result.dart';

abstract interface class ItemStore {
  String? getStoken();

  Future<void> saveStoken(String? stoken);

  Iterable<String> listItems();

  Future<Item?> getItem(String uid, {bool forUpload = false});

  Future<SaveResult> saveRemote(Item item);

  Future<SaveResult> saveLocal(
    Item item, {
    required String? expectedEtag,
    String? remoteEtag,
  });

  Future<SaveResult> saveUploaded(Item item);

  Stream<String> stream();
}
