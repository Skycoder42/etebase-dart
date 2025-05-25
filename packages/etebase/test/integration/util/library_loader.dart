import 'dart:convert';
import 'dart:math';

// ignore: no_self_package_imports
import 'package:etebase/etebase.dart';
import 'package:sodium/sodium_sumo.dart';
import 'package:test/test.dart';
import 'package:uuid/data.dart';
import 'package:uuid/rng.dart';
import 'package:uuid/uuid.dart';

import 'js_client_wrapper.dart';
import 'library_loader_stub.dart'
    if (dart.library.io) 'library_loader_vm.dart'
    if (dart.library.js_interop) 'library_loader_js.dart';

export 'library_loader_stub.dart'
    if (dart.library.io) 'library_loader_vm.dart'
    if (dart.library.js_interop) 'library_loader_js.dart'
    show getLibsodium, kIsWeb;

final _rng = Random.secure();
final _uuid = Uuid(goptions: GlobalOptions(CryptoRNG()));

final serverUri = Uri.http('localhost:3735');

String generateUsername(String prefix) => '$prefix-${_uuid.v4()}';

Future<EtebaseClient> createClient({bool useDefaultServer = false}) async {
  final useAsync = !kIsWeb && _rng.nextBool();
  printOnFailure('Running client in ${useAsync ? 'async' : 'sync'} mode');

  return useAsync
      ? await EtebaseClient.createAsync(
          await SodiumSumoInit.init(getLibsodium),
          'package:etebase/test/integration',
          useDefaultServer ? null : serverUri,
        )
      : EtebaseClient.create(
          await SodiumSumoInit.init(getLibsodium),
          'package:etebase/test/integration',
          useDefaultServer ? null : serverUri,
        );
}

Future<EtebaseAccount> createAccount(
  EtebaseClient client,
  String userNamePrefix, [
  JsClientWrapper? wrapper,
]) async {
  final userName = generateUsername(userNamePrefix);
  final user = EtebaseUser(username: userName, email: '$userName@test.com');
  final password = base64.encode(EtebaseUtils.randombytes(client, 32));
  final account = await EtebaseAccount.signup(client, user, password);
  wrapper?.configureAccount(userName, password);
  return account;
}
