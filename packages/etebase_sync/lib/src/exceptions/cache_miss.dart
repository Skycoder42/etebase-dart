import 'etebase_sync_exception.dart';
import 'etebase_target.dart';

class CacheMiss extends EtebaseSyncException {
  final EtebaseTarget target;
  final String uid;
  final bool didSync;

  CacheMiss(this.target, this.uid, {this.didSync = false})
    : super(
        didSync
            ? 'The $target with uid "$uid" was not found in cache, even though '
                  'it was just synced. It either does not exist or the device '
                  'is offline.'
            : 'The $target with uid "$uid" was not found in cache. It either '
                  'does not exist or you need to manually sync first.',
      );

  @override
  String get name => 'CacheMiss';
}
