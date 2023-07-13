import 'dart:io';

import 'build_target_base.dart';

final class AndroidTarget extends BuildTargetBase {
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
  List<String> get extraBuildArgs => [
        '--config',
        'target.$rustTarget.linker="$android_dir/my-hacky-linker-cc"',
      ];

  @override
  Map<String, String> get buildEnv => {
        'PATH':
            '${Platform.environment['ANDROID_HOME']}/ndk/$_ndkVersion/toolchains/llvm/prebuilt/$_hostArch/bin:${Platform.environment['PATH']}',
        'AR': 'llvm-ar',
        'RANLIB': 'llvm-ranlib',
        'CC': '$_compilerPrefix$_minSdkVersion-clang',
        'CXX': '$_compilerPrefix$_minSdkVersion-clang++',
      };

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
