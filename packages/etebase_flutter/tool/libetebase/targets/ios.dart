import 'dart:io';

import '../github/github_env.dart';
import '../github/github_logger.dart';
import 'build_platform.dart';
import 'build_target.dart';

final class IosTarget extends BuildTarget {
  static const arm64 = IosTarget._(
    architecture: 'arm64',
    rustTarget: 'aarch64-apple-ios',
  );

  // TODO pull request
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
        'SODIUM_LIB_DIR': '${GithubEnv.runnerTemp.path}/libsodium',
      };

  @override
  Future<void> fixupSources(Directory srcDir) async {
    GithubLogger.logInfo('Applying darwin patch');
    await GithubEnv.run(
      'git',
      [
        'apply',
        '${GithubEnv.githubWorkspace.path}/packages/etebase/tool/integration/libetebase-macos.patch',
      ],
      workingDirectory: srcDir,
    );

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

      final lipoSlice =
          _isSimulator ? 'ios-arm64_x86_64-simulator' : 'ios-arm64';
      await Directory('${GithubEnv.runnerTemp.path}/libsodium').create();
      await GithubEnv.run(
        'lipo',
        [
          '-thin',
          _architecture,
          'libsodium.xcframework/$lipoSlice/libsodium.a',
          '-output',
          '${GithubEnv.runnerTemp.path}/libsodium/libsodium.a',
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
    final file = File.fromUri(targetDir.uri.resolve(fileName));
    await response.pipe(file.openWrite());
  }
}

final class IosPlatform extends BuildPlatform<IosTarget> {
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
    Map<IosTarget, File> binaries,
  ) async {
    final tmpDir = await GithubEnv.runnerTemp.createTemp();
    try {
      final iosBinaryArchive = await _createLipoBinary(
        tmpDir,
        'ios',
        binaries.entries.where((e) => !e.key._isSimulator).toList(),
      );

      final iosSimulatorBinary = await _createLipoBinary(
        tmpDir,
        'ios-simulator',
        binaries.entries.where((e) => e.key._isSimulator).toList(),
      );

      await _createXcFramework(bundleDir, [
        iosBinaryArchive,
        iosSimulatorBinary,
      ]);
    } finally {
      await tmpDir.delete(recursive: true);
    }
  }

  Future<File> _createLipoBinary(
    Directory tmpDir,
    String prefix,
    List<MapEntry<IosTarget, File>> binaries,
  ) async {
    final targetFile = File('${tmpDir.path}/$prefix/libetebase.a');
    await targetFile.parent.create(recursive: true);
    await GithubEnv.run('lipo', [
      '-create',
      ...binaries.map((e) => e.value.path),
      '-output',
      targetFile.path,
    ]);

    return targetFile;
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
      '${targetDir.path}/libetebase.xcframework',
    ]);
  }
}
