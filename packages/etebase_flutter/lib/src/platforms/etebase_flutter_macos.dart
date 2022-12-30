import 'dart:ffi';

import 'package:etebase/etebase.dart';

import '../etebase_flutter_platform.dart';

/// MacOS implementation of [EtebaseFlutterPlatform]
class EtebaseFlutterMacos extends EtebaseFlutterPlatform {
  /// @nodoc
  static void registerWith() {
    EtebaseFlutterPlatform.instance = EtebaseFlutterMacos();
  }

  @override
  LoadLibetebaseFn get loadLibetebase => _loadLibetebase;

  static DynamicLibrary _loadLibetebase() => DynamicLibrary.process();
}
