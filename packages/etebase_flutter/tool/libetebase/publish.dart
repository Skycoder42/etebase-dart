import 'dart:io';

import 'package:dart_test_tools/tools.dart';

import 'targets/build_platform.dart';
import 'targets/platform_targets.dart';

void main(List<String> args) async {
  final version = args[0];
  final workspaceDir = Github.env.githubWorkspace;
  final artifactsDir = workspaceDir.subDir('artifacts');
  final publishDir = await workspaceDir.subDir('publish').create();
  final secretKey = Github.env.runnerTemp.subFile('minisign.key');

  await Github.logGroupAsync(
    'Ensure minisign is installed',
    Minisign.ensureInstalled,
  );

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
    Github.logGroupAsync('Publishing binaries for ${platform.name}', () async {
      final binaryMap = {
        for (final target in platform.targets)
          target: artifactsDir.subFile(
            'libetebase-${target.name}/${target.binaryName}',
          ),
      };

      final tmpDir = await Github.env.runnerTemp.createTemp();
      try {
        await platform.createBundle(tmpDir, version, binaryMap);

        final archive = publishDir.subFile(
          'libetebase-$version-${platform.name}.${platform.archiveSuffix}',
        );
        await Archive.compress(inDir: tmpDir, archive: archive);
        await Minisign.sign(archive, secretKey);
      } finally {
        await tmpDir.delete(recursive: true);
      }
    });
