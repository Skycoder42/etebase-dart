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
  final archivesDir = workspaceDir.subDir('archive');
  final publishDir = workspaceDir.subDir('publish');
  final secretKey = GithubEnv.runnerTemp.subFile('minisign.key');

  for (final platform in PlatformTargets.values) {
    final platformBundleDir =
        await archivesDir.subDir(platform.name).create(recursive: true);
    await _createBundle(platform, version, artifactsDir, platformBundleDir);
  }
}

Future<void> _createBundle(
  BuildPlatform platform,
  String version,
  Directory artifactsDir,
  Directory bundleDir,
) =>
    GithubLogger.logGroupAsync('Bundling binaries for ${platform.name}',
        () async {
      final binaryMap = {
        for (final target in platform.targets)
          target: artifactsDir.subFile(
            'libetebase-${target.name}/${target.binaryName}',
          ),
      };

      await platform.createBundle(bundleDir, version, binaryMap);
    });
