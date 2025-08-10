import 'package:etebase/etebase.dart';

import 'etebase_sync_exception.dart';

class UserProfileMismatch extends EtebaseSyncException {
  final String username;
  final UserProfile profile;

  UserProfileMismatch(this.username, this.profile)
    : super('Profile for user $username was rejected!');

  @override
  String get name => 'UserProfileMismatch';
}
