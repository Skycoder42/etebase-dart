import 'etebase_sync_exception.dart';

class CacheMiss extends EtebaseSyncException {
  final String uid;

  CacheMiss(this.uid)
    : super(
        'Instance with uid "$uid" was not found in cache '
        'and device is offline!',
      );

  @override
  String get name => 'CacheMiss';
}
