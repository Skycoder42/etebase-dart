import 'dart:io';

import '../util/fs.dart';
import 'build_platform.dart';
import 'build_target.dart';

final class WindowsTarget extends BuildTarget {
  const WindowsTarget();

  @override
  String get name => 'windows';

  @override
  String get rustTarget => 'x86_64-pc-windows-msvc';

  @override
  bool get openSslVendored => false;

  @override
  String get binaryName => 'etebase.dll';

  @override
  Map<String, String> get buildEnv => const {
        'OPENSSL_DIR': r'C:\Program Files\OpenSSL',
      };
}

final class WindowsPlatform extends BuildPlatform<WindowsTarget> {
  const WindowsPlatform();

  @override
  String get name => 'windows';

  @override
  List<WindowsTarget> get targets => const [
        WindowsTarget(),
      ];

  @override
  Future<void> createBundleImpl(
    Directory bundleDir,
    String version,
    Map<WindowsTarget, File> binaries,
  ) async {
    final MapEntry(key: target, value: binary) = binaries.entries.single;
    final targetFile = bundleDir.subFile(target.binaryName);

    await binary.rename(targetFile.path);
  }
}
