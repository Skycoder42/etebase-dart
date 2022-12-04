import 'dart:ffi';
import 'dart:io';

const _libEtebaseBasePath = 'tool/integration/libetebase/lib/';

DynamicLibrary loadLibEtebase() {
  final libraryPathOverride = Platform.environment['LIBETEBASE_PATH'];
  if (libraryPathOverride != null) {
    return DynamicLibrary.open(libraryPathOverride);
  } else if (Platform.isWindows) {
    return _open('etebase.dll');
  } else if (Platform.isMacOS) {
    return _open('libetebase.dylib');
  } else {
    return _open('libetebase.so');
  }
}

DynamicLibrary _open(String fileName) {
  final file = File('$_libEtebaseBasePath/$fileName');
  assert(file.existsSync(), 'Dynamic library "${file.path}" does not exist');
  return DynamicLibrary.open(file.absolute.path);
}
