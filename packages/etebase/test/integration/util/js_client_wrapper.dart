// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test/test.dart';

import 'library_loader.dart';

part 'js_client_wrapper.freezed.dart';
part 'js_client_wrapper.g.dart';

@Freezed(unionKey: 'action')
sealed class Action with _$Action {
  // account test
  const factory Action.signUp(String username, String email, String password) =
      _SignUp;
  const factory Action.signIn(String username, String password) = _SignIn;
  const factory Action.saveAccount(
    String username,
    String password,
    String encryptionKey,
  ) = _SaveAccount;
  const factory Action.restoreAccount(String data, String encryptionKey) =
      _RestoreAccount;

  factory Action.fromJson(Map<String, dynamic> json) => _$ActionFromJson(json);

  const Action._();

  @internal
  String get $type;
}

abstract base class JsClientWrapper {
  static Future<TRes> execute<TRes>(
    Action action, {
    bool useDefaultServer = false,
    TRes Function(Map<String, dynamic> json)? fromJson,
  }) async {
    final proc = await Process.start('npm', [
      '-s',
      'start',
      'src/actions/${action.$type}.ts',
      if (!useDefaultServer) serverUri.toString(),
    ], workingDirectory: 'tool/js_client');

    final stdoutBuffer = StringBuffer();
    proc.stdout.transform(utf8.decoder).listen(stdoutBuffer.write);
    proc.stderr
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(print);

    proc.stdin.write(json.encode(action));
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
