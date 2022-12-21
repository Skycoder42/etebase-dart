import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'etebase_flutter_method_channel.dart';

abstract class EtebaseFlutterPlatform extends PlatformInterface {
  /// Constructs a EtebaseFlutterPlatform.
  EtebaseFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static EtebaseFlutterPlatform _instance = MethodChannelEtebaseFlutter();

  /// The default instance of [EtebaseFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelEtebaseFlutter].
  static EtebaseFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [EtebaseFlutterPlatform] when
  /// they register themselves.
  static set instance(EtebaseFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
