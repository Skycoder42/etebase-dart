import 'etebase_sync_exception.dart';

class AlreadySubscribed extends EtebaseSyncException {
  AlreadySubscribed() : super('Already subscribed to synchronized changes');

  @override
  String get name => 'AlreadySubscribed';
}
