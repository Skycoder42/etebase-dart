// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// EtebaseGenerator
// **************************************************************************

// ignore_for_file: require_trailing_commas, avoid_positional_boolean_parameters, lines_longer_than_80_chars, comment_references
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:ffi' as _i2;
import 'dart:typed_data' as _i4;

import '../../src/isolate/etebase_isolate.dart' as _i1;
import '../../src/model/etebase_collection_access_level.dart' as _i5;
import '../../src/model/etebase_prefetch_option.dart' as _i6;
import 'libetebase.ffi.dart' as _i3;

/// The URL of the main hosted server
Future<String> etebaseGetDefaultServerUrl() async =>
    _i1.EtebaseIsolate.current.invoke(
      #etebase_get_default_server_url,
      const [],
    );

class EtebaseUserProfile {
  EtebaseUserProfile._(this._pointer) {
    _finalizer.attach(
      this,
      _pointer,
      detach: this,
    );
  }

  static final _finalizer = Finalizer(_destroy);

  final _i2.Pointer<_i3.EtebaseUserProfile> _pointer;

  /// The user's identity public key
  ///
  /// This is used for identifying the user and safely sending them data (such as \ref invitations EtebaseSignedInvitation).
  Future<_i4.Uint8List> getPubkey() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_user_profile_get_pubkey,
        [_pointer.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  static Future<void> _destroy(
          _i2.Pointer<_i3.EtebaseUserProfile> this_) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_user_profile_destroy,
        [this_.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    _finalizer.detach(this);
    await _destroy(_pointer);
  }
}

class EtebaseUser {
  EtebaseUser._(this._pointer) {
    _finalizer.attach(
      this,
      _pointer,
      detach: this,
    );
  }

  static final _finalizer = Finalizer(_destroy);

  final _i2.Pointer<_i3.EtebaseUser> _pointer;

  /// Return a new user instance
  ///
  /// Should be destroyed with `etebase_user_destroy`
  ///
  /// @param username the user's username
  /// @param email the user's email
  static Future<EtebaseUser> create(
    String username,
    String email,
  ) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_user_new,
        [
          username,
          email,
        ],
      );

  /// Set the username
  ///
  /// @param this_ the object handle
  /// @param username the user's username
  Future<void> setUsername(String username) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_user_set_username,
        [
          _pointer.address,
          username,
        ],
      );

  /// Get the username
  ///
  /// @param this_ the object handle
  Future<String> getUsername() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_user_get_username,
        [_pointer.address],
      );

  /// Set the email address
  ///
  /// @param this_ the object handle
  /// @param email the user's email address
  Future<void> setEmail(String email) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_user_set_email,
        [
          _pointer.address,
          email,
        ],
      );

  /// Get the email address
  ///
  /// @param this_ the object handle
  Future<String> getEmail() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_user_get_email,
        [_pointer.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  static Future<void> _destroy(_i2.Pointer<_i3.EtebaseUser> this_) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_user_destroy,
        [this_.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    _finalizer.detach(this);
    await _destroy(_pointer);
  }
}

class EtebaseSignedInvitation {
  EtebaseSignedInvitation._(this._pointer) {
    _finalizer.attach(
      this,
      _pointer,
      detach: this,
    );
  }

  static final _finalizer = Finalizer(_destroy);

  final _i2.Pointer<_i3.EtebaseSignedInvitation> _pointer;

  /// Clone the invitation object
  ///
  /// @param this_ the object handle
  Future<EtebaseSignedInvitation> clone() async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_signed_invitation_clone,
        [_pointer.address],
      );

  /// The uid of the invitation
  ///
  /// @param this_ the object handle
  Future<String> getUid() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_signed_invitation_get_uid,
        [_pointer.address],
      );

  /// The username this invitation is for
  ///
  /// @param this_ the object handle
  Future<String> getUsername() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_signed_invitation_get_username,
        [_pointer.address],
      );

  /// The uid of the collection this invitation is for
  ///
  /// @param this_ the object handle
  Future<String> getCollection() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_signed_invitation_get_collection,
        [_pointer.address],
      );

  /// The access level offered in this invitation
  ///
  /// @param this_ the object handle
  Future<_i5.EtebaseCollectionAccessLevel> getAccessLevel() async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_signed_invitation_get_access_level,
        [_pointer.address],
      );

  /// The username this invitation is from
  ///
  /// @param this_ the object handle
  Future<String> getFromUsername() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_signed_invitation_get_from_username,
        [_pointer.address],
      );

  /// The public key of the inviting user
  ///
  /// @param this_ the object handle
  Future<_i4.Uint8List> getFromPubkey() async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_signed_invitation_get_from_pubkey,
        [_pointer.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  static Future<void> _destroy(
          _i2.Pointer<_i3.EtebaseSignedInvitation> this_) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_signed_invitation_destroy,
        [this_.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    _finalizer.detach(this);
    await _destroy(_pointer);
  }
}

class EtebaseRemovedCollection {
  EtebaseRemovedCollection._(this._pointer) {
    _finalizer.attach(
      this,
      _pointer,
      detach: this,
    );
  }

  static final _finalizer = Finalizer(_destroy);

  final _i2.Pointer<_i3.EtebaseRemovedCollection> _pointer;

  /// The uid of the removed collection
  ///
  /// @param this_ the object handle
  Future<String> getUid() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_removed_collection_get_uid,
        [_pointer.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  static Future<void> _destroy(
          _i2.Pointer<_i3.EtebaseRemovedCollection> this_) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_removed_collection_destroy,
        [this_.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    _finalizer.detach(this);
    await _destroy(_pointer);
  }
}

class EtebaseInvitationListResponse {
  EtebaseInvitationListResponse._(this._pointer) {
    _finalizer.attach(
      this,
      _pointer,
      detach: this,
    );
  }

  static final _finalizer = Finalizer(_destroy);

  final _i2.Pointer<_i3.EtebaseInvitationListResponse> _pointer;

  /// Iterator for the list response
  ///
  /// @param this_ the object handle
  Future<String> getIterator() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_invitation_list_response_get_iterator,
        [_pointer.address],
      );

  /// List of invitations included in the response
  ///
  /// @param this_ the object handle
  /// @param[out] data the array to store the items in
  Future<List<EtebaseSignedInvitation>> getData() async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_invitation_list_response_get_data,
        [_pointer.address],
      );

  /// Indicates whether there is no more data to fetch
  ///
  /// @param this_ the object handle
  Future<bool> isDone() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_invitation_list_response_is_done,
        [_pointer.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  static Future<void> _destroy(
          _i2.Pointer<_i3.EtebaseInvitationListResponse> this_) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_invitation_list_response_destroy,
        [this_.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    _finalizer.detach(this);
    await _destroy(_pointer);
  }
}

class EtebaseItemRevisionsListResponse {
  EtebaseItemRevisionsListResponse._(this._pointer) {
    _finalizer.attach(
      this,
      _pointer,
      detach: this,
    );
  }

  static final _finalizer = Finalizer(_destroy);

  final _i2.Pointer<_i3.EtebaseItemRevisionsListResponse> _pointer;

  /// Iterator for the list response
  ///
  /// @param this_ the object handle
  Future<String> getIterator() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_item_revisions_list_response_get_iterator,
        [_pointer.address],
      );

  /// List of item revisions included in the response
  ///
  /// @param this_ the object handle
  /// @param[out] data the array to store the items in
  Future<List<EtebaseItem>> getData() async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_item_revisions_list_response_get_data,
        [_pointer.address],
      );

  /// Indicates whether there is no more data to fetch
  ///
  /// @param this_ the object handle
  Future<bool> isDone() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_item_revisions_list_response_is_done,
        [_pointer.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  static Future<void> _destroy(
          _i2.Pointer<_i3.EtebaseItemRevisionsListResponse> this_) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_item_revisions_list_response_destroy,
        [this_.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    _finalizer.detach(this);
    await _destroy(_pointer);
  }
}

class EtebaseMemberListResponse {
  EtebaseMemberListResponse._(this._pointer) {
    _finalizer.attach(
      this,
      _pointer,
      detach: this,
    );
  }

  static final _finalizer = Finalizer(_destroy);

  final _i2.Pointer<_i3.EtebaseMemberListResponse> _pointer;

  /// Iterator for the list response
  ///
  /// @param this_ the object handle
  Future<String> getIterator() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_member_list_response_get_iterator,
        [_pointer.address],
      );

  /// List of collection members included in the response
  ///
  /// @param this_ the object handle
  /// @param[out] data the array to store the collection members in
  Future<List<EtebaseCollectionMember>> getData() async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_member_list_response_get_data,
        [_pointer.address],
      );

  /// Indicates whether there is no more data to fetch
  ///
  /// @param this_ the object handle
  Future<bool> isDone() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_member_list_response_is_done,
        [_pointer.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  static Future<void> _destroy(
          _i2.Pointer<_i3.EtebaseMemberListResponse> this_) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_member_list_response_destroy,
        [this_.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    _finalizer.detach(this);
    await _destroy(_pointer);
  }
}

class EtebaseItemMetadata {
  EtebaseItemMetadata._(this._pointer) {
    _finalizer.attach(
      this,
      _pointer,
      detach: this,
    );
  }

  static final _finalizer = Finalizer(_destroy);

  final _i2.Pointer<_i3.EtebaseItemMetadata> _pointer;

  /// Create a new metadata object
  ///
  /// Should be destroyed with `etebase_item_metadata_destroy`
  static Future<EtebaseItemMetadata> create() async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_item_metadata_new,
        const [],
      );

  /// Set the item type
  ///
  /// @param this_ the object handle
  /// @param item_type the type to be set
  Future<void> setItemType(String itemType) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_item_metadata_set_item_type,
        [
          _pointer.address,
          itemType,
        ],
      );

  /// The item type
  ///
  /// @param this_ the object handle
  Future<String> getItemType() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_item_metadata_get_item_type,
        [_pointer.address],
      );

  /// Set the item name
  ///
  /// For example, you can set it to "Secret Note" or "todo.txt"
  ///
  /// @param this_ the object handle
  /// @param name the name to be set
  Future<void> setName(String name) async => _i1.EtebaseIsolate.current.invoke(
        #etebase_item_metadata_set_name,
        [
          _pointer.address,
          name,
        ],
      );

  /// The item name
  ///
  /// @param this_ the object handle
  Future<String> getName() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_item_metadata_get_name,
        [_pointer.address],
      );

  /// Set the modification time of the item
  ///
  /// @param this_ the object handle
  /// @param mtime the modification time in milliseconds since epoch
  Future<void> setMtime(DateTime mtime) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_item_metadata_set_mtime,
        [
          _pointer.address,
          mtime,
        ],
      );

  /// Modification time of the item
  ///
  /// @param this_ the object handle
  Future<DateTime> getMtime() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_item_metadata_get_mtime,
        [_pointer.address],
      );

  /// Set a description for the item
  ///
  /// @param this_ the object handle
  /// @param description the description to be set
  Future<void> setDescription(String description) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_item_metadata_set_description,
        [
          _pointer.address,
          description,
        ],
      );

  /// The item description
  ///
  /// @param this_ the object handle
  Future<String> getDescription() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_item_metadata_get_description,
        [_pointer.address],
      );

  /// Set a color for the item
  ///
  /// @param this_ the object handle
  /// @param color the color to be set in `#RRGGBB` or `#RRGGBBAA` format
  Future<void> setColor(String color) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_item_metadata_set_color,
        [
          _pointer.address,
          color,
        ],
      );

  /// The item color in `#RRGGBB` or `#RRGGBBAA` format
  ///
  /// @param this_ the object handle
  Future<String> getColor() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_item_metadata_get_color,
        [_pointer.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  static Future<void> _destroy(
          _i2.Pointer<_i3.EtebaseItemMetadata> this_) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_item_metadata_destroy,
        [this_.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    _finalizer.detach(this);
    await _destroy(_pointer);
  }
}

class EtebaseItemManager {
  EtebaseItemManager._(this._pointer) {
    _finalizer.attach(
      this,
      _pointer,
      detach: this,
    );
  }

  static final _finalizer = Finalizer(_destroy);

  final _i2.Pointer<_i3.EtebaseItemManager> _pointer;

  /// Fetch a single item from the server using its UID
  ///
  /// @param this_ the object handle
  /// @param item_uid the UID of the item to be fetched
  /// @param fetch_options the `EtebaseFetchOptions` to fetch with
  Future<EtebaseItem> fetch(
    String itemUid,
    EtebaseFetchOptions fetchOptions,
  ) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_item_manager_fetch,
        [
          _pointer.address,
          itemUid,
          fetchOptions,
        ],
      );

  /// Create a new item
  ///
  /// Should be destroyed with `etebase_item_destroy`
  ///
  /// @param this_ the object handle
  /// @param meta the [ItemMetadata] for the item
  /// @param content the item's content as a byte array
  /// @param content_size the content size
  Future<EtebaseItem> create(
    EtebaseItemMetadata meta,
    _i4.Uint8List content,
  ) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_item_manager_create,
        [
          _pointer.address,
          meta,
          content,
        ],
      );

  /// Create a new item using raw metadata
  ///
  /// Unlike `etebase_item_manager_create`, this receives the metadata as valid `EtebaseItemMetadata`-like struct encoded using `msgpack`.
  /// This can be used to create collections with custom metadata types.
  ///
  /// Should be destroyed with `etebase_item_destroy`
  ///
  /// @param this_ the object handle
  /// @param meta the metadata for the item as a byte array
  /// @param meta_size the metadata size
  /// @param content the item's content as a byte array
  /// @param content_size the content size
  Future<EtebaseItem> createRaw(
    _i4.Uint8List meta,
    _i4.Uint8List content,
  ) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_item_manager_create_raw,
        [
          _pointer.address,
          meta,
          content,
        ],
      );

  /// Fetch all items of a collection and return a list response
  ///
  /// @param this_ the object handle
  /// @param fetch_options the `EtebaseFetchOptions` to fetch with
  Future<EtebaseItemListResponse> list(
          EtebaseFetchOptions fetchOptions) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_item_manager_list,
        [
          _pointer.address,
          fetchOptions,
        ],
      );

  /// Fetch and return a list response of items with each item as the revision
  ///
  /// @param this_ the object handle
  /// @param item the item for which to fetch the revision history
  /// @param fetch_options the `EtebaseFetchOptions` to fetch with
  Future<EtebaseItemRevisionsListResponse> itemRevisions(
    EtebaseItem item,
    EtebaseFetchOptions fetchOptions,
  ) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_item_manager_item_revisions,
        [
          _pointer.address,
          item,
          fetchOptions,
        ],
      );

  /// Fetch the latest revision of the supplied items from the server and return a list response
  ///
  /// @param this_ the object handle
  /// @param items the list of items to be fetched
  /// @param items_size the number of items
  /// @param fetch_options the `EtebaseFetchOptions` to fetch with
  Future<EtebaseItemListResponse> fetchUpdates(
    List<EtebaseItem> items,
    EtebaseFetchOptions fetchOptions,
  ) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_item_manager_fetch_updates,
        [
          _pointer.address,
          items,
          fetchOptions,
        ],
      );

  /// Fetch multiple Items using their UID
  ///
  /// See etebase_item_manager_fetch for fetching a single item
  ///
  /// @param this_ the object handle
  /// @param items the list of item uids to be fetched
  /// @param items_size the number of items
  /// @param fetch_options the `EtebaseFetchOptions` to fetch with
  Future<EtebaseItemListResponse> fetchMulti(
    List<String> items,
    EtebaseFetchOptions fetchOptions,
  ) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_item_manager_fetch_multi,
        [
          _pointer.address,
          items,
          fetchOptions,
        ],
      );

  /// Upload the supplied items to the server
  ///
  /// @param this_ the object handle
  /// @param items the list of items to be uploaded
  /// @param items_size the number of items
  /// @param fetch_options the `EtebaseFetchOptions` to upload with
  Future<void> batch(
    List<EtebaseItem> items,
    EtebaseFetchOptions fetchOptions,
  ) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_item_manager_batch,
        [
          _pointer.address,
          items,
          fetchOptions,
        ],
      );

  /// Upload the supplied items to the server with a list of items as dependencies
  ///
  /// This will fail if the dependencies have changed remotely
  ///
  /// @param this_ the object handle
  /// @param items the list of items to be uploaded
  /// @param items_size the number of items
  /// @param deps the list of items to be treated as dependencies
  /// @param deps_size the number of dependencies
  /// @param fetch_options the `EtebaseFetchOptions` to upload with
  Future<void> batchDeps(
    List<EtebaseItem> items,
    List<EtebaseItem> deps,
    EtebaseFetchOptions fetchOptions,
  ) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_item_manager_batch_deps,
        [
          _pointer.address,
          items,
          deps,
          fetchOptions,
        ],
      );

  /// Upload items using a transaction
  ///
  /// This call ensures that the items haven't changed since we last fetched them
  ///
  /// @param this_ the object handle
  /// @param items the list of items to be uploaded
  /// @param items_size the number of items
  /// @param fetch_options the `EtebaseFetchOptions` to upload with
  Future<void> transaction(
    List<EtebaseItem> items,
    EtebaseFetchOptions fetchOptions,
  ) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_item_manager_transaction,
        [
          _pointer.address,
          items,
          fetchOptions,
        ],
      );

  /// Upload items using a transaction with a list of items as dependencies
  ///
  /// @param this_ the object handle
  /// @param items the list of items to be uploaded
  /// @param items_size the number of items
  /// @param deps the list of items to be treated as dependencies
  /// @param deps_size the number of dependencies
  /// @param fetch_options the `EtebaseFetchOptions` to upload with
  Future<void> transactionDeps(
    List<EtebaseItem> items,
    List<EtebaseItem> deps,
    EtebaseFetchOptions fetchOptions,
  ) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_item_manager_transaction_deps,
        [
          _pointer.address,
          items,
          deps,
          fetchOptions,
        ],
      );

  /// Load and return a cached item from a byte buffer
  ///
  /// @param this_ the object handle
  /// @param cached the byte buffer holding the cached item obtained using [cache_save]
  /// @param cached_size size of the buffer
  Future<EtebaseItem> cacheLoad(_i4.Uint8List cached) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_item_manager_cache_load,
        [
          _pointer.address,
          cached,
        ],
      );

  /// Save the item object to a byte buffer for caching
  ///
  /// The item can later be loaded using `etebase_item_manager_cache_load`
  ///
  /// @param this_ the object handle
  /// @param item the item object to be cached
  /// @param[out] ret_size to hold the size of the returned buffer
  Future<_i4.Uint8List> cacheSave(EtebaseItem item) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_item_manager_cache_save,
        [
          _pointer.address,
          item,
        ],
      );

  /// Save the item object and its content to a byte buffer for caching
  ///
  /// The item can later be loaded using `etebase_item_manager_cache_load`
  ///
  /// @param this_ the object handle
  /// @param item the item object to be cached
  /// @param[out] ret_size to hold the size of the returned buffer
  Future<_i4.Uint8List> cacheSaveWithContent(EtebaseItem item) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_item_manager_cache_save_with_content,
        [
          _pointer.address,
          item,
        ],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  static Future<void> _destroy(
          _i2.Pointer<_i3.EtebaseItemManager> this_) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_item_manager_destroy,
        [this_.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    _finalizer.detach(this);
    await _destroy(_pointer);
  }
}

class EtebaseItemListResponse {
  EtebaseItemListResponse._(this._pointer) {
    _finalizer.attach(
      this,
      _pointer,
      detach: this,
    );
  }

  static final _finalizer = Finalizer(_destroy);

  final _i2.Pointer<_i3.EtebaseItemListResponse> _pointer;

  /// Sync token for the list response
  ///
  /// @param this_ the object handle
  Future<String> getStoken() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_item_list_response_get_stoken,
        [_pointer.address],
      );

  /// List of items included in the response
  ///
  /// @param this_ the object handle
  /// @param[out] data the array to store the items in
  Future<List<EtebaseItem>> getData() async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_item_list_response_get_data,
        [_pointer.address],
      );

  /// Indicates whether there are no more items to fetch
  ///
  /// @param this_ the object handle
  Future<bool> isDone() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_item_list_response_is_done,
        [_pointer.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  static Future<void> _destroy(
          _i2.Pointer<_i3.EtebaseItemListResponse> this_) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_item_list_response_destroy,
        [this_.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    _finalizer.detach(this);
    await _destroy(_pointer);
  }
}

class EtebaseItem {
  EtebaseItem._(this._pointer) {
    _finalizer.attach(
      this,
      _pointer,
      detach: this,
    );
  }

  static final _finalizer = Finalizer(_destroy);

  final _i2.Pointer<_i3.EtebaseItem> _pointer;

  /// Clone an item object
  ///
  /// @param this_ the object handle
  Future<EtebaseItem> clone() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_item_clone,
        [_pointer.address],
      );

  /// Manually verify the integrity of the item
  ///
  /// This is also done automatically by the API
  ///
  /// @param this_ the object handle
  Future<bool> verify() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_item_verify,
        [_pointer.address],
      );

  /// Set metadata for the item object
  ///
  /// @param this_ the object handle
  /// @param meta the metadata object to be set for the item
  Future<void> setMeta(EtebaseItemMetadata meta) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_item_set_meta,
        [
          _pointer.address,
          meta,
        ],
      );

  /// Return the metadata of the item
  ///
  /// @param this_ the object handle
  Future<EtebaseItemMetadata> getMeta() async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_item_get_meta,
        [_pointer.address],
      );

  /// Set metadata for the item object from a byte array
  ///
  /// @param this_ the object handle
  /// @param meta the metadata for the item. This needs to be a valid `EtebaseItemMetadata`-like struct encoded using `msgpack`.
  /// @param meta_size the metadata size
  Future<void> setMetaRaw(_i4.Uint8List meta) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_item_set_meta_raw,
        [
          _pointer.address,
          meta,
        ],
      );

  /// Write the metadata of the item to a byte array and return its length
  ///
  /// @param this_ the object handle
  /// @param[out] buf the output byte buffer
  /// @param buf_size the maximum number of bytes to be written to buf
  Future<_i4.Uint8List> getMetaRaw() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_item_get_meta_raw,
        [_pointer.address],
      );

  /// Set the content of the item
  ///
  /// @param this_ the object handle
  /// @param content the content of the item as a byte array
  /// @param content_size the content size
  Future<void> setContent(_i4.Uint8List content) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_item_set_content,
        [
          _pointer.address,
          content,
        ],
      );

  /// Write the content of the item to a byte array and return its length
  ///
  /// @param this_ the object handle
  /// @param[out] buf the output byte buffer
  /// @param buf_size the maximum number of bytes to be written to buf
  Future<_i4.Uint8List> getContent() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_item_get_content,
        [_pointer.address],
      );

  /// Mark the item as deleted
  ///
  /// The item needs to be \ref uploaded `etebase_item_manager_batch` for this to take effect
  ///
  /// @param this_ the object handle
  Future<void> delete() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_item_delete,
        [_pointer.address],
      );

  /// Check whether the item is marked as deleted
  ///
  /// @param this_ the object handle
  Future<bool> isDeleted() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_item_is_deleted,
        [_pointer.address],
      );

  /// The UID of the item
  ///
  /// @param this_ the object handle
  Future<String> getUid() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_item_get_uid,
        [_pointer.address],
      );

  /// The etag of the item
  ///
  /// @param this_ the object handle
  Future<String> getEtag() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_item_get_etag,
        [_pointer.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  static Future<void> _destroy(_i2.Pointer<_i3.EtebaseItem> this_) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_item_destroy,
        [this_.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    _finalizer.detach(this);
    await _destroy(_pointer);
  }
}

class EtebaseFileSystemCache {
  EtebaseFileSystemCache._(this._pointer) {
    _finalizer.attach(
      this,
      _pointer,
      detach: this,
    );
  }

  static final _finalizer = Finalizer(_destroy);

  final _i2.Pointer<_i3.EtebaseFileSystemCache> _pointer;

  /// Initialize a file system cache object
  ///
  /// Should be destroyed with `etebase_fs_cache_destroy`
  ///
  /// @param path the path to a directory to store cache in
  /// @param username username of the user to cache data for
  static Future<EtebaseFileSystemCache> create(
    String path,
    String username,
  ) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_fs_cache_new,
        [
          path,
          username,
        ],
      );

  /// Clear all cache for the user
  ///
  /// @param this_ the object handle
  Future<void> clearUser() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_fs_cache_clear_user,
        [_pointer.address],
      );

  /// Save the user account
  ///
  /// Load it later using `etebase_fs_cache_load_account`
  ///
  /// @param this_ the object handle
  /// @param etebase the account to save
  /// @param encryption_key used to encrypt the saved account string to enhance security
  /// @param encryption_key_size the size of the encryption_key
  Future<void> saveAccount(
    EtebaseAccount etebase,
    _i4.Uint8List encryptionKey,
  ) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_fs_cache_save_account,
        [
          _pointer.address,
          etebase,
          encryptionKey,
        ],
      );

  /// Load the account object from cache
  ///
  /// @param this_ the object handle
  /// @param client the already setup [Client] object
  /// @param encryption_key the same encryption key passed to [Self::save_account] while saving the account
  /// @param encryption_key_size the size of the encryption_key
  Future<EtebaseAccount> loadAccount(
    EtebaseClient client,
    _i4.Uint8List encryptionKey,
  ) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_fs_cache_load_account,
        [
          _pointer.address,
          client,
          encryptionKey,
        ],
      );

  /// Save the collection list sync token
  ///
  /// @param this_ the object handle
  /// @param stoken the sync token to be saved
  Future<void> saveStoken(String stoken) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_fs_cache_save_stoken,
        [
          _pointer.address,
          stoken,
        ],
      );

  /// Load the collection list sync token from cache
  ///
  /// @param this_ the object handle
  Future<String> loadStoken() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_fs_cache_load_stoken,
        [_pointer.address],
      );

  /// Save a collection's sync token
  ///
  /// @param this_ the object handle
  /// @param col_uid the UID of the collection
  /// @param stoken the sync token to be saved
  Future<void> collectionSaveStoken(
    String colUid,
    String stoken,
  ) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_fs_cache_collection_save_stoken,
        [
          _pointer.address,
          colUid,
          stoken,
        ],
      );

  /// Load the sync token for a collection
  ///
  /// @param this_ the object handle
  /// @param col_uid the UID of the collection
  Future<String> collectionLoadStoken(String colUid) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_fs_cache_collection_load_stoken,
        [
          _pointer.address,
          colUid,
        ],
      );

  /// Save a collection to cache
  ///
  /// @param this_ the object handle
  /// @param col_mgr collection manager for the account
  /// @param col the collection to be saved
  Future<void> collectionSet(
    EtebaseCollectionManager colMgr,
    EtebaseCollection col,
  ) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_fs_cache_collection_set,
        [
          _pointer.address,
          colMgr,
          col,
        ],
      );

  /// Remove a collection from cache
  ///
  /// @param this_ the object handle
  /// @param col_mgr collection manager for the account
  /// @param col_uid the UID of the collection to remove
  Future<void> collectionUnset(
    EtebaseCollectionManager colMgr,
    String colUid,
  ) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_fs_cache_collection_unset,
        [
          _pointer.address,
          colMgr,
          colUid,
        ],
      );

  /// Load a collection from cache
  ///
  /// @param this_ the object handle
  /// @param col_mgr collection manager for the account
  /// @param col_uid the UID of the collection
  Future<EtebaseCollection> collectionGet(
    EtebaseCollectionManager colMgr,
    String colUid,
  ) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_fs_cache_collection_get,
        [
          _pointer.address,
          colMgr,
          colUid,
        ],
      );

  /// Save an item to cache
  ///
  /// @param this_ the object handle
  /// @param item_mgr item manager for the parent collection
  /// @param col_uid the UID of the parent collection
  /// @param item the item to be saved
  Future<void> itemSet(
    EtebaseItemManager itemMgr,
    String colUid,
    EtebaseItem item,
  ) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_fs_cache_item_set,
        [
          _pointer.address,
          itemMgr,
          colUid,
          item,
        ],
      );

  /// Remove an item from cache
  ///
  /// @param this_ the object handle
  /// @param item_mgr item manager for the parent collection
  /// @param col_uid the UID of the parent collection
  /// @param item_uid the UID of the item
  Future<void> itemUnset(
    EtebaseItemManager itemMgr,
    String colUid,
    String itemUid,
  ) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_fs_cache_item_unset,
        [
          _pointer.address,
          itemMgr,
          colUid,
          itemUid,
        ],
      );

  /// Load an item from cache
  ///
  /// @param this_ the object handle
  /// @param item_mgr item manager for the parent collection
  /// @param col_uid the UID of the parent collection
  /// @param item_uid the UID of the item
  Future<EtebaseItem> itemGet(
    EtebaseItemManager itemMgr,
    String colUid,
    String itemUid,
  ) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_fs_cache_item_get,
        [
          _pointer.address,
          itemMgr,
          colUid,
          itemUid,
        ],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  static Future<void> _destroy(
          _i2.Pointer<_i3.EtebaseFileSystemCache> this_) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_fs_cache_destroy,
        [this_.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    _finalizer.detach(this);
    await _destroy(_pointer);
  }
}

class EtebaseFetchOptions {
  EtebaseFetchOptions._(this._pointer) {
    _finalizer.attach(
      this,
      _pointer,
      detach: this,
    );
  }

  static final _finalizer = Finalizer(_destroy);

  final _i2.Pointer<_i3.EtebaseFetchOptions> _pointer;

  /// Return a new fetch options object
  ///
  /// Should be destroyed with `etebase_fetch_options_destroy`
  static Future<EtebaseFetchOptions> create() async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_fetch_options_new,
        const [],
      );

  /// Limit the amount of items returned
  ///
  /// @param this_ the object handle
  /// @param limit the limit to set
  Future<void> setLimit(int limit) async => _i1.EtebaseIsolate.current.invoke(
        #etebase_fetch_options_set_limit,
        [
          _pointer.address,
          limit,
        ],
      );

  /// How much data to prefetech
  ///
  /// @param this_ the object handle
  /// @param prefetch the prefetch option to set
  Future<void> setPrefetch(_i6.EtebasePrefetchOption prefetch) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_fetch_options_set_prefetch,
        [
          _pointer.address,
          prefetch,
        ],
      );

  /// Toggle fetching the collection's item
  ///
  /// @param this_ the object handle
  /// @param with_collection set whether to fetch the collection's item
  Future<void> setWithCollection(bool withCollection) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_fetch_options_set_with_collection,
        [
          _pointer.address,
          withCollection,
        ],
      );

  /// The current iterator to start from (when iterating lists)
  ///
  /// @param this_ the object handle
  /// @param iterator the iterator to start from
  Future<void> setIterator(String iterator) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_fetch_options_set_iterator,
        [
          _pointer.address,
          iterator,
        ],
      );

  /// The sync token to fetch with
  ///
  /// @param this_ the object handle
  /// @param stoken the sync token to set
  Future<void> setStoken(String stoken) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_fetch_options_set_stoken,
        [
          _pointer.address,
          stoken,
        ],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  static Future<void> _destroy(
          _i2.Pointer<_i3.EtebaseFetchOptions> this_) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_fetch_options_destroy,
        [this_.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    _finalizer.detach(this);
    await _destroy(_pointer);
  }
}

class EtebaseCollectionMemberManager {
  EtebaseCollectionMemberManager._(this._pointer) {
    _finalizer.attach(
      this,
      _pointer,
      detach: this,
    );
  }

  static final _finalizer = Finalizer(_destroy);

  final _i2.Pointer<_i3.EtebaseCollectionMemberManager> _pointer;

  /// List the members of a collection
  ///
  /// @param this_ the object handle
  /// @param fetch_options the `EtebaseFetchOptions` to fetch with
  Future<EtebaseMemberListResponse> list(
          EtebaseFetchOptions fetchOptions) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_member_manager_list,
        [
          _pointer.address,
          fetchOptions,
        ],
      );

  /// Remove a member from the collection
  ///
  /// @param this_ the object handle
  /// @param username the member's username
  Future<void> remove(String username) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_member_manager_remove,
        [
          _pointer.address,
          username,
        ],
      );

  /// Leave a collection the user is a member of
  ///
  /// @param this_ the object handle
  Future<void> leave() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_member_manager_leave,
        [_pointer.address],
      );

  /// Modify the access level of a member
  ///
  /// @param this_ the object handle
  /// @param username the member's username
  /// @param access_level the new `EtebaseCollectionAccessLevel`
  Future<void> modifyAccessLevel(
    String username,
    _i5.EtebaseCollectionAccessLevel accessLevel,
  ) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_member_manager_modify_access_level,
        [
          _pointer.address,
          username,
          accessLevel,
        ],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  static Future<void> _destroy(
          _i2.Pointer<_i3.EtebaseCollectionMemberManager> this_) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_member_manager_destroy,
        [this_.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    _finalizer.detach(this);
    await _destroy(_pointer);
  }
}

class EtebaseCollectionMember {
  EtebaseCollectionMember._(this._pointer) {
    _finalizer.attach(
      this,
      _pointer,
      detach: this,
    );
  }

  static final _finalizer = Finalizer(_destroy);

  final _i2.Pointer<_i3.EtebaseCollectionMember> _pointer;

  /// Clone the object
  ///
  /// @param this_ the object handle
  Future<EtebaseCollectionMember> clone() async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_member_clone,
        [_pointer.address],
      );

  /// The username of a member
  ///
  /// @param this_ the object handle
  Future<String> getUsername() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_member_get_username,
        [_pointer.address],
      );

  /// The access_level of the member
  ///
  /// @param this_ the object handle
  Future<_i5.EtebaseCollectionAccessLevel> getAccessLevel() async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_member_get_access_level,
        [_pointer.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  static Future<void> _destroy(
          _i2.Pointer<_i3.EtebaseCollectionMember> this_) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_member_destroy,
        [this_.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    _finalizer.detach(this);
    await _destroy(_pointer);
  }
}

class EtebaseCollectionManager {
  EtebaseCollectionManager._(this._pointer) {
    _finalizer.attach(
      this,
      _pointer,
      detach: this,
    );
  }

  static final _finalizer = Finalizer(_destroy);

  final _i2.Pointer<_i3.EtebaseCollectionManager> _pointer;

  /// Fetch a single collection from the server using its UID
  ///
  /// @param this_ the object handle
  /// @param col_uid the UID of the collection to be fetched
  /// @param fetch_options the `EtebaseFetchOptions` to fetch with
  Future<EtebaseCollection> fetch(
    String colUid,
    EtebaseFetchOptions fetchOptions,
  ) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_manager_fetch,
        [
          _pointer.address,
          colUid,
          fetchOptions,
        ],
      );

  /// Create a new collection
  ///
  /// Should be destroyed with `etebase_collection_destroy`
  ///
  /// @param this_ the object handle
  /// @param collection_type the type of [Item]s stored in the collection
  /// @param meta the [ItemMetadata] for the collection
  /// @param content the collection's content as a byte array. This is unrelated to the [Item]s in the collection.
  /// @param content_size the content size
  Future<EtebaseCollection> create(
    String collectionType,
    EtebaseItemMetadata meta,
    _i4.Uint8List content,
  ) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_manager_create,
        [
          _pointer.address,
          collectionType,
          meta,
          content,
        ],
      );

  /// Create a new collection using raw metadata
  ///
  /// Unlike `etebase_collection_manager_create`, this receives the metadata as valid `EtebaseItemMetadata`-like struct encoded using `msgpack`.
  /// This can be used to create collections with custom metadata types.
  ///
  /// Should be destroyed with `etebase_collection_destroy`
  ///
  /// @param this_ the object handle
  /// @param collection_type the type of [Item]s stored in the collection
  /// @param meta the metadata for the collection as a byte array
  /// @param meta_size the metadata size
  /// @param content the collection's content as a byte array. This is unrelated to the [Item]s in the collection.
  /// @param content_size the content size
  Future<EtebaseCollection> createRaw(
    String collectionType,
    _i4.Uint8List meta,
    _i4.Uint8List content,
  ) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_manager_create_raw,
        [
          _pointer.address,
          collectionType,
          meta,
          content,
        ],
      );

  /// Return the item manager for the supplied collection
  ///
  /// @param this_ the object handle
  /// @param col the collection for which the item manager is required
  Future<EtebaseItemManager> getItemManager(EtebaseCollection col) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_manager_get_item_manager,
        [
          _pointer.address,
          col,
        ],
      );

  /// Fetch all collections of a specific type from the server and return a list response
  ///
  /// @param this_ the object handle
  /// @param collection_type the type of items stored in the collection
  /// @param fetch_options the `EtebaseFetchOptions` to fetch with
  Future<EtebaseCollectionListResponse> list(
    String collectionType,
    EtebaseFetchOptions fetchOptions,
  ) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_manager_list,
        [
          _pointer.address,
          collectionType,
          fetchOptions,
        ],
      );

  /// Fetch all collections of the supplied types from the server and return a list response
  ///
  /// @param this_ the object handle
  /// @param collection_types array of strings denoting the collection types
  /// @param collection_types_size size of the collection_types array
  /// @param fetch_options the `EtebaseFetchOptions` to fetch with
  Future<EtebaseCollectionListResponse> listMulti(
    List<String> collectionTypes,
    EtebaseFetchOptions fetchOptions,
  ) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_manager_list_multi,
        [
          _pointer.address,
          collectionTypes,
          fetchOptions,
        ],
      );

  /// Upload a collection
  ///
  /// @param this_ the object handle
  /// @param collection the collection object to be uploaded
  /// @param fetch_options the `EtebaseFetchOptions` to upload with
  Future<void> upload(
    EtebaseCollection collection,
    EtebaseFetchOptions fetchOptions,
  ) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_manager_upload,
        [
          _pointer.address,
          collection,
          fetchOptions,
        ],
      );

  /// Upload a collection using a transaction
  ///
  /// This call ensures that the collection hasn't changed since we last fetched it
  ///
  /// @param this_ the object handle
  /// @param collection the collection object to be uploaded
  /// @param fetch_options the `EtebaseFetchOptions` to upload with
  Future<void> transaction(
    EtebaseCollection collection,
    EtebaseFetchOptions fetchOptions,
  ) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_manager_transaction,
        [
          _pointer.address,
          collection,
          fetchOptions,
        ],
      );

  /// Load and return a cached collection object from a byte buffer
  ///
  /// @param this_ the object handle
  /// @param cached the byte buffer holding the cached collection obtained using [cache_save]
  /// @param cached_size size of the buffer
  Future<EtebaseCollection> cacheLoad(_i4.Uint8List cached) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_manager_cache_load,
        [
          _pointer.address,
          cached,
        ],
      );

  /// Save the collection object to a byte buffer for caching
  ///
  /// The collection can later be loaded using `etebase_collection_manager_cache_load`
  ///
  /// @param this_ the object handle
  /// @param collection the collection object to be cached
  /// @param[out] ret_size to hold the size of the returned buffer
  Future<_i4.Uint8List> cacheSave(EtebaseCollection collection) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_manager_cache_save,
        [
          _pointer.address,
          collection,
        ],
      );

  /// Save the collection object and its content to a byte buffer for caching
  ///
  /// The collection can later be loaded using `etebase_collection_manager_cache_load`
  ///
  /// @param this_ the object handle
  /// @param collection the collection object to be cached
  /// @param[out] ret_size to hold the size of the returned buffer
  Future<_i4.Uint8List> cacheSaveWithContent(
          EtebaseCollection collection) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_manager_cache_save_with_content,
        [
          _pointer.address,
          collection,
        ],
      );

  /// Return the collection member manager for the supplied collection
  ///
  /// @param this_ the object handle
  /// @param col the collection for which the manager is required
  Future<EtebaseCollectionMemberManager> getMemberManager(
          EtebaseCollection col) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_manager_get_member_manager,
        [
          _pointer.address,
          col,
        ],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  static Future<void> _destroy(
          _i2.Pointer<_i3.EtebaseCollectionManager> this_) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_manager_destroy,
        [this_.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    _finalizer.detach(this);
    await _destroy(_pointer);
  }
}

class EtebaseCollectionListResponse {
  EtebaseCollectionListResponse._(this._pointer) {
    _finalizer.attach(
      this,
      _pointer,
      detach: this,
    );
  }

  static final _finalizer = Finalizer(_destroy);

  final _i2.Pointer<_i3.EtebaseCollectionListResponse> _pointer;

  /// Sync token for the list response
  ///
  /// @param this_ the object handle
  Future<String> getStoken() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_list_response_get_stoken,
        [_pointer.address],
      );

  /// List of collections included in the response
  ///
  /// @param this_ the object handle
  /// @param[out] data the array to store the collections in
  Future<List<EtebaseCollection>> getData() async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_list_response_get_data,
        [_pointer.address],
      );

  /// Indicates whether there are no more collections to fetch
  ///
  /// @param this_ the object handle
  Future<bool> isDone() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_list_response_is_done,
        [_pointer.address],
      );

  /// The list of collections to which the user lost access
  ///
  /// @param this_ the object handle
  /// @param[out] data the array to store the collections in
  Future<List<EtebaseRemovedCollection>> getRemovedMemberships() async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_list_response_get_removed_memberships,
        [_pointer.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  static Future<void> _destroy(
          _i2.Pointer<_i3.EtebaseCollectionListResponse> this_) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_list_response_destroy,
        [this_.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    _finalizer.detach(this);
    await _destroy(_pointer);
  }
}

class EtebaseCollectionInvitationManager {
  EtebaseCollectionInvitationManager._(this._pointer) {
    _finalizer.attach(
      this,
      _pointer,
      detach: this,
    );
  }

  static final _finalizer = Finalizer(_destroy);

  final _i2.Pointer<_i3.EtebaseCollectionInvitationManager> _pointer;

  /// List the incoming collection invitations for the account
  ///
  /// @param this_ the object handle
  /// @param fetch_options the `EtebaseFetchOptions` to fetch with
  Future<EtebaseInvitationListResponse> listIncoming(
          EtebaseFetchOptions fetchOptions) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_invitation_manager_list_incoming,
        [
          _pointer.address,
          fetchOptions,
        ],
      );

  /// List the outgoing collection invitations for the account
  ///
  /// @param this_ the object handle
  /// @param fetch_options the `EtebaseFetchOptions` to fetch with
  Future<EtebaseInvitationListResponse> listOutgoing(
          EtebaseFetchOptions fetchOptions) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_invitation_manager_list_outgoing,
        [
          _pointer.address,
          fetchOptions,
        ],
      );

  /// Accept an invitation
  ///
  /// @param this_ the object handle
  /// @param invitation the invitation to accept
  Future<void> accept(EtebaseSignedInvitation invitation) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_invitation_manager_accept,
        [
          _pointer.address,
          invitation,
        ],
      );

  /// Reject an invitation
  ///
  /// @param this_ the object handle
  /// @param invitation the invitation to reject
  Future<void> reject(EtebaseSignedInvitation invitation) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_invitation_manager_reject,
        [
          _pointer.address,
          invitation,
        ],
      );

  /// Fetch and return a user's profile
  ///
  /// @param this_ the object handle
  /// @param username the username of the user to fetch
  Future<EtebaseUserProfile> fetchUserProfile(String username) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_invitation_manager_fetch_user_profile,
        [
          _pointer.address,
          username,
        ],
      );

  /// Invite a user to a collection
  ///
  /// @param this_ the object handle
  /// @param collection the collection to invite to
  /// @param username the username of the user to invite
  /// @param pubkey the public key of the user to invite
  /// @param pubkey_size the size of the public key
  /// @param access_level the level of access to give to user
  Future<void> invite(
    EtebaseCollection collection,
    String username,
    _i4.Uint8List pubkey,
    _i5.EtebaseCollectionAccessLevel accessLevel,
  ) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_invitation_manager_invite,
        [
          _pointer.address,
          collection,
          username,
          pubkey,
          accessLevel,
        ],
      );

  /// Cancel an invitation (disinvite)
  ///
  /// @param this_ the object handle
  /// @param invitation the invitation to cancel
  Future<void> disinvite(EtebaseSignedInvitation invitation) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_invitation_manager_disinvite,
        [
          _pointer.address,
          invitation,
        ],
      );

  /// Our identity's public key
  ///
  /// This is the key users see when we send invitations.
  /// Can be pretty printed with `etebase_utils_pretty_fingerprint`.
  ///
  /// @param this_ the object handle
  Future<_i4.Uint8List> getPubkey() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_invitation_manager_get_pubkey,
        [_pointer.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  static Future<void> _destroy(
          _i2.Pointer<_i3.EtebaseCollectionInvitationManager> this_) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_invitation_manager_destroy,
        [this_.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    _finalizer.detach(this);
    await _destroy(_pointer);
  }
}

class EtebaseCollection {
  EtebaseCollection._(this._pointer) {
    _finalizer.attach(
      this,
      _pointer,
      detach: this,
    );
  }

  static final _finalizer = Finalizer(_destroy);

  final _i2.Pointer<_i3.EtebaseCollection> _pointer;

  /// Clone a collection object
  ///
  /// @param this_ the object handle
  Future<EtebaseCollection> clone() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_clone,
        [_pointer.address],
      );

  /// Manually verify the integrity of the collection
  ///
  /// This is also done automatically by the API
  ///
  /// @param this_ the object handle
  Future<bool> verify() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_verify,
        [_pointer.address],
      );

  /// Set metadata for the collection object
  ///
  /// @param this_ the object handle
  /// @param meta the metadata object to be set for the collection
  Future<void> setMeta(EtebaseItemMetadata meta) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_set_meta,
        [
          _pointer.address,
          meta,
        ],
      );

  /// Return the metadata of the collection
  ///
  /// @param this_ the object handle
  Future<EtebaseItemMetadata> getMeta() async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_get_meta,
        [_pointer.address],
      );

  /// Set metadata for the collection object from a byte array
  ///
  /// @param this_ the object handle
  /// @param meta the metadata for the collection. This needs to be a valid `EtebaseItemMetadata`-like struct encoded using `msgpack`.
  /// @param meta_size the metadata size
  Future<void> setMetaRaw(_i4.Uint8List meta) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_set_meta_raw,
        [
          _pointer.address,
          meta,
        ],
      );

  /// Write the metadata of the collection to a byte array and return its length
  ///
  /// @param this_ the object handle
  /// @param[out] buf the output byte buffer
  /// @param buf_size the maximum number of bytes to be written to buf
  Future<_i4.Uint8List> getMetaRaw() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_get_meta_raw,
        [_pointer.address],
      );

  /// Set the content of the collection
  ///
  /// @param this_ the object handle
  /// @param content the content of the collection as a byte array
  /// @param content_size the content size
  Future<void> setContent(_i4.Uint8List content) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_set_content,
        [
          _pointer.address,
          content,
        ],
      );

  /// Write the content of the collection to a byte array and return its length
  ///
  /// @param this_ the object handle
  /// @param[out] buf the output byte buffer
  /// @param buf_size the maximum number of bytes to be written to buf
  Future<_i4.Uint8List> getContent() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_get_content,
        [_pointer.address],
      );

  /// Mark the collection as deleted
  ///
  /// The collection needs to be \ref uploaded `etebase_collection_manager_upload` for this to take effect
  ///
  /// @param this_ the object handle
  Future<void> delete() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_delete,
        [_pointer.address],
      );

  /// Check whether the collection is marked as deleted
  ///
  /// @param this_ the object handle
  Future<bool> isDeleted() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_is_deleted,
        [_pointer.address],
      );

  /// The UID of the collection
  ///
  /// @param this_ the object handle
  Future<String> getUid() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_get_uid,
        [_pointer.address],
      );

  /// The etag of the collection
  ///
  /// @param this_ the object handle
  Future<String> getEtag() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_get_etag,
        [_pointer.address],
      );

  /// The sync token for the collection
  ///
  /// The sync token reflects changes to the collection properties or its items on the server
  ///
  /// @param this_ the object handle
  Future<String> getStoken() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_get_stoken,
        [_pointer.address],
      );

  /// Return the collection as an item
  ///
  /// @param this_ the object handle
  Future<EtebaseItem> asItem() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_as_item,
        [_pointer.address],
      );

  /// The type of the collection
  ///
  /// @param this_ the object handle
  Future<String> getCollectionType() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_get_collection_type,
        [_pointer.address],
      );

  /// Return the access level of the collection for the current user
  ///
  /// @param this_ the object handle
  Future<_i5.EtebaseCollectionAccessLevel> getAccessLevel() async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_get_access_level,
        [_pointer.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  static Future<void> _destroy(
          _i2.Pointer<_i3.EtebaseCollection> this_) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_collection_destroy,
        [this_.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    _finalizer.detach(this);
    await _destroy(_pointer);
  }
}

class EtebaseClient {
  EtebaseClient._(this._pointer) {
    _finalizer.attach(
      this,
      _pointer,
      detach: this,
    );
  }

  static final _finalizer = Finalizer(_destroy);

  final _i2.Pointer<_i3.EtebaseClient> _pointer;

  static Future<EtebaseClient> create(
    String clientName,
    String serverUrl,
  ) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_client_new,
        [
          clientName,
          serverUrl,
        ],
      );
  Future<void> setServerUrl(String serverUrl) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_client_set_server_url,
        [
          _pointer.address,
          serverUrl,
        ],
      );

  /// Returns 0 if client is pointing an etebase server, 1 if not, -1 on error
  ///
  /// @param client the object handle
  Future<bool> checkEtebaseServer() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_client_check_etebase_server,
        [_pointer.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  static Future<void> _destroy(_i2.Pointer<_i3.EtebaseClient> this_) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_client_destroy,
        [this_.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    _finalizer.detach(this);
    await _destroy(_pointer);
  }
}

class EtebaseAccount {
  EtebaseAccount._(this._pointer) {
    _finalizer.attach(
      this,
      _pointer,
      detach: this,
    );
  }

  static final _finalizer = Finalizer(_destroy);

  final _i2.Pointer<_i3.EtebaseAccount> _pointer;

  /// Login a user and return a handle to an `EtebaseAccount` object
  ///
  /// @param client the already setup `EtebaseClient` object
  /// @param username the user's username. This is not the same as the user's email.
  /// @param password the user's password
  static Future<EtebaseAccount> login(
    EtebaseClient client,
    String username,
    String password,
  ) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_account_login,
        [
          client,
          username,
          password,
        ],
      );

  /// Signup a new user account and return a handle to it
  ///
  /// @param client the already setup `EtebaseClient` object
  /// @param user the already setup `EtebaseUser` object
  /// @param password the password to signup with
  static Future<EtebaseAccount> signup(
    EtebaseClient client,
    EtebaseUser user,
    String password,
  ) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_account_signup,
        [
          client,
          user,
          password,
        ],
      );

  /// Fetch a new auth token for the account and update the `EtebaseAccount` object with it
  ///
  /// @param this_ the object handle
  Future<void> fetchToken() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_account_fetch_token,
        [_pointer.address],
      );

  /// Fetch the link to the user dashboard of the account
  ///
  /// @param this_ the object handle
  Future<String> fetchDashboardUrl() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_account_fetch_dashboard_url,
        [_pointer.address],
      );

  /// Change the server URL for this account handle
  ///
  /// @param this_ the object handle
  /// @param server_url the new server URL to be set
  Future<void> forceServerUrl(String serverUrl) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_account_force_server_url,
        [
          _pointer.address,
          serverUrl,
        ],
      );

  /// Change the user's login password
  ///
  /// @param this_ the object handle
  /// @param password the new password to be set
  Future<void> changePassword(String password) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_account_change_password,
        [
          _pointer.address,
          password,
        ],
      );

  /// Logout the user from the current session and invalidate the authentication token
  ///
  /// @param this_ the object handle
  Future<void> logout() async => _i1.EtebaseIsolate.current.invoke(
        #etebase_account_logout,
        [_pointer.address],
      );

  /// Return a `EtebaseCollectionManager` for creating, fetching and uploading collections
  ///
  /// @param this_ the object handle
  Future<EtebaseCollectionManager> getCollectionManager() async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_account_get_collection_manager,
        [_pointer.address],
      );

  /// Return a `EtebaseCollectionInvitationManager` for managing collection invitations
  ///
  /// @param this_ the object handle
  Future<EtebaseCollectionInvitationManager> getInvitationManager() async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_account_get_invitation_manager,
        [_pointer.address],
      );

  /// Save the account object to a string for restoring it later using `etebase_account_restore`
  ///
  /// @param this_ the object handle
  /// @param encryption_key used to encrypt the returned account string to enhance security
  /// @param encryption_key_size size of the encryption_key
  Future<String> save(_i4.Uint8List encryptionKey) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_account_save,
        [
          _pointer.address,
          encryptionKey,
        ],
      );

  /// Restore and return the account object from the string obtained using `etebase_account_save`
  ///
  /// @param client the already setup `EtebaseClient` object
  /// @param account_data_stored the stored account string
  /// @param encryption_key the same encryption key passed to `etebase_account_save` while saving the account
  /// @param encryption_key_size size of the encryption_key
  static Future<EtebaseAccount> restore(
    EtebaseClient client,
    String accountDataStored,
    _i4.Uint8List encryptionKey,
  ) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_account_restore,
        [
          client,
          accountDataStored,
          encryptionKey,
        ],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  static Future<void> _destroy(_i2.Pointer<_i3.EtebaseAccount> this_) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_account_destroy,
        [this_.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    _finalizer.detach(this);
    await _destroy(_pointer);
  }
}

abstract class EtebaseUtils {
  EtebaseUtils._();

  /// Return a buffer filled with cryptographically random bytes
  ///
  /// @param[out] buf the output byte buffer
  /// @param size the size of the returned buffer
  static Future<_i4.Uint8List> randombytes(int size) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_utils_randombytes,
        [size],
      );

  /// Return a pretty formatted fingerprint of the content
  ///
  /// For example:
  /// ```
  /// 45680   71497   88570   93128
  /// 19189   84243   25687   20837
  /// 47924   46071   54113   18789
  /// ```
  ///
  /// @param content the content to create a fingerprint for
  /// @param content_size the size of the content buffer
  /// @param[out] buf the output byte buffer
  static Future<String> prettyFingerprint(_i4.Uint8List content) async =>
      _i1.EtebaseIsolate.current.invoke(
        #etebase_utils_pretty_fingerprint,
        [content],
      );
}
