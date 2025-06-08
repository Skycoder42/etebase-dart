// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:etebase/src/api/managers/account.dart';
import 'package:etebase/src/api/managers/client.dart';
import 'package:etebase/src/api/models/item_metadata.dart';
import 'package:etebase/src/api/models/user.dart';
import 'package:sodium/sodium_sumo.dart';

void main(List<String> args) async {
  final sodium = await SodiumSumoInit.init(
    () => DynamicLibrary.open('/usr/lib/aarch64-linux-gnu/libsodium.so.23'),
    // () => DynamicLibrary.open('/usr/lib/libsodium.so'),
  );
  final userName = base64Url.encode(sodium.randombytes.buf(18));
  print(userName);

  final client = Client.create(
    sodium,
    'test_client',
    Uri.http('127.0.0.1:3735'),
  );
  {
    final account = await Account.signup(
      client,
      User(username: userName, email: '$userName@mail.de'),
      userName,
    );
    print('signup successful');
    account.dispose();
  }

  {
    final account = await Account.login(client, userName, userName);
    print('login successful');
    await account.changePassword(userName * 2);
    print('changePassword successful');
    await account.fetchToken();
    print('fetchToken successful');
    await account.logout();
    print('logout successful');
    account.dispose();
  }

  final encryptionKey = sodium.secureRandom(32);
  String storedData;
  {
    final account = await Account.login(client, userName, userName * 2);
    print('second login successful');
    storedData = await account.save(encryptionKey);
    print('save successful: $storedData');
    account.dispose();
  }

  final account = await Account.restore(client, storedData, encryptionKey);
  print('restore successful');
  await account.fetchToken();
  print('fetchToken successful');

  final col1 = await account.collectionManager.create(
    'test1',
    const ItemMetadata(),
    Uint8List(0),
  );
  await col1.setMeta(const ItemMetadata(name: 'Test-1'));
  await col1.setContent(utf8.encode('Hello, World!'));
  await account.collectionManager.upload(col1);

  final list = await account.collectionManager.list('test1');
  print(
    await Stream.fromIterable(list.data).asyncExpand((item) async* {
      yield await item.getMeta();
      yield utf8.decode(await item.getContent());
    }).toList(),
  );

  account.dispose();
  encryptionKey.dispose();

  await client.dispose();
}
