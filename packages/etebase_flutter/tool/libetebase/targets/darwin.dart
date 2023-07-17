import 'dart:io';

import '../github/github_env.dart';
import '../github/github_logger.dart';
import '../util/fs.dart';
import 'build_platform.dart';
import 'build_target.dart';

abstract base class DarwinTarget extends BuildTarget {
  const DarwinTarget();

  Future<void> applyPatch(Directory srcDir) async {
    GithubLogger.logInfo('Applying darwin patch');
    await GithubEnv.run(
      'git',
      [
        'apply',
        GithubEnv.githubWorkspace
            .subFile('packages/etebase/tool/integration/libetebase-macos.patch')
            .path,
      ],
      workingDirectory: srcDir,
    );
  }
}

abstract base class DarwinPlatform<T extends DarwinTarget>
    extends BuildPlatform<T> {
  const DarwinPlatform();

  Future<File> createLipoBinary(
    Directory targetDir,
    String fileName,
    Iterable<File> binaries, {
    String? prefix,
  }) async {
    final targetFile =
        targetDir.subFile(prefix != null ? '$prefix/$fileName' : fileName);
    await targetFile.parent.create(recursive: true);
    await GithubEnv.run('lipo', [
      '-create',
      ...binaries.map((file) => file.path),
      '-output',
      targetFile.path,
    ]);

    return targetFile;
  }
}
