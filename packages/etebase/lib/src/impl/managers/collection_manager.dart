import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../api/managers/etebase_collection_manager.dart';
import '../../api/managers/etebase_collection_member_manager.dart';
import '../../api/managers/etebase_item_manager.dart';
import '../../api/models/etebase_collection.dart';
import '../../api/models/etebase_collection_list_response.dart';
import '../../api/models/etebase_fetch_options.dart';
import '../../api/models/etebase_item_metadata.dart';
import '../crypto/account_crypto_manager.dart';
import 'client.dart';

@internal
class CollectionManager implements EtebaseCollectionManager {
  final Client _client;
  final AccountCryptoManager _cryptoManager;

  CollectionManager(this._client, this._cryptoManager);

  @override
  EtebaseCollection create(
    String collectionType,
    EtebaseItemMetadata meta,
    Uint8List content,
  ) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  EtebaseCollection cacheLoad(Uint8List cached) {
    // TODO: implement cacheLoad
    throw UnimplementedError();
  }

  @override
  Uint8List cacheSave(EtebaseCollection collection) {
    // TODO: implement cacheSave
    throw UnimplementedError();
  }

  @override
  Uint8List cacheSaveWithContent(EtebaseCollection collection) {
    // TODO: implement cacheSaveWithContent
    throw UnimplementedError();
  }

  @override
  EtebaseCollection createRaw(
    String collectionType,
    Uint8List meta,
    Uint8List content,
  ) {
    // TODO: implement createRaw
    throw UnimplementedError();
  }

  @override
  Future<EtebaseCollection> fetch(
    String colUid, [
    EtebaseFetchOptions? fetchOptions,
  ]) {
    // TODO: implement fetch
    throw UnimplementedError();
  }

  @override
  EtebaseItemManager getItemManager(EtebaseCollection col) {
    // TODO: implement getItemManager
    throw UnimplementedError();
  }

  @override
  EtebaseCollectionMemberManager getMemberManager(EtebaseCollection col) {
    // TODO: implement getMemberManager
    throw UnimplementedError();
  }

  @override
  Future<EtebaseCollectionListResponse> list(
    String collectionType, [
    EtebaseFetchOptions? fetchOptions,
  ]) {
    // TODO: implement list
    throw UnimplementedError();
  }

  @override
  Future<EtebaseCollectionListResponse> listMulti(
    List<String> collectionTypes, [
    EtebaseFetchOptions? fetchOptions,
  ]) {
    // TODO: implement listMulti
    throw UnimplementedError();
  }

  @override
  Future<void> transaction(
    EtebaseCollection collection, [
    EtebaseFetchOptions? fetchOptions,
  ]) {
    // TODO: implement transaction
    throw UnimplementedError();
  }

  @override
  Future<void> upload(
    EtebaseCollection collection, [
    EtebaseFetchOptions? fetchOptions,
  ]) {
    // TODO: implement upload
    throw UnimplementedError();
  }
}
