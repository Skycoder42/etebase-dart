import 'package:logging/logging.dart';

import 'sync_logger.dart';

class RepositoryManagerLogger extends SyncLogger {
  final Logger parent;

  RepositoryManagerLogger(this.parent)
    : super(Logger('${parent.fullName}.repositoryManager'), 'collection');

  String _catPrimary(String collectionType) => '[primary:$collectionType]';

  void create(String collectionType) =>
      logger.finer('${catItem(collectionType)} Creating new $type');

  void primaryCreate(String collectionType) =>
      logger.fine('${_catPrimary(collectionType)} Creating new primary $type');

  void primaryFound(String collectionType, String uid) =>
      logger.fine('${_catPrimary(collectionType)} Found primary $type: $uid');

  void primaryConflict(String collectionType, Iterable<String> uids) {
    if (!logger.isLoggable(Level.WARNING)) {
      return;
    }
    logger.warning(
      '${_catPrimary(collectionType)} '
      'Found multiple primary ${type}s: ${uids.join(', ')}',
    );
  }
}
