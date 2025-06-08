import 'dart:typed_data';

import 'package:hive_ce/hive.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:sodium/sodium.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../api/exceptions/api_missuse.dart';
import '../../api/managers/crypto_executor.dart';
import '../../api/managers/etebase_client.dart';
import '../../api/models/item_metadata.dart';
import '../cache/hive_cache.dart';
import '../codec/message_pack_converter.dart';
import '../crypto/account_crypto_manager.dart';
import '../crypto/collection_crypto_manager.dart';
import '../crypto/collection_item_crypto_manager.dart';
import '../crypto/crypto_service.dart';
import '../crypto/minimal_collection_crypto_manager.dart';
import '../encrypted_models/encrypted_collection.dart';
import '../encrypted_models/encrypted_collection_item.dart';
import '../encrypted_models/encrypted_revision.dart';
import '../online_managers/authenticator.dart';
import '../online_managers/base_network.dart';

import '../online_managers/platform/user_agent_stub.dart'
    if (dart.library.io) '../online_managers/platform/user_agent_vm.dart'
    if (dart.library.js_interop) '../online_managers/platform/user_agent_web.dart';
import 'account.dart';

@internal
class Client implements EtebaseClient, NetworkClient {
  static final defaultUrl = Uri.https('api.etebase.com');

  final bool _ownedClient;

  @override
  final http.Client httpClient;
  @override
  final String userAgent;
  @override
  final MessagePackConverter converter;
  @override
  final Uri baseUrl;
  final CryptoService crypto;

  Client(
    this.httpClient,
    this.userAgent,
    this.baseUrl,
    this.converter,
    this.crypto, {
    bool ownedClient = false,
  }) : _ownedClient = ownedClient {
    if (baseUrl.path.endsWith('/')) {
      throw ApiMissuse('The serverUrl must not end with /');
    }
  }

  Client.create(
    CryptoExecutor cryptoExecutor,
    String clientName, [
    Uri? serverUrl,
  ]) : httpClient = http.Client(),
       userAgent = UserAgent.build(clientName),
       converter = MessagePackConverter(),
       baseUrl = serverUrl ?? defaultUrl,
       crypto = CryptoService(cryptoExecutor),
       _ownedClient = true;

  Authenticator get authenticator => Authenticator(this);

  @override
  Future<void> dispose() async {
    if (_ownedClient) {
      httpClient.close();
    }
    await crypto.dispose();
  }

  @override
  Future<bool> checkEtebaseServer() => authenticator.isEtebase();

  @override
  Uint8List randombytes(int size) => crypto.randomBytes(size);

  @override
  SecureKey randomKey(int size) => crypto.secureRandom(size);

  @override
  String prettyFingerprint(Uint8List content) =>
      crypto.prettyFingerprint(content);

  @override
  void registerCustomMetadata<TMeta extends ItemMetadata>(
    MetaFromJson<TMeta> fromJson,
  ) => converter.addCustom<TMeta>(fromJson);

  // factory methods for internal types to simplify testing

  // coverage:ignore-start

  @override
  WebSocketChannel connectWebSocket(Uri uri) => WebSocketChannel.connect(uri);

  Future<EncryptedRevision> createEncryptedRevision({
    required CollectionItemCryptoManager cryptoManager,
    required Uint8List additionalData,
    required ItemMetadata meta,
    required Uint8List content,
  }) => EncryptedRevision.create(
    client: this,
    cryptoManager: cryptoManager,
    additionalData: additionalData,
    meta: meta,
    content: content,
  );

  Future<(EncryptedCollectionItem, CollectionItemCryptoManager)>
  createEncryptedCollectionItem(
    MinimalCollectionCryptoManager parentCm,
    ItemMetadata meta,
    Uint8List content,
  ) => EncryptedCollectionItem.create(this, parentCm, meta, content);

  Future<(EncryptedCollection, CollectionCryptoManager)>
  createEncryptedCollection(
    AccountCryptoManager parentCm,
    String collectionTypeName,
    ItemMetadata meta,
    Uint8List content,
  ) => EncryptedCollection.create(
    this,
    parentCm,
    collectionTypeName,
    meta,
    content,
  );

  Future<HiveCache> createCache(String username) async {
    final cache = HiveCache(this, Hive, username);
    await cache.initialize();
    return cache;
  }

  Future<Account> restoreAccount(
    String accountDataStored, [
    SecureKey? encryptionKey,
  ]) => Account.restore(this, accountDataStored, encryptionKey);

  EncryptedCollection cacheLoadEncryptedCollection(Uint8List cachedData) =>
      EncryptedCollection.cacheLoad(this, cachedData);

  EncryptedCollectionItem cacheLoadEncryptedCollectionItem(
    Uint8List cachedData,
  ) => EncryptedCollectionItem.cacheLoad(this, cachedData);

  // coverage:ignore-end
}
