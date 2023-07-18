import 'dart:io';

import '../util/fs.dart';
import 'build_platform.dart';
import 'build_target.dart';

final class LinuxTarget extends BuildTarget {
  const LinuxTarget();

  @override
  String get name => 'linux';

  @override
  String get rustTarget => 'x86_64-unknown-linux-gnu';

  @override
  bool get openSslVendored => false;

  @override
  String get binaryName => 'libetebase.so';
}

final class LinuxPlatform extends BuildPlatform<LinuxTarget> {
  const LinuxPlatform();

  @override
  String get name => 'linux';

  @override
  List<LinuxTarget> get targets => const [
        LinuxTarget(),
      ];

  @override
  Directory installDir(Directory platformDir) => platformDir.subDir('lib');

  @override
  Future<void> createBundleImpl(
    Directory bundleDir,
    String version,
    Map<LinuxTarget, File> binaries,
  ) async {
    final MapEntry(key: target, value: binary) = binaries.entries.single;
    final targetPath = bundleDir.subFile(target.binaryName).path;

    final segments = version.split('.');
    final [major, minor, ...] = segments;

    final bundleBinary = await binary.rename('$targetPath.$version');
    final binaryName = bundleBinary.uri.pathSegments.last;
    await Link('$targetPath.$major.$minor').create(binaryName);
    await Link('$targetPath.$major').create(binaryName);
    await Link(targetPath).create(binaryName);
  }
}
