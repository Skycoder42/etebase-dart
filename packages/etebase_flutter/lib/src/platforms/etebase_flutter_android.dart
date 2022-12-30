import 'dart:ffi';

import 'package:etebase/etebase.dart';

import '../etebase_flutter_platform.dart';

/// Android implementation of [EtebaseFlutterPlatform]
class EtebaseFlutterAndroid extends EtebaseFlutterPlatform {
  /// @nodoc
  static void registerWith() {
    EtebaseFlutterPlatform.instance = EtebaseFlutterAndroid();
  }

  @override
  LoadLibetebaseFn get loadLibetebase => _loadLibetebase;

  static DynamicLibrary _loadLibetebase() =>
      DynamicLibrary.open('libetebase.so');
}
