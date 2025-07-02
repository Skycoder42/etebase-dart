import 'dart:async';

import 'package:etebase/etebase.dart';

import 'store.dart';

abstract interface class ItemStore implements Store<Item> {
  Future<String?> getStoken();

  Future<void> saveStoken(String? stoken);
}
