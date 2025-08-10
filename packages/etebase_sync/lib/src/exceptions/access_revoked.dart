import 'etebase_sync_exception.dart';

class AccessRevoked extends EtebaseSyncException {
  final String uid;

  AccessRevoked(this.uid)
    : super(
        'Access to collection with uid "$uid" has been revoked. '
        'Only the local copy can be accessed.',
      );

  @override
  String get name => 'AccessRevoked';
}
