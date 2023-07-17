import 'dart:io';

import 'github/github_env.dart';
import 'github/github_logger.dart';
import 'targets/build_platform.dart';
import 'targets/platform_targets.dart';
import 'util/fs.dart';

void main(List<String> args) async {
  final version = args[0];
  final workspaceDir = GithubEnv.githubWorkspace;
  final artifactsDir = workspaceDir.subDir('artifacts');
  final publishDir = workspaceDir.subDir('publish');
  final secretKey = GithubEnv.runnerTemp.subFile('minisign.key');

  for (final platform in PlatformTargets.values) {
    await _createPublishArchive(
      platform,
      version,
      artifactsDir,
      publishDir,
      secretKey,
    );
  }
}

Future<void> _createPublishArchive(
  BuildPlatform platform,
  String version,
  Directory artifactsDir,
  Directory publishDir,
  File secretKey,
) =>
    GithubLogger.logGroupAsync('Publishing binaries for ${platform.name}',
        () async {
      final binaryMap = {
        for (final target in platform.targets)
          target: artifactsDir.subFile(
            'libetebase-${target.name}/${target.binaryName}',
          ),
      };

      final tmpDir = await GithubEnv.runnerTemp.createTemp();
      try {
        await platform.createBundle(tmpDir, version, binaryMap);

        final archive = publishDir.subFile(
          'libetebase-$version-${platform.name}.tar.xz',
        );
        await _compress(tmpDir, archive);
        await _sign(archive, secretKey);
      } finally {
        await tmpDir.delete(recursive: true);
      }
    });

Future<void> _compress(Directory srcDir, File targetFile) async {
  await GithubEnv.run(
    'tar',
    ['-cavf', targetFile.path, '.'],
    workingDirectory: srcDir,
  );
}

Future<void> _sign(File file, File secretKeyFile) async {
  await GithubEnv.run('minisign', [
    '-Ss',
    secretKeyFile.path,
    '-m',
    file.path,
  ]);
}
