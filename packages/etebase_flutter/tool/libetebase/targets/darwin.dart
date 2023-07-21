import 'dart:io';

import 'package:dart_test_tools/tools.dart';

import 'build_platform.dart';
import 'build_target.dart';

abstract base class DarwinTarget extends BuildTarget {
  const DarwinTarget();

  Future<void> applyPatch(Directory srcDir) async {
    Github.logInfo('Applying darwin patch');
    await Github.exec(
      'git',
      [
        'apply',
        Github.env.githubWorkspace
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

  @override
  Directory installDir(Directory platformDir) =>
      platformDir.subDir('Libraries');

  Future<File> createLipoBinary(
    Directory targetDir,
    String fileName,
    Iterable<File> binaries, {
    String? prefix,
  }) async {
    final targetFile =
        targetDir.subFile(prefix != null ? '$prefix/$fileName' : fileName);
    await targetFile.parent.create(recursive: true);
    await Github.exec('lipo', [
      '-create',
      ...binaries.map((file) => file.path),
      '-output',
      targetFile.path,
    ]);

    return targetFile;
  }
}
