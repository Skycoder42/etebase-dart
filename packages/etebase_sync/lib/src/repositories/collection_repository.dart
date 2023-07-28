import 'dart:typed_data';

import 'package:etebase/etebase.dart';

import 'item_repository.dart';

abstract class CollectionRepository<T> {
  Future<EtebaseAccount> getAccount();

  Future<ItemRepository<T>> fromCollection(EtebaseCollection collection);

  Future<List<ItemRepository<T>>> getAll();

  Future<ItemRepository<T>> get(String id);

  Future<ItemRepository<T>> create({
    EtebaseItemMetadata? metadata,
    Uint8List? content,
  });

  Future<void> update(
    String id, {
    EtebaseItemMetadata? metadata,
    Uint8List? content,
    bool transaction = true,
  });

  Future<void> delete(String id);
}
