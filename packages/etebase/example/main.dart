// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:etebase/etebase.dart';
import 'package:sodium/sodium_sumo.dart';

void main(List<String> args) async {
  final sodium = await SodiumSumoInit.init(
    // replace with wherever libsodium is located on your machine
    () => DynamicLibrary.open('/usr/lib/libsodium.so'),
  );

  final client = Client.create(
    sodium,
    'test_client',
    Uri.http('127.0.0.1:3735'),
  );

  final userName = base64Url.encode(client.randombytes(18));
  print(userName);
  const password = 'very-random-password!123';

  {
    final account = await Account.signup(
      client,
      User(username: userName, email: '$userName@example.com'),
      password,
    );
    print('signup successful');
    account.dispose();
  }

  {
    final account = await Account.login(client, userName, password);
    print('login successful');
    await account.changePassword(password * 2);
    print('changePassword successful');
    await account.fetchToken();
    print('fetchToken successful');
    await account.logout();
    print('logout successful');
    account.dispose();
  }

  final encryptionKey = client.randomKey(Account.cacheKeyLength);
  String storedData;
  {
    final account = await Account.login(client, userName, password * 2);
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

  CollectionListResponse<Collection>? listResponse;
  do {
    listResponse = await account.collectionManager.list(
      'test1',
      FetchOptions(stoken: listResponse?.stoken),
    );
    for (final collection in listResponse.data) {
      final meta = await collection.getMeta();
      print('Found collection "${meta.name}" (uid: ${collection.uid})');
      print('>> meta:    $meta');
      print('>> content: ${utf8.decode(await collection.getContent())}');
      collection.dispose();
    }
  } while (!listResponse.isDone);

  account.dispose();
  encryptionKey.dispose();

  await client.dispose();
}
