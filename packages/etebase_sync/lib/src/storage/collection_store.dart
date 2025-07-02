import 'dart:async';

import 'package:etebase/etebase.dart';

import 'store.dart';

abstract interface class CollectionStore implements Store<Collection> {
  Future<String?> getStoken(String collectionType);

  Future<void> saveStoken(String collectionType, String? stoken);
}
