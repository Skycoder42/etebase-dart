import 'package:path/path.dart' as p;
import 'package:sembast/sembast_io.dart';

import '../hive_cache.dart';

final class SembastCacheIo extends SembastCache {
  @override
  Future<Database> openDatabase(String encodedUserName, String path) async =>
      await databaseFactoryIo.openDatabase(
        p.join(path, encodedUserName),
        version: 1,
      );
}
