import 'dart:ffi';
import 'dart:io';

const _libEtebaseBasePath = 'tool/integration/libetebase/lib/';

DynamicLibrary loadLibEtebase() {
  final libraryPathOverride = Platform.environment['LIBETEBASE_PATH'];
  if (libraryPathOverride != null) {
    return DynamicLibrary.open(libraryPathOverride);
  } else if (Platform.isWindows) {
    return DynamicLibrary.open('$_libEtebaseBasePath/etebase.dll');
  } else if (Platform.isMacOS) {
    return DynamicLibrary.open('$_libEtebaseBasePath/libetebase.dylib');
  } else {
    return DynamicLibrary.open('$_libEtebaseBasePath/libetebase.so');
  }
}
