import 'dart:io';

import 'github/github_env.dart';
import 'targets/build_platform.dart';
import 'targets/platform_targets.dart';
import 'util/fs.dart';

Future<void> main(List<String> args) async {
  final version = args[0];
  final platforms = args.length == 1
      ? PlatformTargets.values
      : args.skip(1).map(PlatformTargets.findPlatformByName);

  for (final platform in platforms) {
    await _downloadArtifact(version, platform);
  }
}

Future<void> _downloadArtifact(String version, BuildPlatform platform) async {
  final platformDir = Directory(platform.name);

  final tmpDir = await GithubEnv.runnerTemp.createTemp();
  final client = HttpClient();
  try {
    // download archive
    final archive = await _downloadReleaseFile(
      client: client,
      targetDir: tmpDir,
      version: version,
      platformName: platform.name,
    );

    // verify signature
    await _verify(archive);

    // extract to platform dir
    final targetDir =
        await platform.installDir(platformDir).create(recursive: true);
    await _extract(archive, targetDir);
  } finally {
    client.close();
    await tmpDir.delete(recursive: true);
  }
}

Future<File> _downloadReleaseFile({
  required HttpClient client,
  required Directory targetDir,
  required String version,
  required String platformName,
  bool withSignature = true,
  String suffix = '',
}) async {
  final fileName = 'libetebase-$version-$platformName.tar.xz$suffix';
  final file = targetDir.subFile(fileName);

  final request = await client.getUrl(
    Uri.parse(
      'https://github.com/Skycoder42/etebase-dart/releases/download/libetebase-binaries%2Fv$version/$fileName',
    ),
  );
  final response = await request.close();
  await response.pipe(file.openWrite());

  if (withSignature) {
    await _downloadReleaseFile(
      client: client,
      targetDir: targetDir,
      version: version,
      platformName: platformName,
      withSignature: false,
      suffix: '.minisig',
    );
  }

  return file;
}

Future<void> _verify(File file) async {
  await GithubEnv.run('minisign', [
    '-P',
    'RWQ8MbpMguTBDfMOfYZiq/yEdXHLDVNeElb3WX5VIEfJfb8ij1Lo8E/x',
    '-Vm',
    file.path,
  ]);
}

Future<void> _extract(File srcFile, Directory targetDir) async {
  await GithubEnv.run(
    'tar',
    ['-xvf', srcFile.path],
    workingDirectory: targetDir,
  );
}
