import 'dart:ffi';

import '../../etebase_flutter.dart';

class EtebaseFlutterLinux extends EtebaseFlutterPlatform {
  static void registerWith() {
    EtebaseFlutterPlatform.instance = EtebaseFlutterAndroid();
  }

  @override
  LoadLibetebaseFn get loadLibetebase => _loadLibetebase;

  static DynamicLibrary _loadLibetebase() => DynamicLibrary.process();
}
