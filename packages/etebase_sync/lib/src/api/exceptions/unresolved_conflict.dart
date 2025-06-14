import '../models/conflict_origin.dart';
import 'etebase_sync_exception.dart';

enum ConflictTarget { collection, item }

class UnresolvedConflict extends EtebaseSyncException {
  final ConflictTarget target;
  final String? uid;
  final ConflictOrigin? origin;

  UnresolvedConflict(this.target, super.message, {this.uid, this.origin});

  @override
  String get name => 'UnresolvedConflict';
}
