// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// EtebaseGenerator
// **************************************************************************

import 'dart:typed_data';

abstract class EtebaseUserProfile {
  Uint8List getPubkey();
}

abstract class EtebaseUser {
  void setUsername(String username);
  String getUsername();
  void setEmail(String email);
  String getEmail();
}

abstract class EtebaseSignedInvitation {
  EtebaseSignedInvitation clone();
  String getUid();
  String getUsername();
  String getCollection();
  int getAccessLevel();
  String getFromUsername();
  Uint8List getFromPubkey();
}

abstract class EtebaseRemovedCollection {
  String getUid();
}

abstract class EtebaseInvitationListResponse {
  String getIterator();
  int getData(dynamic data);
  int getDataLength();
  bool isDone();
}

abstract class EtebaseItemRevisionsListResponse {
  String getIterator();
  int getData(dynamic data);
  int getDataLength();
  bool isDone();
}

abstract class EtebaseMemberListResponse {
  String getIterator();
  int getData(dynamic data);
  int getDataLength();
  bool isDone();
}

abstract class EtebaseItemMetadata {
  void setItemType(String itemType);
  String getItemType();
  void setName(String name);
  String getName();
  void setMtime(int mtime);
  int getMtime();
  void setDescription(String description);
  String getDescription();
  void setColor(String color);
  String getColor();
}

abstract class EtebaseItemManager {
  EtebaseItem fetch(
    String itemUid,
    EtebaseFetchOptions fetchOptions,
  );
  EtebaseItem create(
    EtebaseItemMetadata meta,
    Uint8List content,
  );
  EtebaseItem createRaw(
    Uint8List meta,
    Uint8List content,
  );
  EtebaseItemListResponse list(EtebaseFetchOptions fetchOptions);
  EtebaseItemRevisionsListResponse itemRevisions(
    EtebaseItem item,
    EtebaseFetchOptions fetchOptions,
  );
  EtebaseItemListResponse fetchUpdates(
    List<EtebaseItem> items,
    EtebaseFetchOptions fetchOptions,
  );
  EtebaseItemListResponse fetchMulti(
    List<String> items,
    EtebaseFetchOptions fetchOptions,
  );
  int batch(
    List<EtebaseItem> items,
    EtebaseFetchOptions fetchOptions,
  );
  int batchDeps(
    List<EtebaseItem> items,
    List<EtebaseItem> deps,
    EtebaseFetchOptions fetchOptions,
  );
  int transaction(
    List<EtebaseItem> items,
    EtebaseFetchOptions fetchOptions,
  );
  int transactionDeps(
    List<EtebaseItem> items,
    List<EtebaseItem> deps,
    EtebaseFetchOptions fetchOptions,
  );
  EtebaseItem cacheLoad(Uint8List cached);
  Void cacheSave(EtebaseItem item);
  Void cacheSaveWithContent(EtebaseItem item);
}

abstract class EtebaseItemListResponse {
  String getStoken();
  int getData(dynamic data);
  int getDataLength();
  bool isDone();
}

abstract class EtebaseItem {
  EtebaseItem clone();
  bool verify();
  int setMeta(EtebaseItemMetadata meta);
  EtebaseItemMetadata getMeta();
  int setMetaRaw(Uint8List meta);
  int getMetaRaw(Uint8List buf);
  int setContent(Uint8List content);
  int getContent(Uint8List buf);
  int delete();
  bool isDeleted();
  String getUid();
  String getEtag();
}

abstract class EtebaseFileSystemCache {}

abstract class EtebaseFetchOptions {
  void setLimit(int limit);
  void setPrefetch(int prefetch);
  void setWithCollection(bool withCollection);
  void setIterator(String iterator);
  void setStoken(String stoken);
}

abstract class EtebaseCollectionMemberManager {
  EtebaseMemberListResponse list(EtebaseFetchOptions fetchOptions);
  int remove(String username);
  int leave();
  int modifyAccessLevel(
    String username,
    int accessLevel,
  );
}

abstract class EtebaseCollectionMember {
  EtebaseCollectionMember clone();
  String getUsername();
  int getAccessLevel();
}

abstract class EtebaseCollectionManager {
  EtebaseCollection fetch(
    String colUid,
    EtebaseFetchOptions fetchOptions,
  );
  EtebaseCollection create(
    String collectionType,
    EtebaseItemMetadata meta,
    Uint8List content,
  );
  EtebaseCollection createRaw(
    String collectionType,
    Uint8List meta,
    Uint8List content,
  );
  EtebaseItemManager getItemManager(EtebaseCollection col);
  EtebaseCollectionListResponse list(
    String collectionType,
    EtebaseFetchOptions fetchOptions,
  );
  EtebaseCollectionListResponse listMulti(
    List<String> collectionTypes,
    EtebaseFetchOptions fetchOptions,
  );
  int upload(
    EtebaseCollection collection,
    EtebaseFetchOptions fetchOptions,
  );
  int transaction(
    EtebaseCollection collection,
    EtebaseFetchOptions fetchOptions,
  );
  EtebaseCollection cacheLoad(Uint8List cached);
  Void cacheSave(EtebaseCollection collection);
  Void cacheSaveWithContent(EtebaseCollection collection);
  EtebaseCollectionMemberManager getMemberManager(EtebaseCollection col);
}

abstract class EtebaseCollectionListResponse {
  String getStoken();
  int getData(dynamic data);
  int getDataLength();
  bool isDone();
  int getRemovedMemberships(dynamic data);
  int getRemovedMembershipsLength();
}

abstract class EtebaseCollectionInvitationManager {}

abstract class EtebaseCollection {
  EtebaseCollection clone();
  bool verify();
  int setMeta(EtebaseItemMetadata meta);
  EtebaseItemMetadata getMeta();
  int setMetaRaw(Uint8List meta);
  int getMetaRaw(Uint8List buf);
  int setContent(Uint8List content);
  int getContent(Uint8List buf);
  int delete();
  bool isDeleted();
  String getUid();
  String getEtag();
  String getStoken();
  EtebaseItem asItem();
  String getCollectionType();
  int getAccessLevel();
}

abstract class EtebaseClient {
  int setServerUrl(String serverUrl);
  static int checkEtebaseServer(EtebaseClient client) async {}
}

abstract class EtebaseAccount {
  static EtebaseAccount login(
    EtebaseClient client,
    String username,
    String password,
  ) async {}
  static EtebaseAccount signup(
    EtebaseClient client,
    EtebaseUser user,
    String password,
  ) async {}
  int fetchToken();
  String fetchDashboardUrl();
  int forceServerUrl(String serverUrl);
  int changePassword(String password);
  int logout();
  EtebaseCollectionManager getCollectionManager();
  EtebaseCollectionInvitationManager getInvitationManager();
  String save(Uint8List encryptionKey);
  static EtebaseAccount restore(
    EtebaseClient client,
    String accountDataStored,
    Uint8List encryptionKey,
  ) async {}
}
