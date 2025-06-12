import 'etebase_sync_exception.dart';

class CollectionDeleted extends EtebaseSyncException {
  final String colUid;
  CollectionDeleted(this.colUid)
    : super('Collection with uid "$colUid" has been deleted!');

  @override
  String get name => 'CollectionDeleted';
}
