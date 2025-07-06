import '../models/conflict_origin.dart';
import '../models/etebase_target.dart';
import 'etebase_sync_exception.dart';

class UnresolvedConflict extends EtebaseSyncException {
  final EtebaseTarget target;
  final String? uid;
  final ConflictOrigin? origin;

  UnresolvedConflict(this.target, super.message, {this.uid, this.origin});

  @override
  String get name => 'UnresolvedConflict';
}
