import 'dart:ffi';

import 'package:etebase/etebase.dart';

import '../etebase_flutter_platform.dart';

class EtebaseFlutterWindows extends EtebaseFlutterPlatform {
  static void registerWith() {
    EtebaseFlutterPlatform.instance = EtebaseFlutterWindows();
  }

  @override
  LoadLibetebaseFn get loadLibetebase => _loadLibetebase;

  static DynamicLibrary _loadLibetebase() => DynamicLibrary.open('etebase.dll');
}
