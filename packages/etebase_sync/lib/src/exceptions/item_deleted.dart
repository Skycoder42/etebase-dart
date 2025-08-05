import 'etebase_sync_exception.dart';
import 'etebase_target.dart';

class ItemDeleted extends EtebaseSyncException {
  final String uid;
  final EtebaseTarget target;

  ItemDeleted(this.uid, [this.target = EtebaseTarget.item])
    : super('Collection/Item with uid "$uid" has been deleted!');

  @override
  String get name => 'ItemDeleted';
}
