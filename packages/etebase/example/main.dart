// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:etebase/src/api/managers/etebase_account.dart';
import 'package:etebase/src/api/managers/etebase_client.dart';
import 'package:etebase/src/api/models/etebase_user.dart';
import 'package:sodium/sodium_sumo.dart';

void main(List<String> args) async {
  final sodium = await SodiumSumoInit.init(
    () => DynamicLibrary.open('/usr/lib/aarch64-linux-gnu/libsodium.so.23'),
    // () => DynamicLibrary.open('/usr/lib/libsodium.so'),
  );
  final userName = base64Url.encode(sodium.randombytes.buf(18));
  print(userName);

  final client = EtebaseClient.create(
    sodium,
    'test_client',
    Uri.http('127.0.0.1:3735'),
  );
  {
    final account = await EtebaseAccount.signup(
      client,
      EtebaseUser(
        username: userName,
        email: '$userName@mail.de',
      ),
      userName,
    );
    print('signup successful');
    await account.dispose();
  }

  {
    final account = await EtebaseAccount.login(client, userName, userName);
    print('login successful');
    await account.changePassword(userName * 2);
    print('changePassword successful');
    await account.fetchToken();
    print('fetchToken successful');
    await account.logout();
    print('logout successful');
    await account.dispose();
  }

  final encryptionKey = sodium.secureRandom(32);
  Uint8List storedData;
  {
    final account = await EtebaseAccount.login(client, userName, userName * 2);
    print('second login successful');
    storedData = await account.save(encryptionKey);
    print('save successful: $storedData');
    await account.dispose();
  }

  final account = await EtebaseAccount.restore(
    client,
    storedData,
    encryptionKey,
  );
  print('restore successful');
  await account.fetchToken();
  print('fetchToken successful');
  await account.dispose();
  encryptionKey.dispose();

  await client.dispose();
}
