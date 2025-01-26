import 'package:meta/meta.dart';
import 'package:sembast/sembast_io.dart';

import '../sembast_cache.dart';

/// @nodoc
@internal
typedef SembastCache = SembastCacheStub;

@internal
final class SembastCacheStub extends SembastCacheBase {
  SembastCacheStub(
    super.username, {
    super.pathHint,
    super.autoCompact = true,
  });

  @override
  DatabaseFactory get databaseFactory =>
      throw UnsupportedError('Unsupported platform');
}
