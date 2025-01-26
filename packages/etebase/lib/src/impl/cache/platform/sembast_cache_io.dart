import 'package:meta/meta.dart';
import 'package:sembast/sembast_io.dart';

import '../sembast_cache.dart';

/// @nodoc
@internal
typedef SembastCache = SembastCacheIo;

@internal
final class SembastCacheIo extends SembastCacheBase {
  SembastCacheIo(
    super.username, {
    super.pathHint,
    super.autoCompact = true,
  });

  @override
  DatabaseFactory get databaseFactory => databaseFactoryIo;
}
