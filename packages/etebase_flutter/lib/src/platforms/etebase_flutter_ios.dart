import 'dart:ffi';

import 'package:etebase/etebase.dart';

import '../etebase_flutter_platform.dart';

/// iOS implementation of [EtebaseFlutterPlatform]
class EtebaseFlutterIos extends EtebaseFlutterPlatform {
  /// @nodoc
  static void registerWith() {
    EtebaseFlutterPlatform.instance = EtebaseFlutterIos();
  }

  @override
  LoadLibetebaseFn get loadLibetebase => _loadLibetebase;

  static DynamicLibrary _loadLibetebase() => DynamicLibrary.process();
}
