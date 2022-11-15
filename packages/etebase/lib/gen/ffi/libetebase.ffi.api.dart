// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// EtebaseGenerator
// **************************************************************************

// ignore_for_file: require_trailing_commas, avoid_positional_boolean_parameters
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:typed_data' as _i1;

class EtebaseUserProfile {
  Future<_i1.Uint8List> getPubkey() async => throw UnimplementedError();
}

class EtebaseUser {
  static Future<EtebaseUser> create(
    String username,
    String email,
  ) async =>
      throw UnimplementedError();
  Future<void> setUsername(String username) async => throw UnimplementedError();
  Future<String> getUsername() async => throw UnimplementedError();
  Future<void> setEmail(String email) async => throw UnimplementedError();
  Future<String> getEmail() async => throw UnimplementedError();
}

class EtebaseSignedInvitation {
  Future<EtebaseSignedInvitation> clone() async => throw UnimplementedError();
  Future<String> getUid() async => throw UnimplementedError();
  Future<String> getUsername() async => throw UnimplementedError();
  Future<String> getCollection() async => throw UnimplementedError();
  Future<int> getAccessLevel() async => throw UnimplementedError();
  Future<String> getFromUsername() async => throw UnimplementedError();
  Future<_i1.Uint8List> getFromPubkey() async => throw UnimplementedError();
}

class EtebaseRemovedCollection {
  Future<String> getUid() async => throw UnimplementedError();
}

class EtebaseInvitationListResponse {
  Future<String> getIterator() async => throw UnimplementedError();
  Future<int> getData(dynamic data) async => throw UnimplementedError();
  Future<int> getDataLength() async => throw UnimplementedError();
  Future<bool> isDone() async => throw UnimplementedError();
}

class EtebaseItemRevisionsListResponse {
  Future<String> getIterator() async => throw UnimplementedError();
  Future<int> getData(dynamic data) async => throw UnimplementedError();
  Future<int> getDataLength() async => throw UnimplementedError();
  Future<bool> isDone() async => throw UnimplementedError();
}

class EtebaseMemberListResponse {
  Future<String> getIterator() async => throw UnimplementedError();
  Future<int> getData(dynamic data) async => throw UnimplementedError();
  Future<int> getDataLength() async => throw UnimplementedError();
  Future<bool> isDone() async => throw UnimplementedError();
}

class EtebaseItemMetadata {
  static Future<EtebaseItemMetadata> create() async =>
      throw UnimplementedError();
  Future<void> setItemType(String itemType) async => throw UnimplementedError();
  Future<String> getItemType() async => throw UnimplementedError();
  Future<void> setName(String name) async => throw UnimplementedError();
  Future<String> getName() async => throw UnimplementedError();
  Future<void> setMtime(int mtime) async => throw UnimplementedError();
  Future<int> getMtime() async => throw UnimplementedError();
  Future<void> setDescription(String description) async =>
      throw UnimplementedError();
  Future<String> getDescription() async => throw UnimplementedError();
  Future<void> setColor(String color) async => throw UnimplementedError();
  Future<String> getColor() async => throw UnimplementedError();
}

class EtebaseItemManager {
  Future<EtebaseItem> fetch(
    String itemUid,
    EtebaseFetchOptions fetchOptions,
  ) async =>
      throw UnimplementedError();
  Future<EtebaseItem> create(
    EtebaseItemMetadata meta,
    _i1.Uint8List content,
  ) async =>
      throw UnimplementedError();
  Future<EtebaseItem> createRaw(
    _i1.Uint8List meta,
    _i1.Uint8List content,
  ) async =>
      throw UnimplementedError();
  Future<EtebaseItemListResponse> list(
          EtebaseFetchOptions fetchOptions) async =>
      throw UnimplementedError();
  Future<EtebaseItemRevisionsListResponse> itemRevisions(
    EtebaseItem item,
    EtebaseFetchOptions fetchOptions,
  ) async =>
      throw UnimplementedError();
  Future<EtebaseItemListResponse> fetchUpdates(
    List<EtebaseItem> items,
    EtebaseFetchOptions fetchOptions,
  ) async =>
      throw UnimplementedError();
  Future<EtebaseItemListResponse> fetchMulti(
    List<String> items,
    EtebaseFetchOptions fetchOptions,
  ) async =>
      throw UnimplementedError();
  Future<int> batch(
    List<EtebaseItem> items,
    EtebaseFetchOptions fetchOptions,
  ) async =>
      throw UnimplementedError();
  Future<int> batchDeps(
    List<EtebaseItem> items,
    List<EtebaseItem> deps,
    EtebaseFetchOptions fetchOptions,
  ) async =>
      throw UnimplementedError();
  Future<int> transaction(
    List<EtebaseItem> items,
    EtebaseFetchOptions fetchOptions,
  ) async =>
      throw UnimplementedError();
  Future<int> transactionDeps(
    List<EtebaseItem> items,
    List<EtebaseItem> deps,
    EtebaseFetchOptions fetchOptions,
  ) async =>
      throw UnimplementedError();
  Future<EtebaseItem> cacheLoad(_i1.Uint8List cached) async =>
      throw UnimplementedError();
  Future<_i1.Uint8List> cacheSave(EtebaseItem item) async =>
      throw UnimplementedError();
  Future<_i1.Uint8List> cacheSaveWithContent(EtebaseItem item) async =>
      throw UnimplementedError();
}

class EtebaseItemListResponse {
  Future<String> getStoken() async => throw UnimplementedError();
  Future<int> getData(dynamic data) async => throw UnimplementedError();
  Future<int> getDataLength() async => throw UnimplementedError();
  Future<bool> isDone() async => throw UnimplementedError();
}

class EtebaseItem {
  Future<EtebaseItem> clone() async => throw UnimplementedError();
  Future<bool> verify() async => throw UnimplementedError();
  Future<int> setMeta(EtebaseItemMetadata meta) async =>
      throw UnimplementedError();
  Future<EtebaseItemMetadata> getMeta() async => throw UnimplementedError();
  Future<int> setMetaRaw(_i1.Uint8List meta) async =>
      throw UnimplementedError();
  Future<int> getMetaRaw(_i1.Uint8List buf) async => throw UnimplementedError();
  Future<int> setContent(_i1.Uint8List content) async =>
      throw UnimplementedError();
  Future<int> getContent(_i1.Uint8List buf) async => throw UnimplementedError();
  Future<int> delete() async => throw UnimplementedError();
  Future<bool> isDeleted() async => throw UnimplementedError();
  Future<String> getUid() async => throw UnimplementedError();
  Future<String> getEtag() async => throw UnimplementedError();
}

class EtebaseFileSystemCache {
  static Future<EtebaseFileSystemCache> create(
    String path,
    String username,
  ) async =>
      throw UnimplementedError();
  Future<int> clearUser() async => throw UnimplementedError();
  Future<int> saveAccount(
    EtebaseAccount etebase,
    _i1.Uint8List encryptionKey,
  ) async =>
      throw UnimplementedError();
  Future<EtebaseAccount> loadAccount(
    EtebaseClient client,
    _i1.Uint8List encryptionKey,
  ) async =>
      throw UnimplementedError();
  Future<int> saveStoken(String stoken) async => throw UnimplementedError();
  Future<String> loadStoken() async => throw UnimplementedError();
  Future<int> collectionSaveStoken(
    String colUid,
    String stoken,
  ) async =>
      throw UnimplementedError();
  Future<String> collectionLoadStoken(String colUid) async =>
      throw UnimplementedError();
  Future<int> collectionSet(
    EtebaseCollectionManager colMgr,
    EtebaseCollection col,
  ) async =>
      throw UnimplementedError();
  Future<int> collectionUnset(
    EtebaseCollectionManager colMgr,
    String colUid,
  ) async =>
      throw UnimplementedError();
  Future<EtebaseCollection> collectionGet(
    EtebaseCollectionManager colMgr,
    String colUid,
  ) async =>
      throw UnimplementedError();
  Future<int> itemSet(
    EtebaseItemManager itemMgr,
    String colUid,
    EtebaseItem item,
  ) async =>
      throw UnimplementedError();
  Future<int> itemUnset(
    EtebaseItemManager itemMgr,
    String colUid,
    String itemUid,
  ) async =>
      throw UnimplementedError();
  Future<EtebaseItem> itemGet(
    EtebaseItemManager itemMgr,
    String colUid,
    String itemUid,
  ) async =>
      throw UnimplementedError();
}

class EtebaseFetchOptions {
  static Future<EtebaseFetchOptions> create() async =>
      throw UnimplementedError();
  Future<void> setLimit(int limit) async => throw UnimplementedError();
  Future<void> setPrefetch(int prefetch) async => throw UnimplementedError();
  Future<void> setWithCollection(bool withCollection) async =>
      throw UnimplementedError();
  Future<void> setIterator(String iterator) async => throw UnimplementedError();
  Future<void> setStoken(String stoken) async => throw UnimplementedError();
}

class EtebaseCollectionMemberManager {
  Future<EtebaseMemberListResponse> list(
          EtebaseFetchOptions fetchOptions) async =>
      throw UnimplementedError();
  Future<int> remove(String username) async => throw UnimplementedError();
  Future<int> leave() async => throw UnimplementedError();
  Future<int> modifyAccessLevel(
    String username,
    int accessLevel,
  ) async =>
      throw UnimplementedError();
}

class EtebaseCollectionMember {
  Future<EtebaseCollectionMember> clone() async => throw UnimplementedError();
  Future<String> getUsername() async => throw UnimplementedError();
  Future<int> getAccessLevel() async => throw UnimplementedError();
}

class EtebaseCollectionManager {
  Future<EtebaseCollection> fetch(
    String colUid,
    EtebaseFetchOptions fetchOptions,
  ) async =>
      throw UnimplementedError();
  Future<EtebaseCollection> create(
    String collectionType,
    EtebaseItemMetadata meta,
    _i1.Uint8List content,
  ) async =>
      throw UnimplementedError();
  Future<EtebaseCollection> createRaw(
    String collectionType,
    _i1.Uint8List meta,
    _i1.Uint8List content,
  ) async =>
      throw UnimplementedError();
  Future<EtebaseItemManager> getItemManager(EtebaseCollection col) async =>
      throw UnimplementedError();
  Future<EtebaseCollectionListResponse> list(
    String collectionType,
    EtebaseFetchOptions fetchOptions,
  ) async =>
      throw UnimplementedError();
  Future<EtebaseCollectionListResponse> listMulti(
    List<String> collectionTypes,
    EtebaseFetchOptions fetchOptions,
  ) async =>
      throw UnimplementedError();
  Future<int> upload(
    EtebaseCollection collection,
    EtebaseFetchOptions fetchOptions,
  ) async =>
      throw UnimplementedError();
  Future<int> transaction(
    EtebaseCollection collection,
    EtebaseFetchOptions fetchOptions,
  ) async =>
      throw UnimplementedError();
  Future<EtebaseCollection> cacheLoad(_i1.Uint8List cached) async =>
      throw UnimplementedError();
  Future<_i1.Uint8List> cacheSave(EtebaseCollection collection) async =>
      throw UnimplementedError();
  Future<_i1.Uint8List> cacheSaveWithContent(
          EtebaseCollection collection) async =>
      throw UnimplementedError();
  Future<EtebaseCollectionMemberManager> getMemberManager(
          EtebaseCollection col) async =>
      throw UnimplementedError();
}

class EtebaseCollectionListResponse {
  Future<String> getStoken() async => throw UnimplementedError();
  Future<int> getData(dynamic data) async => throw UnimplementedError();
  Future<int> getDataLength() async => throw UnimplementedError();
  Future<bool> isDone() async => throw UnimplementedError();
  Future<int> getRemovedMemberships(dynamic data) async =>
      throw UnimplementedError();
  Future<int> getRemovedMembershipsLength() async => throw UnimplementedError();
}

class EtebaseCollectionInvitationManager {
  Future<EtebaseInvitationListResponse> listIncoming(
          EtebaseFetchOptions fetchOptions) async =>
      throw UnimplementedError();
  Future<EtebaseInvitationListResponse> listOutgoing(
          EtebaseFetchOptions fetchOptions) async =>
      throw UnimplementedError();
  Future<int> accept(EtebaseSignedInvitation invitation) async =>
      throw UnimplementedError();
  Future<int> reject(EtebaseSignedInvitation invitation) async =>
      throw UnimplementedError();
  Future<EtebaseUserProfile> fetchUserProfile(String username) async =>
      throw UnimplementedError();
  Future<int> invite(
    EtebaseCollection collection,
    String username,
    _i1.Uint8List pubkey,
    int accessLevel,
  ) async =>
      throw UnimplementedError();
  Future<int> disinvite(EtebaseSignedInvitation invitation) async =>
      throw UnimplementedError();
  Future<_i1.Uint8List> getPubkey() async => throw UnimplementedError();
}

class EtebaseCollection {
  Future<EtebaseCollection> clone() async => throw UnimplementedError();
  Future<bool> verify() async => throw UnimplementedError();
  Future<int> setMeta(EtebaseItemMetadata meta) async =>
      throw UnimplementedError();
  Future<EtebaseItemMetadata> getMeta() async => throw UnimplementedError();
  Future<int> setMetaRaw(_i1.Uint8List meta) async =>
      throw UnimplementedError();
  Future<int> getMetaRaw(_i1.Uint8List buf) async => throw UnimplementedError();
  Future<int> setContent(_i1.Uint8List content) async =>
      throw UnimplementedError();
  Future<int> getContent(_i1.Uint8List buf) async => throw UnimplementedError();
  Future<int> delete() async => throw UnimplementedError();
  Future<bool> isDeleted() async => throw UnimplementedError();
  Future<String> getUid() async => throw UnimplementedError();
  Future<String> getEtag() async => throw UnimplementedError();
  Future<String> getStoken() async => throw UnimplementedError();
  Future<EtebaseItem> asItem() async => throw UnimplementedError();
  Future<String> getCollectionType() async => throw UnimplementedError();
  Future<int> getAccessLevel() async => throw UnimplementedError();
}

class EtebaseClient {
  static Future<EtebaseClient> create(
    String clientName,
    String serverUrl,
  ) async =>
      throw UnimplementedError();
  Future<int> setServerUrl(String serverUrl) async =>
      throw UnimplementedError();
  static Future<int> checkEtebaseServer(EtebaseClient client) async =>
      throw UnimplementedError();
}

class EtebaseAccount {
  static Future<EtebaseAccount> login(
    EtebaseClient client,
    String username,
    String password,
  ) async =>
      throw UnimplementedError();
  static Future<EtebaseAccount> signup(
    EtebaseClient client,
    EtebaseUser user,
    String password,
  ) async =>
      throw UnimplementedError();
  Future<int> fetchToken() async => throw UnimplementedError();
  Future<String> fetchDashboardUrl() async => throw UnimplementedError();
  Future<int> forceServerUrl(String serverUrl) async =>
      throw UnimplementedError();
  Future<int> changePassword(String password) async =>
      throw UnimplementedError();
  Future<int> logout() async => throw UnimplementedError();
  Future<EtebaseCollectionManager> getCollectionManager() async =>
      throw UnimplementedError();
  Future<EtebaseCollectionInvitationManager> getInvitationManager() async =>
      throw UnimplementedError();
  Future<String> save(_i1.Uint8List encryptionKey) async =>
      throw UnimplementedError();
  static Future<EtebaseAccount> restore(
    EtebaseClient client,
    String accountDataStored,
    _i1.Uint8List encryptionKey,
  ) async =>
      throw UnimplementedError();
}

abstract class EtebaseUtils {
  EtebaseUtils._();

  static Future<int> randombytes(
    Void buf,
    int size,
  ) async =>
      throw UnimplementedError();
  static Future<int> prettyFingerprint(
    _i1.Uint8List content,
    String buf,
  ) async =>
      throw UnimplementedError();
}
