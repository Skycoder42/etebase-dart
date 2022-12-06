// ignore_for_file: prefer_asserts_with_message, avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:test/test.dart';

abstract class ServerController {
  static const _serverModeDocker = 'docker';
  static const _serverModeLocal = 'local';

  factory ServerController() {
    final serverMode = Platform.environment['ETEBASE_SERVER_MODE'] ??
        (Platform.isLinux ? _serverModeDocker : _serverModeLocal);
    if (serverMode == _serverModeDocker) {
      return _ServerControllerDocker();
    } else if (serverMode == _serverModeLocal) {
      return _ServerControllerLocal();
    } else {
      throw UnsupportedError(
        'ETEBASE_SERVER_MODE $serverMode is not supported',
      );
    }
  }

  ServerController._();

  Future<Uri> start({
    Duration waitForReadyTimeout = const Duration(minutes: 1),
    bool autoTearDown = true,
  });

  Future<void> stop();

  Future<int> _getRandomPort() async {
    while (true) {
      final port = Random.secure().nextInt(9999) + 20000;
      try {
        final socket = await Socket.connect(InternetAddress.loopbackIPv4, port);
        await socket.close();
      } on SocketException {
        return port;
      }
    }
  }

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
            expect(response.statusCode, 200);
            print(
              'Server is ready after: '
              '${waitForReadyTimeout - timeout.difference(DateTime.now())}',
            );
            return;
          } on SocketException {
            // do nothing
          } on HttpException {
            // do nothing
          }

          await Future<void>.delayed(const Duration(seconds: 1));
        }

        fail('Failed to connect to server after $waitForReadyTimeout');
      } finally {
        client.close();
      }
    }
  }

  void _pipeLogs(Stream<List<int>> stream, String prefix) {
    final sub = stream
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .map((line) => 'server-$prefix: $line')
        .listen(print);
    addTearDown(sub.cancel);
  }
}

class _ServerControllerDocker extends ServerController {
  String? _containerId;
  Process? _logsProcess;

  _ServerControllerDocker() : super._();

  @override
  Future<Uri> start({
    Duration waitForReadyTimeout = const Duration(minutes: 1),
    bool autoTearDown = true,
  }) async {
    assert(_containerId == null);
    assert(_logsProcess == null);

    final port = await _getRandomPort();

    final result = await Process.run(
      'docker',
      [
        'run',
        '-d',
        '--rm',
        '-e',
        'SUPER_USER=admin',
        '-e',
        'AUTO_SIGNUP=true',
        '-p',
        '127.0.0.1:$port:3735',
        'victorrds/etesync',
      ],
    );
    printOnFailure('Start-Errors:\n${result.stderr}');
    expect(result.exitCode, 0);

    _containerId = const LineSplitter().convert(result.stdout as String).last;
    if (autoTearDown) {
      addTearDown(stop);
    }

    _logsProcess = await Process.start('docker', ['logs', '-f', _containerId!]);
    _pipeLogs(_logsProcess!.stdout, 'out');
    _pipeLogs(_logsProcess!.stderr, 'err');

    final serverUri = Uri.http('localhost:$port', '/');
    await _waitForReady(serverUri, waitForReadyTimeout);
    return serverUri;
  }

  @override
  Future<void> stop() async {
    assert(_containerId != null);

    final sw = Stopwatch()..start();
    final stopResult = await Process.run('docker', ['stop', _containerId!]);
    sw.stop();
    print('Stopped server in ${sw.elapsed}');
    printOnFailure('Stop-Errors:\n${stopResult.stderr}');
    expect(stopResult.exitCode, 0);

    _logsProcess?.kill();
    await _logsProcess?.exitCode;

    _containerId = null;
    _logsProcess = null;
  }
}

class _ServerControllerLocal extends ServerController {
  Process? _process;

  _ServerControllerLocal() : super._();

  @override
  Future<Uri> start({
    Duration waitForReadyTimeout = const Duration(minutes: 1),
    bool autoTearDown = true,
  }) async {
    assert(_process == null);

    final port = await _getRandomPort();
    _process = await Process.start(
      'bash',
      [
        'tool/integration/start_server.sh',
        '--host',
        '127.0.0.1',
        '--port',
        '$port'
      ],
    );
    _pipeLogs(_process!.stdout, 'out');
    _pipeLogs(_process!.stderr, 'err');

    if (autoTearDown) {
      addTearDown(stop);
    }

    final serverUri = Uri.http('localhost:$port', '/');
    await _waitForReady(serverUri, waitForReadyTimeout);
    return serverUri;
  }

  @override
  Future<void> stop() async {
    assert(_process != null);

    final didKill = _process!.kill();
    print('KILLED: $didKill');

    final exitCode = await _process!.exitCode;
    print('EXIT CODE: $exitCode');

    _process = null;

    expect(exitCode, 0);
  }
}
