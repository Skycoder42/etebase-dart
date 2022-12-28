import 'package:etebase/etebase.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class EtebaseFlutterPlatform extends PlatformInterface {
  EtebaseFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static late EtebaseFlutterPlatform _instance;

  static EtebaseFlutterPlatform get instance => _instance;

  static set instance(EtebaseFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    Etebase.ensureInitialized(instance.loadLibetebase, overwrite: true);
    _instance = instance;
  }

  void configure({
    EtebaseConfig config = const EtebaseConfig(),
    int? logLevel,
  }) =>
      Etebase.ensureInitialized(
        loadLibetebase,
        config: config,
        logLevel: logLevel,
        overwrite: true,
      );

  LoadLibetebaseFn get loadLibetebase;
}
