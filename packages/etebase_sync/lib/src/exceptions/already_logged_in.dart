import 'etebase_sync_exception.dart';

class AlreadyLoggedIn extends EtebaseSyncException {
  AlreadyLoggedIn() : super('Already logged in with another account');

  @override
  String get name => 'AlreadyLoggedIn';
}
