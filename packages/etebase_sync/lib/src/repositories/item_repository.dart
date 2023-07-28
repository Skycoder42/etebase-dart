import 'package:etebase/etebase.dart';

abstract class ItemRepository<T> {
  Future<EtebaseCollection> getCollection();

  Future<String> getColUid();

  Future<List<T>> getAll({bool sync = true});

  Future<T> get(String id, {bool sync = true});

  Future<List<T>> getMany(List<String> id, {bool sync = true});

  Future<String> create(
    T item, {
    bool transaction = true,
  });

  Future<List<String>> createMany(
    List<T> items, {
    bool transaction = true,
  });

  Future<void> update(
    String id,
    T item, {
    bool transaction = true,
  });

  Future<void> updateMany(
    Map<String, T> items, {
    bool transaction = true,
  });

  Future<void> delete(String id);

  Future<void> deleteMany(List<String> id);

  Future<void> uploadOfflineChanges();
}
