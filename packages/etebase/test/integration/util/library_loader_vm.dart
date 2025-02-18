import 'dart:ffi';
import 'dart:io';

import 'package:path/path.dart' as path;

const kIsWeb = false;

DynamicLibrary getLibsodium() {
  if (Platform.isLinux) {
    final pkgConfPath =
        Process.runSync('pkgconf', const ['--path', 'libsodium']).stdout
            as String;
    final libPath = path.canonicalize(
      path.join(path.dirname(pkgConfPath), '../libsodium.so'),
    );
    return DynamicLibrary.open(libPath);
  } else if (Platform.isMacOS) {
    final prefix = Platform.environment['HOMEBREW_PREFIX'] ?? '/opt/homebrew';
    return DynamicLibrary.open('$prefix/lib/libsodium.dylib');
  } else if (Platform.isWindows) {
    return DynamicLibrary.open('tool/integration/cache/sodium/libsodium.dll');
  } else {
    throw UnsupportedError(
      'Platform ${Platform.operatingSystem} is not supported',
    );
  }
}
