// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

import 'js_client_wrapper_stub.dart';
import 'library_loader.dart';

abstract base class JsClientWrapper {
  static Future<TRes> execute<TRes>(
    Action action, {
    bool useDefaultServer = false,
    TRes Function(Map<String, dynamic> json)? fromJson,
  }) async {
    final proc = await Process.start('npm', [
      '-s',
      'start',
      if (!useDefaultServer) serverUri.toString(),
    ], workingDirectory: 'tool/js_client');

    final stdoutBuffer = StringBuffer();
    proc.stdout.transform(utf8.decoder).listen(stdoutBuffer.write);
    proc.stderr
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(print);

    final actionMap = action.toJson();
    if (!useDefaultServer) {
      actionMap['serverUrl'] = serverUri.toString();
    }
    proc.stdin.write(json.encode(actionMap));
    await proc.stdin.close();

    await expectLater(proc.exitCode, completion(0));

    if (fromJson != null) {
      return fromJson(
        json.decode(stdoutBuffer.toString()) as Map<String, dynamic>,
      );
    } else if (TRes == String) {
      return json.decode(stdoutBuffer.toString()) as TRes;
    } else {
      return null as TRes;
    }
  }
}
