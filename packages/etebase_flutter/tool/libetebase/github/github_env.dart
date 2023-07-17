import 'dart:io';

import '../util/fs.dart';

abstract class GithubEnv {
  GithubEnv._();

  static Directory get runnerTemp {
    final runnerTemp = Platform.environment['RUNNER_TEMP'];
    return runnerTemp != null ? Directory(runnerTemp) : Directory.systemTemp;
  }

  static Directory get githubWorkspace {
    final githubWorkspace = Platform.environment['GITHUB_WORKSPACE'];
    return githubWorkspace != null
        ? Directory(githubWorkspace)
        : Directory.current.subDir('../..');
  }

  static Future<int> run(
    String executable,
    List<String> arguments, {
    Directory? workingDirectory,
    Map<String, String>? environment,
    int? expectedExitCode = 0,
  }) async {
    // ignore: avoid_print
    print('[command] $executable ${arguments.join(' ')}');
    final process = await Process.start(
      executable,
      arguments,
      workingDirectory: workingDirectory?.path,
      environment: environment,
      mode: ProcessStartMode.inheritStdio,
    );

    final exitCode = await process.exitCode;
    if (expectedExitCode != null && exitCode != expectedExitCode) {
      throw Exception('Process $executable failed with exit code: $exitCode');
    }
    return exitCode;
  }
}
