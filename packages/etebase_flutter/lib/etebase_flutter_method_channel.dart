import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'etebase_flutter_platform_interface.dart';

/// An implementation of [EtebaseFlutterPlatform] that uses method channels.
class MethodChannelEtebaseFlutter extends EtebaseFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('etebase_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
