// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

import 'js_client_wrapper_stub.dart' as stub;
import 'library_loader.dart';

class JsClientWrapper extends stub.JsClientWrapper {
  JsClientWrapper() : super.base();

  @override
  Future<TRes> executeSignedIn<TRes>(
    stub.Action action, {
    bool useDefaultServer = false,
    TRes Function(Map<String, dynamic> json)? fromJson,
  }) => execute<TRes>(
    action,
    useDefaultServer: useDefaultServer,
    actionExtra: {'username': username, 'password': password},
    fromJson: fromJson,
  );

  static Future<TRes> execute<TRes>(
    stub.Action action, {
    bool useDefaultServer = false,
    Map<String, dynamic>? actionExtra,
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
    if (actionExtra != null) {
      actionMap.addAll(actionExtra);
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
    } else if (TRes == List<String>) {
      return (json.decode(stdoutBuffer.toString()) as List<dynamic>)
              .cast<String>()
          as TRes;
    } else {
      return null as TRes;
    }
  }
}
