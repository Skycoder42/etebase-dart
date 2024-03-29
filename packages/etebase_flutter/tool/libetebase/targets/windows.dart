import 'dart:io';

import 'package:dart_test_tools/tools.dart';

import 'build_platform.dart';
import 'build_target.dart';

final class WindowsTarget extends BuildTarget {
  const WindowsTarget();

  @override
  String get name => 'windows';

  @override
  String get rustTarget => 'x86_64-pc-windows-msvc';

  @override
  String get binaryName => 'etebase.dll';
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
  String get archiveSuffix => 'zip';

  @override
  Directory installDir(Directory platformDir) => platformDir.subDir('lib');

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
