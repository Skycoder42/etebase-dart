import 'dart:ffi';
import 'dart:io';

DynamicLibrary loadLibEtebase() {
  if (Platform.isWindows) {
    return DynamicLibrary.open(r'C:\usr\lib\libetebase.dll');
  } else {
    return DynamicLibrary.open('/usr/lib/libetebase.so');
  }
}
