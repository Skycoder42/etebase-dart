import 'dart:io';

import 'github/github_env.dart';
import 'github/github_logger.dart';
import 'targets/android_target.dart';
import 'targets/build_target_base.dart';

Future<void> main(List<String> args) => GithubLogger.runZoned(() async {
      final etebaseVersion = args[0];
      const target = AndroidTarget.arm64_v8a;

      final tmpDir = await GithubEnv.runnerTemp.createTemp();
      try {
        await _prepareRustTarget(target);
        await _cloneRepo(tmpDir, target, etebaseVersion);
        await _build(tmpDir, target);
      } finally {
        await tmpDir.delete(recursive: true);
      }
    });

Future<void> _prepareRustTarget(BuildTargetBase target) =>
    GithubLogger.logGroupAsync('Install Rust target ${target.rustTarget}',
        () async {
      await GithubEnv.run('rustup', ['target', 'add', target.rustTarget]);
    });

Future<void> _cloneRepo(
  Directory tmpDir,
  BuildTargetBase target,
  String etebaseVersion,
) =>
    GithubLogger.logGroupAsync(
      'Preparing libetebase sources',
      () async {
        final srcDir = Directory.fromUri(tmpDir.uri.resolve('libetebase'));

        GithubLogger.logInfo('Cloning libetebase repository');
        await GithubEnv.run('git', [
          'clone',
          'https://github.com/etesync/libetebase',
          '-b',
          'v$etebaseVersion',
          srcDir.path,
        ]);

        if (target.openSslVendored) {
          GithubLogger.logInfo('Settings OpenSSL to vendored');
          await _setOpenSslVendored(srcDir);
        }

        GithubLogger.logInfo('Deleting Cargo.lock');
        await File.fromUri(srcDir.uri.resolve('Cargo.lock')).delete();
      },
    );

Future<void> _build(Directory srcDir, BuildTargetBase target) =>
    GithubLogger.logGroupAsync('Building libetebase for $target', () async {
      await GithubEnv.run(
        'cargo',
        [
          'build',
          '--release',
          '--target',
          target.rustTarget,
          ...target.extraBuildArgs,
        ],
        environment: target.buildEnv,
        workingDirectory: srcDir,
      );
    });

Future<void> _setOpenSslVendored(Directory srcDir) async {
  final openSslVersion = await _getLockedPackageVersion(srcDir, 'openssl');

  final cargoEntry = '''
openssl = { version = "^$openSslVersion", features = ["vendored"] }
''';

  final cargoFile = File.fromUri(srcDir.uri.resolve('Cargo.toml'));
  await cargoFile.writeAsString(
    cargoEntry,
    mode: FileMode.append,
    flush: true,
  );
}

Future<String> _getLockedPackageVersion(
  Directory srcDir,
  String packageName,
) async {
  final cargoLockFile = File.fromUri(srcDir.uri.resolve('Cargo.lock'));
  final cargoPackages = await cargoLockFile.readAsLines();

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
