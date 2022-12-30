import 'package:etebase/etebase.dart';
import 'package:flutter/widgets.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The abstract [PlatformInterface] that must be implemented by the native
/// code.
///
/// Implementations must extend this class.
abstract class EtebaseFlutterPlatform extends PlatformInterface {
  /// Default constructor.
  EtebaseFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static late EtebaseFlutterPlatform _instance;

  /// The currently loaded native implementation.
  ///
  /// This is automatically initialized by
  /// [WidgetsFlutterBinding.ensureInitialized] with the default platform
  /// implementation provided by this package. Accessing it before that is not
  /// allowed.
  ///
  /// You can use the setter to provide a custom implementation, if needed.
  /// Currently, the following platforms are supported:
  /// - Android
  /// - iOS
  /// - Linux
  /// - MacOS
  /// - Windows
  static EtebaseFlutterPlatform get instance => _instance;

  static set instance(EtebaseFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    Etebase.ensureInitialized(instance.loadLibetebase, overwrite: true);
    _instance = instance;
  }

  /// Updates the isolate configuration.
  ///
  /// Has no effect on already running isolates, which means you should invoke
  /// it before creating any clients. You specify a custom [config] and change
  /// the logging via [logLevel].
  ///
  /// **Note:** By default, you do not have to configure anything, as the
  /// default configuration should suffice for most applications.
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

  /// A getter that returns a static or global function to load the dynamic
  /// library.
  ///
  /// Implementation must implement this method to load their native binary.
  @protected
  LoadLibetebaseFn get loadLibetebase;
}
