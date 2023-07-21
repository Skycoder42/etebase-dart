import 'dart:io';

import 'package:dart_test_tools/tools.dart';

import 'targets/build_platform.dart';
import 'targets/platform_targets.dart';

const _publicKey = 'RWQ8MbpMguTBDfMOfYZiq/yEdXHLDVNeElb3WX5VIEfJfb8ij1Lo8E/x';

Future<void> main(List<String> args) async {
  final version = args[0];
  final platforms = args.length == 1
      ? PlatformTargets.values
      : args.skip(1).map(PlatformTargets.findPlatformByName);

  await Github.logGroupAsync(
    'Ensure minisign is installed',
    Minisign.ensureInstalled,
  );

  for (final platform in platforms) {
    await _downloadArtifact(version, platform);
  }
}

Future<void> _downloadArtifact(String version, BuildPlatform platform) =>
    Github.logGroupAsync('Download binary archive for ${platform.name}',
        () async {
      final platformDir = Directory(platform.name);

      final tmpDir = await Github.env.runnerTemp.createTemp();
      final client = HttpClient();
      try {
        // download archive
        final uri = Uri.https(
          'github.com',
          '/Skycoder42/etebase-dart/releases/download/libetebase-binaries/v$version/libetebase-$version-${platform.name}.tar.xz',
        );
        Github.logDebug('Downloading $uri');
        final archive = await client.download(tmpDir, uri);

        // verify signature
        await Minisign.verify(archive, _publicKey);

        // extract to platform dir
        final targetDir =
            await platform.installDir(platformDir).create(recursive: true);
        await Archive.extract(archive: archive, outDir: targetDir);
      } finally {
        client.close();
        await tmpDir.delete(recursive: true);
      }
    });
