import 'dart:ffi';

import 'package:etebase/etebase.dart';

import '../etebase_flutter_platform.dart';

class EtebaseFlutterLinux extends EtebaseFlutterPlatform {
  static void registerWith() {
    EtebaseFlutterPlatform.instance = EtebaseFlutterLinux();
  }

  @override
  LoadLibetebaseFn get loadLibetebase => _loadLibetebase;

  static DynamicLibrary _loadLibetebase() => DynamicLibrary.process();
}
