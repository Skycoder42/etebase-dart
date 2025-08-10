import 'etebase_sync_exception.dart';

class RecordLocked extends EtebaseSyncException {
  final String uid;

  RecordLocked(this.uid)
    : super(
        'Record with uid "$uid" is locked! '
        'Another asynchronous operation is still pending.',
      );

  @override
  String get name => 'RecordLocked';
}
