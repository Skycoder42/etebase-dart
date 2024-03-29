import 'dart:io';

import 'package:dart_test_tools/tools.dart';

import 'darwin.dart';

final class MacosTarget extends DarwinTarget {
  static const arm64 = MacosTarget._(
    architecture: 'arm64',
    rustTarget: 'aarch64-apple-darwin',
  );

  static const x86_64 = MacosTarget._(
    architecture: 'x86_64',
    rustTarget: 'x86_64-apple-darwin',
  );

  final String _architecture;
  @override
  final String rustTarget;

  const MacosTarget._({
    required String architecture,
    required this.rustTarget,
  }) : _architecture = architecture;

  @override
  String get name => 'macos_$_architecture';

  @override
  String get binaryName => 'libetebase.dylib';

  @override
  Map<String, String> get buildEnv => const {
        'MACOSX_DEPLOYMENT_TARGET': '10.14',
      };

  @override
  Future<void> fixupSources(Directory srcDir) => applyPatch(srcDir);
}

final class MacosPlatform extends DarwinPlatform<MacosTarget> {
  const MacosPlatform();

  @override
  String get name => 'macos';

  @override
  List<MacosTarget> get targets => const [
        MacosTarget.arm64,
        MacosTarget.x86_64,
      ];

  @override
  Future<void> createBundleImpl(
    Directory bundleDir,
    String version,
    Map<MacosTarget, File> binaries,
  ) async {
    final libsodiumDylib = await createLipoBinary(
      bundleDir,
      'libetebase.dylib',
      binaries.entries.map((e) => e.value),
    );

    await Github.exec('install_name_tool', [
      '-id',
      '@rpath/libetebase.dylib',
      libsodiumDylib.path,
    ]);
  }
}
