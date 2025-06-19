import 'etebase_sync_exception.dart';

class ItemDeleted extends EtebaseSyncException {
  final String uid;

  ItemDeleted(this.uid)
    : super('Collection/Item with uid "$uid" has been deleted!');

  @override
  String get name => 'ItemDeleted';
}
