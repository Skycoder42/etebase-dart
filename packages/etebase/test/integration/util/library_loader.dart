import 'dart:ffi';
import 'dart:io';

DynamicLibrary loadLibEtebase() {
  final libraryPathOverride = Platform.environment['LIBETEBASE_PATH'];
  if (libraryPathOverride != null) {
    return DynamicLibrary.open(libraryPathOverride);
  } else if (Platform.isWindows) {
    return DynamicLibrary.open(
      Directory.current.uri
          .resolve('tool/integration/etebase.dll')
          .toFilePath(),
    );
  } else {
    return DynamicLibrary.open('/usr/lib/libetebase.so');
  }
}
