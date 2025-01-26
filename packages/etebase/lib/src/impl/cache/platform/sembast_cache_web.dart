import 'package:meta/meta.dart';
import 'package:sembast_web/sembast_web.dart';

import '../sembast_cache.dart';

/// @nodoc
@internal
typedef SembastCache = SembastCacheWeb;

@internal
final class SembastCacheWeb extends SembastCacheBase {
  SembastCacheWeb(
    super.username, {
    // ignored on purpose, as on the web the path is always the same
    // ignore: avoid_unused_constructor_parameters
    String? pathHint,
    super.autoCompact = true,
  });

  @override
  DatabaseFactory get databaseFactory => databaseFactoryWeb;
}
