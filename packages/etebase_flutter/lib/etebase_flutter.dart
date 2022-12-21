import 'etebase_flutter_platform_interface.dart';

class EtebaseFlutter {
  Future<String?> getPlatformVersion() =>
      EtebaseFlutterPlatform.instance.getPlatformVersion();
}
