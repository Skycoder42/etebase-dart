import 'dart:io';

import 'package:dart_test_tools/tools.dart';

import 'build_platform.dart';
import 'build_target.dart';

final class AndroidTarget extends BuildTarget {
  static const _ndkVersion = '25.2.9519653';

  // ignore: constant_identifier_names
  static const arm64_v8a = AndroidTarget._(
    architecture: 'arm64-v8a',
    rustTarget: 'aarch64-linux-android',
  );

  // ignore: constant_identifier_names
  static const armeabi_v7a = AndroidTarget._(
    architecture: 'armeabi-v7a',
    rustTarget: 'armv7-linux-androideabi',
    compilerPrefix: 'armv7a-linux-androideabi',
  );

  static const x86_64 = AndroidTarget._(
    architecture: 'x86',
    rustTarget: 'i686-linux-android',
  );

  static const x86 = AndroidTarget._(
    architecture: 'x86_64',
    rustTarget: 'x86_64-linux-android',
  );

  final String _architecture;
  @override
  final String rustTarget;
  final String _compilerPrefix;
  final int _minSdkVersion;

  const AndroidTarget._({
    required String architecture,
    required this.rustTarget,
    String? compilerPrefix,
    int minSdkVersion = 21,
  })  : _architecture = architecture,
        _compilerPrefix = compilerPrefix ?? rustTarget,
        _minSdkVersion = minSdkVersion;

  @override
  String get name => 'android_$_architecture';

  @override
  bool get openSslVendored => true;

  @override
  String get binaryName => 'libetebase.so';

  @override
  List<String> get extraBuildArgs {
    final linkerFile = Directory.current.subFile('android/my-hacky-linker-cc');
    return [
      '--config',
      'target.$rustTarget.linker="${linkerFile.absolute.path}"',
    ];
  }

  @override
  Map<String, String> get buildEnv {
    final androidHome = Platform.environment['ANDROID_HOME'];
    final toolchainPath =
        '$androidHome/ndk/$_ndkVersion/toolchains/llvm/prebuilt/$_hostArch/bin';
    return {
      'PATH': '$toolchainPath:${Platform.environment['PATH']}',
      'CC': '$_compilerPrefix$_minSdkVersion-clang',
      'CXX': '$_compilerPrefix$_minSdkVersion-clang++',
      'AR': 'llvm-ar',
      'RANLIB': 'llvm-ranlib',
    };
  }

  String get _hostArch {
    if (Platform.isLinux) {
      return 'linux-x86_64';
    } else if (Platform.isMacOS) {
      return 'darwin-x86_64';
    } else if (Platform.isWindows) {
      return 'windows-x86_64';
    } else {
      throw UnsupportedError(
        'Unsupported build platform: ${Platform.operatingSystem}',
      );
    }
  }
}

final class AndroidPlatform extends BuildPlatform<AndroidTarget> {
  const AndroidPlatform();

  @override
  String get name => 'android';

  @override
  List<AndroidTarget> get targets => const [
        AndroidTarget.arm64_v8a,
        AndroidTarget.armeabi_v7a,
        AndroidTarget.x86_64,
        AndroidTarget.x86,
      ];

  @override
  Directory installDir(Directory platformDir) =>
      platformDir.subDir('src/main/jniLibs');

  @override
  Future<void> createBundleImpl(
    Directory bundleDir,
    String version,
    Map<AndroidTarget, File> binaries,
  ) async {
    for (final MapEntry(key: target, value: binary) in binaries.entries) {
      final targetFile = bundleDir.subFile(
        '${target._architecture}/${target.binaryName}',
      );
      await targetFile.parent.create(recursive: true);
      await binary.rename(targetFile.path);
    }
  }
}
