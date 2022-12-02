// ignore_for_file: prefer_asserts_with_message, avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

abstract class ServerController {
  factory ServerController() {
    if (Platform.isWindows) {
      return _ServerControllerWindows();
    } else {
      return _ServerControllerUnix();
    }
  }

  ServerController._();

  Future<Uri> start({
    Duration waitForReadyTimeout = const Duration(minutes: 1),
    bool autoTearDown = true,
  });

  Future<void> stop();

  Future<void> _waitForReady(
    Uri serverUri,
    Duration waitForReadyTimeout,
  ) async {
    if (waitForReadyTimeout != Duration.zero) {
      final timeout = DateTime.now().add(waitForReadyTimeout);
      final client = HttpClient();
      try {
        while (DateTime.now().isBefore(timeout)) {
          try {
            final request = await client.getUrl(serverUri);
            final response = await request.close();
            if (response.statusCode == 200) {
              print(
                'Server is ready after: '
                '${waitForReadyTimeout - timeout.difference(DateTime.now())}',
              );
              break;
            }
          } on HttpException {
            // do nothing
          }

          await Future<void>.delayed(const Duration(seconds: 1));
        }
      } finally {
        client.close();
      }
    }
  }
}

class _ServerControllerUnix extends ServerController {
  String? _containerId;

  _ServerControllerUnix() : super._();

  @override
  Future<Uri> start({
    Duration waitForReadyTimeout = const Duration(minutes: 1),
    bool autoTearDown = true,
  }) async {
    assert(_containerId == null);

    final result = await Process.run(
      'docker',
      const [
        'run',
        '-d',
        '--rm',
        '-e',
        'SUPER_USER=admin',
        '-e',
        'AUTO_SIGNUP=true',
        '-p',
        '3735:3735',
        'victorrds/etesync',
      ],
    );
    printOnFailure('Start-Errors:\n${result.stderr}');
    expect(result.exitCode, 0);

    _containerId = const LineSplitter().convert(result.stdout as String).last;
    if (autoTearDown) {
      addTearDown(stop);
    }

    final serverUri = Uri.http('localhost:3735', '/');
    await _waitForReady(serverUri, waitForReadyTimeout);
    return serverUri;
  }

  @override
  Future<void> stop() async {
    assert(_containerId != null);

    final logsResult = await Process.run('docker', ['logs', _containerId!]);
    expect(logsResult.exitCode, 0);
    printOnFailure('STDOUT:\n${logsResult.stdout}');
    printOnFailure('STDERR:\n${logsResult.stderr}');

    final sw = Stopwatch()..start();
    final stopResult = await Process.run('docker', ['stop', _containerId!]);
    sw.stop();
    print('Stopped server in ${sw.elapsed}');
    printOnFailure('Stop-Errors:\n${stopResult.stderr}');
    expect(stopResult.exitCode, 0);

    _containerId = null;
  }
}

class _ServerControllerWindows extends ServerController {
  Process? _process;
  StringBuffer? _processLog;

  _ServerControllerWindows() : super._();

  @override
  Future<Uri> start({
    Duration waitForReadyTimeout = const Duration(minutes: 1),
    bool autoTearDown = true,
  }) async {
    assert(_process == null);
    assert(_processLog == null);

    _processLog = StringBuffer();
    _process = await Process.start(
      'uvicorn',
      [
        'etebase_server.asgi:application',
        '--host',
        '127.0.0.1',
        '--port',
        '3735'
      ],
    );
    if (autoTearDown) {
      addTearDown(stop);
    }

    _pipeLogs(_process!.stdout, 'OUT');
    _pipeLogs(_process!.stderr, 'ERR');

    final serverUri = Uri.http('localhost:3735', '/');
    await _waitForReady(serverUri, waitForReadyTimeout);
    return serverUri;
  }

  @override
  Future<void> stop() async {
    assert(_process != null);
    assert(_processLog != null);

    expect(_process!.kill(), isTrue);

    final exitCode = await _process!.exitCode;
    _processLog!.write('EXIT CODE: $exitCode');

    printOnFailure(_processLog!.toString());

    _process = null;
    _processLog = null;

    expect(exitCode, 0);
  }

  void _pipeLogs(Stream<List<int>> stream, String prefix) => _process!.stderr
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .map((line) => '$prefix: $line')
      .listen(_processLog!.writeln);
}
