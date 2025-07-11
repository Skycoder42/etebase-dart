import 'package:logging/logging.dart';

import 'sync_logger.dart';

class RepositoryLogger extends SyncLogger {
  final String colUid;

  RepositoryLogger(Logger parent, this.colUid)
    : super(Logger('${parent.fullName}.repository.$colUid'), 'item');

  void create() => logger.finer('[collection:$colUid] Creating new $type');

  void persist(String uid) =>
      logger.finer('${catItem(uid)} Persisting $type update');
}
