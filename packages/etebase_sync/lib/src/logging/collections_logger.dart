import 'package:logging/logging.dart';

import 'items_logger.dart';
import 'sync_logger.dart';

class CollectionsLogger extends SyncLogger {
  final Logger _parent;

  CollectionsLogger(this._parent)
    : super(Logger('${_parent.fullName}.repositoryManager'), 'collection');

  ItemsLogger items(String colUid) => ItemsLogger(_parent, colUid);

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
