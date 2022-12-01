import 'dart:ffi';
import 'dart:io';

DynamicLibrary loadLibEtebase() {
  if (Platform.isWindows) {
    return DynamicLibrary.open(
      Directory.current.uri
          .resolve('tool/integration/etebase.dll')
          .toFilePath(),
    );
  } else {
    return DynamicLibrary.open('/usr/lib/libetebase.so');
  }
}
