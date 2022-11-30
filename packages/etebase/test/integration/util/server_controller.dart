// ignore_for_file: prefer_asserts_with_message

import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

class ServerController {
  String? _containerId;

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
    addTearDown(stop);

    final serverUri = Uri.http('localhost:3735', '/');

    if (waitForReadyTimeout != Duration.zero) {
      final timeout = DateTime.now().add(waitForReadyTimeout);
      while (DateTime.now().isBefore(timeout)) {
        try {
          final socket = await Socket.connect(serverUri.host, serverUri.port);
          await socket.close();
          print(
            'Server is ready after: '
            '${waitForReadyTimeout - timeout.difference(DateTime.now())}',
          );
          break;
        } on SocketException catch (e) {
          if (!e.message.contains('Connection refused')) {
            rethrow;
          }

          await Future<void>.delayed(const Duration(seconds: 1));
        }
      }
    }

    return serverUri;
  }

  Future<void> stop() async {
    assert(_containerId != null);

    final logsResult = await Process.run('docker', ['logs', _containerId!]);
    expect(logsResult.exitCode, 0);
    printOnFailure('STDOUT:\n${logsResult.stdout}');
    printOnFailure('STDERR:\n${logsResult.stderr}');

    final stopResult = await Process.run('docker', ['stop', _containerId!]);
    printOnFailure('Stop-Errors:\n${stopResult.stderr}');
    expect(stopResult.exitCode, 0);

    _containerId = null;
  }
}
