import 'dart:ffi';

import 'package:etebase/etebase.dart';

import '../etebase_flutter_platform.dart';

/// Linux implementation of [EtebaseFlutterPlatform]
class EtebaseFlutterLinux extends EtebaseFlutterPlatform {
  /// @nodoc
  static void registerWith() {
    EtebaseFlutterPlatform.instance = EtebaseFlutterLinux();
  }

  @override
  LoadLibetebaseFn get loadLibetebase => _loadLibetebase;

  static DynamicLibrary _loadLibetebase() => DynamicLibrary.process();
}
