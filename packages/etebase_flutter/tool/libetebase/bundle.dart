import 'dart:io';

import 'github/github_logger.dart';
import 'targets/build_platform.dart';
import 'targets/platform_targets.dart';

void main(List<String> args) async {
  final artifactsDir = Directory(args[0]);
  final bundleDir = Directory(args[1]);

  for (final platform in PlatformTargets.values) {
    final platformBundleDir = await Directory.fromUri(
      bundleDir.uri.resolve(platform.name),
    ).create(recursive: true);
    await _createBundle(platform, artifactsDir, platformBundleDir);
  }
}

Future<void> _createBundle(
  BuildPlatform platform,
  Directory artifactsDir,
  Directory bundleDir,
) =>
    GithubLogger.logGroupAsync('Bundling binaries for ${platform.name}',
        () async {
      final binaryMap = {
        for (final target in platform.targets)
          target: File.fromUri(
            artifactsDir.uri
                .resolve('libetebase-${target.name}/${target.binaryName}'),
          ),
      };

      await platform.createBundle(bundleDir, binaryMap);
    });
