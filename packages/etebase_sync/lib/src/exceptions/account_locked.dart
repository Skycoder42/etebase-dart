import 'etebase_sync_exception.dart';

class AccountLocked extends EtebaseSyncException {
  AccountLocked()
    : super(
        'Cannot access stored account! '
        'Keystore did not return a decryption key',
      );

  @override
  String get name => 'AccountLocked';
}
