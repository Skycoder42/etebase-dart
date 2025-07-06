import '../models/etebase_target.dart';
import 'etebase_sync_exception.dart';

class ReadOnly extends EtebaseSyncException {
  final String uid;
  final EtebaseTarget target;

  ReadOnly(this.uid, this.target)
    : super('Cannot modify a read only ${target.name} (uid: "$uid")');

  @override
  String get name => 'ReadOnly';
}
