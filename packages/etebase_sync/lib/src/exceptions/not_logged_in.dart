import 'etebase_sync_exception.dart';

class NotLoggedIn extends EtebaseSyncException {
  NotLoggedIn() : super('You must be logged in to perform this operation');

  @override
  String get name => 'NotLoggedIn';
}
