import 'etebase_sync_exception.dart';

class UnresolvedConflict extends EtebaseSyncException {
  UnresolvedConflict(super.message);

  @override
  String get name => 'UnresolvedConflict';
}
