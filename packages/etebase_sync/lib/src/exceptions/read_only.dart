import 'etebase_sync_exception.dart';
import 'etebase_target.dart';

class ReadOnly extends EtebaseSyncException {
  final String uid;
  final EtebaseTarget target;

  ReadOnly(this.uid, this.target)
    : super('Cannot modify a read only ${target.name} (uid: "$uid")');

  @override
  String get name => 'ReadOnly';
}
