import 'dart:ffi';

import 'package:etebase/etebase.dart';

import '../etebase_flutter_platform.dart';

class EtebaseFlutterIos extends EtebaseFlutterPlatform {
  static void registerWith() {
    EtebaseFlutterPlatform.instance = EtebaseFlutterIos();
  }

  @override
  LoadLibetebaseFn get loadLibetebase => _loadLibetebase;

  static DynamicLibrary _loadLibetebase() => DynamicLibrary.process();
}
