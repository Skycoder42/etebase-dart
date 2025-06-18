import 'models/repository_metadata.dart';
import 'repository.dart';

abstract interface class RepositoryManager {
  Future<Repository<T>> openPrimary<T extends Object>();

  Future<Map<String, RepositoryMetadata>> list<T extends Object>();

  Future<Repository<T>> create<T extends Object>([RepositoryMetadata meta]);

  Future<Repository<T>> open<T extends Object>(String colUid);

  Future<RepositoryMetadata> getMeta<T extends Object>(String colUid);

  Future<void> updateMeta<T extends Object>(
    String colUid,
    RepositoryMetadata meta,
  );

  Future<void> delete<T extends Object>(String colUid);
}
