import 'dart:io';

import '../github/github_env.dart';
import '../github/github_logger.dart';
import '../util/fs.dart';
import 'darwin.dart';

final class IosTarget extends DarwinTarget {
  static const arm64 = IosTarget._(
    architecture: 'arm64',
    rustTarget: 'aarch64-apple-ios',
  );

  static const simulator_arm64 = IosTarget._(
    architecture: 'arm64',
    rustTarget: 'aarch64-apple-ios-sim',
    isSimulator: true,
  );

  static const simulator_x86_64 = IosTarget._(
    architecture: 'x86_64',
    rustTarget: 'x86_64-apple-ios',
    isSimulator: true,
  );

  final String _architecture;
  @override
  final String rustTarget;
  final bool _isSimulator;

  const IosTarget._({
    required String architecture,
    required this.rustTarget,
    bool isSimulator = false,
  })  : _architecture = architecture,
        _isSimulator = isSimulator;

  @override
  String get name =>
      _isSimulator ? 'ios_simulator_$_architecture' : 'ios_$_architecture';

  @override
  bool get openSslVendored => true;

  @override
  String get binaryName => 'libetebase.a';

  @override
  Map<String, String> get buildEnv => {
        'IPHONEOS_DEPLOYMENT_TARGET': '11.0',
        'SODIUM_LIB_DIR': GithubEnv.runnerTemp.subDir('libsodium/$name').path,
      };

  @override
  Future<void> fixupSources(Directory srcDir) async {
    await applyPatch(srcDir);
    await _downloadLibsodiumBinary(srcDir);
  }

  Future<void> _downloadLibsodiumBinary(Directory srcDir) async {
    GithubLogger.logInfo('Downloading libsodium binaries');
    final client = HttpClient();
    final tmpDir = await GithubEnv.runnerTemp.createTemp();
    try {
      const archiveName = 'libsodium-1.0.18-ios.tar.xz';

      await _downloadReleaseFile(client, tmpDir, archiveName);
      await _downloadReleaseFile(client, tmpDir, '$archiveName.minisig');

      await GithubEnv.run(
        'minisign',
        const [
          '-P',
          'RWQV/WsoL5F1nbrM9y7gJtszibGirYi+hNUI4P3orTZD8dZBCsBd7D/h',
          '-Vm',
          archiveName
        ],
        workingDirectory: tmpDir,
      );

      await GithubEnv.run(
        'tar',
        const ['-xvf', archiveName],
        workingDirectory: tmpDir,
      );

      final frameworkSlice =
          _isSimulator ? 'ios-arm64_x86_64-simulator' : 'ios-arm64';
      final outDir = await GithubEnv.runnerTemp
          .subDir('libsodium/$name')
          .create(recursive: true);
      await GithubEnv.run(
        'lipo',
        [
          '-thin',
          _architecture,
          'libsodium.xcframework/$frameworkSlice/libsodium.a',
          '-output',
          outDir.subFile('libsodium.a').path,
        ],
        workingDirectory: tmpDir,
      );
    } finally {
      client.close();
      await tmpDir.delete(recursive: true);
    }
  }

  Future<void> _downloadReleaseFile(
    HttpClient client,
    Directory targetDir,
    String fileName,
  ) async {
    final request = await client.getUrl(
      Uri.parse(
        'https://github.com/Skycoder42/libsodium_dart_bindings/releases/download/libsodium-binaries%2Fv1.0.18/$fileName',
      ),
    );
    final response = await request.close();
    await response.pipe(targetDir.subFile(fileName).openWrite());
  }
}

final class IosPlatform extends DarwinPlatform<IosTarget> {
  const IosPlatform();

  @override
  String get name => 'ios';

  @override
  List<IosTarget> get targets => const [
        IosTarget.arm64,
        IosTarget.simulator_arm64,
        IosTarget.simulator_x86_64,
      ];

  @override
  Future<void> createBundleImpl(
    Directory bundleDir,
    String version,
    Map<IosTarget, File> binaries,
  ) async {
    final tmpDir = await GithubEnv.runnerTemp.createTemp();
    try {
      final iosBinaryArchive = await createLipoBinary(
        tmpDir,
        prefix: 'ios',
        'libetebase.a',
        binaries.entries.where((e) => !e.key._isSimulator).map((e) => e.value),
      );

      final iosSimulatorBinary = await createLipoBinary(
        tmpDir,
        prefix: 'ios-simulator',
        'libetebase.a',
        binaries.entries.where((e) => e.key._isSimulator).map((e) => e.value),
      );

      await _createXcFramework(bundleDir, [
        iosBinaryArchive,
        iosSimulatorBinary,
      ]);
    } finally {
      await tmpDir.delete(recursive: true);
    }
  }

  Future<void> _createXcFramework(
    Directory targetDir,
    Iterable<File> libraries,
  ) async {
    await GithubEnv.run('xcodebuild', [
      '-create-xcframework',
      for (final library in libraries) ...[
        '-library',
        library.path,
      ],
      '-output',
      targetDir.subDir('libetebase.xcframework').path,
    ]);
  }
}
