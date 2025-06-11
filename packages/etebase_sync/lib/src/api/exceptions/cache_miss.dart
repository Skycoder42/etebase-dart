import 'etebase_sync_exception.dart';

class CacheMiss extends EtebaseSyncException {
  final String target;

  CacheMiss(this.target)
    : super('$target was not found in cache and device is offline!');

  @override
  String get name => 'CacheMiss';
}
