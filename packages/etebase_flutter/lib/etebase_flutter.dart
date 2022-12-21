
import 'etebase_flutter_platform_interface.dart';

class EtebaseFlutter {
  Future<String?> getPlatformVersion() {
    return EtebaseFlutterPlatform.instance.getPlatformVersion();
  }
}
