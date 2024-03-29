import 'dart:io';

import 'package:dart_test_tools/tools.dart';

import 'build_platform.dart';
import 'build_target.dart';

final class LinuxTarget extends BuildTarget {
  static const x86_64 = LinuxTarget._(
    architecture: 'x86_64',
    rustTarget: 'x86_64-unknown-linux-gnu',
  );

  static const aarch64 = LinuxTarget._(
    architecture: 'aarch64',
    rustTarget: 'aarch64-unknown-linux-gnu',
    useCross: true,
  );

  final String _architecture;
  @override
  final String rustTarget;
  final bool _useCross;

  const LinuxTarget._({
    required String architecture,
    required this.rustTarget,
    bool useCross = false,
  })  : _architecture = architecture,
        _useCross = useCross;

  @override
  String get name => 'linux_$_architecture';

  @override
  String get binaryName => 'libetebase.so';

  @override
  String get buildTool => _useCross ? 'cross' : super.buildTool;

  @override
  Future<void> fixupSources(Directory srcDir) async {
    if (_useCross) {
      await Github.exec(
        'cargo',
        const ['install', '-f', 'cross'],
        workingDirectory: srcDir,
      );
    }
  }

  @override
  Future<void> postBuild(Directory srcDir, File binary) async {
    await Github.exec('patchelf', [
      '--set-soname',
      'libetebase.so',
      binary.path,
    ]);
  }
}

final class LinuxPlatform extends BuildPlatform<LinuxTarget> {
  const LinuxPlatform();

  @override
  String get name => 'linux';

  @override
  List<LinuxTarget> get targets => const [
        LinuxTarget.x86_64,
        LinuxTarget.aarch64,
      ];

  @override
  Directory installDir(Directory platformDir) => platformDir.subDir('lib');

  @override
  Future<void> createBundleImpl(
    Directory bundleDir,
    String version,
    Map<LinuxTarget, File> binaries,
  ) async {
    for (final MapEntry(key: target, value: binary) in binaries.entries) {
      final archDir = await bundleDir.subDir(target._architecture).create();
      await binary.rename(archDir.subFile(target.binaryName).path);
    }
  }
}
