import 'dart:convert';
import 'dart:io';

import 'github_logger.dart';

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
        : Directory.fromUri(Directory.current.uri.resolve('../..'));
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

  static Stream<String> invoke(
    String executable,
    List<String> arguments, {
    Directory? workingDirectory,
    int? expectedExitCode = 0,
  }) async* {
    // ignore: avoid_print
    print('[command] $executable ${arguments.join(' ')}');
    final process = await Process.start(
      executable,
      arguments,
      workingDirectory: workingDirectory?.path,
    );

    process.stderr
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(GithubLogger.logWarning);

    yield* process.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    if (expectedExitCode != null) {
      final exitCode = await process.exitCode;
      if (exitCode != expectedExitCode) {
        throw Exception('Process $executable failed with exit code: $exitCode');
      }
    }
  }

  static Future<void> setOutput(
    String name,
    Object? value, {
    bool multiline = false,
  }) async {
    final githubOutput = Platform.environment['GITHUB_OUTPUT'];
    if (githubOutput == null) {
      throw Exception('Cannot set output! GITHUB_OUTPUT env var is not set');
    }

    final githubOutputFile = File(githubOutput);
    if (multiline) {
      await githubOutputFile.writeAsString(
        '$name<<EOF\n${value}EOF\n',
        mode: FileMode.append,
      );
    } else {
      await githubOutputFile.writeAsString(
        '$name=$value\n',
        mode: FileMode.append,
      );
    }
  }
}
