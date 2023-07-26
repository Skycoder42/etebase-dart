import 'dart:io';

import 'package:dart_test_tools/tools.dart';

import 'targets/build_target.dart';
import 'targets/platform_targets.dart';

Future<void> main(List<String> args) => Github.runZoned(() async {
      final target = PlatformTargets.findTargetByName(args[0]);
      final etebaseVersion = args[1];

      await Github.logGroupAsync(
        'Ensure minisign is installed',
        Minisign.ensureInstalled,
      );

      final artifactDir = await Github.env.runnerTemp
          .subDir('libetebase-${target.name}')
          .create(recursive: true);
      final tmpDir = await Github.env.runnerTemp.createTemp();
      try {
        await _prepareRustTarget(target);
        final srcDir = await _cloneRepo(tmpDir, target, etebaseVersion);
        final binary = await _build(srcDir, target);

        await binary.rename(artifactDir.subFile(target.binaryName).path);
      } finally {
        await tmpDir.delete(recursive: true);
      }
    });

Future<void> _prepareRustTarget(BuildTarget target) => Github.logGroupAsync(
      'Install Rust target ${target.rustTarget}',
      () => Github.exec(
        'rustup',
        ['target', 'add', target.rustTarget],
      ),
    );

Future<Directory> _cloneRepo(
  Directory tmpDir,
  BuildTarget target,
  String etebaseVersion,
) =>
    Github.logGroupAsync(
      'Preparing libetebase sources',
      () async {
        final srcDir = tmpDir.subDir('libetebase');

        Github.logInfo('Cloning libetebase repository');
        await Github.exec('git', [
          'clone',
          'https://github.com/etesync/libetebase',
          '-b',
          'v$etebaseVersion',
          srcDir.path,
        ]);

        await target.fixupSources(srcDir);

        Github.logInfo('Setting OpenSSL to vendored');
        await _setOpenSslVendored(srcDir);

        Github.logInfo('Deleting Cargo.lock');
        await srcDir.subFile('Cargo.lock').delete();

        return srcDir;
      },
    );

Future<File> _build(Directory srcDir, BuildTarget target) =>
    Github.logGroupAsync('Building libetebase for ${target.name}', () async {
      await Github.exec(
        'cargo',
        [
          'build',
          ...target.extraBuildArgs,
          '--target',
          target.rustTarget,
          '--release',
        ],
        environment: target.buildEnv,
        workingDirectory: srcDir,
      );

      return srcDir
          .subFile('target/${target.rustTarget}/release/${target.binaryName}');
    });

Future<void> _setOpenSslVendored(Directory srcDir) async {
  final openSslVersion = await _getLockedPackageVersion(srcDir, 'openssl');

  final cargoEntry = '''
openssl = { version = "^$openSslVersion", features = ["vendored"] }
''';

  await srcDir.subFile('Cargo.toml').writeAsString(
        cargoEntry,
        mode: FileMode.append,
        flush: true,
      );
}

Future<String> _getLockedPackageVersion(
  Directory srcDir,
  String packageName,
) async {
  final cargoPackages = await srcDir.subFile('Cargo.lock').readAsLines();

  final versionLineSegments = cargoPackages
      .groupLockLines()
      .singleWhere((pl) => pl.contains('name = "$packageName"'))
      .singleWhere((l) => l.startsWith('version = '))
      .split('"');
  if (versionLineSegments.length != 3) {
    throw Exception('Invalid version line: ${versionLineSegments.join('"')}');
  }

  return versionLineSegments[1];
}

extension _IterableX on Iterable<String> {
  Iterable<List<String>> groupLockLines() sync* {
    var currentLines = <String>[];
    for (final line in this) {
      if (line == '[[package]]') {
        if (currentLines.isNotEmpty) {
          yield currentLines;
        }
        currentLines = [];
      } else {
        currentLines.add(line);
      }
    }
  }
}
