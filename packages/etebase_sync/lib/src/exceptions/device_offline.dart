import 'etebase_sync_exception.dart';

class DeviceOffline extends EtebaseSyncException {
  String reason;
  DeviceOffline(this.reason)
    : super(
        'Device is offline, but operation requires it to be online: $reason',
      );

  @override
  String get name => 'DeviceOffline';
}
