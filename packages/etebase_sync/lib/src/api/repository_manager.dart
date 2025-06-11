import 'models/repository_metadata.dart';
import 'repository.dart';

abstract interface class RepositoryManager {
  Future<void> dispose();

  Future<Repository<T>> openPrimary<T extends Object>();

  Future<Repository<T>> openById<T extends Object>(String colUid);

  Future<Repository<T>> create<T extends Object>({RepositoryMetadata? meta});
}
