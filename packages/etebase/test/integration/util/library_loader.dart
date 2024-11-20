import 'dart:ffi';
import 'dart:io';

// ignore: no_self_package_imports
import 'package:etebase/etebase.dart';
import 'package:path/path.dart' as path;
import 'package:sodium/sodium_sumo.dart';
import 'package:uuid/data.dart';
import 'package:uuid/rng.dart';
import 'package:uuid/uuid.dart';

// ignore: do_not_use_environment
const bool _kIsWeb = bool.fromEnvironment('dart.library.js_interop');

final _uuid = Uuid(
  goptions: GlobalOptions(CryptoRNG()),
);

final serverUri = Uri.http('localhost:3735', '/');

String generateUsername(String prefix) => '$prefix-${_uuid.v4()}';

Future<EtebaseClient> createClient() async => EtebaseClient.create(
      await SodiumSumoInit.init(_getLibsodium),
      'package:etebase/test/integration',
      serverUri,
    );

Future<EtebaseAccount> createAccount(
  EtebaseClient client,
  String userNamePrefix,
) async {
  final userName = generateUsername(userNamePrefix);
  final user = EtebaseUser(username: userName, email: '$userName@test.com');
  final account = await EtebaseAccount.signup(client, user, _uuid.v4());
  return account;
}

DynamicLibrary _getLibsodium() {
  if (_kIsWeb) {
    throw UnimplementedError();
  } else if (Platform.isLinux) {
    final pkgConfPath =
        Process.runSync('pkgconf', const ['--path', 'libsodium']).stdout
            as String;
    final libPath = path.canonicalize(
      path.join(
        path.dirname(pkgConfPath),
        '../libsodium.so',
      ),
    );
    return DynamicLibrary.open(libPath);
  } else {
    throw UnsupportedError(
      'Platform ${Platform.operatingSystem} is not supported',
    );
  }
}
