import 'dart:ffi';
import 'dart:io';

// ignore: test_library_import
import 'package:etebase/etebase.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

const _libEtebaseBasePath = 'tool/integration/libetebase/lib/';

const _uuid = Uuid(
  options: <String, dynamic>{
    'grng': UuidUtil.cryptoRNG,
  },
);

final serverUri = Uri.http('localhost:3735', '/');

String generateUsername(String prefix) => '$prefix-${_uuid.v4()}';

Future<EtebaseAccount> createAccount(
  EtebaseClient client,
  String userNamePrefix,
) async {
  final userName = generateUsername(userNamePrefix);
  final user = EtebaseUser(username: userName, email: '$userName@test.com');
  final account = await EtebaseAccount.signup(client, user, _uuid.v4());
  return account;
}

DynamicLibrary loadLibEtebase() {
  final libraryPathOverride = Platform.environment['LIBETEBASE_PATH'];
  if (libraryPathOverride != null) {
    return DynamicLibrary.open(libraryPathOverride);
  } else if (Platform.isWindows) {
    return _open('etebase.dll');
  } else if (Platform.isMacOS) {
    return _open('libetebase.dylib');
  } else {
    return _open('libetebase.so');
  }
}

DynamicLibrary _open(String fileName) {
  final file = File('$_libEtebaseBasePath/$fileName');
  assert(file.existsSync(), 'Dynamic library "${file.path}" does not exist');
  return DynamicLibrary.open(file.absolute.path);
}
