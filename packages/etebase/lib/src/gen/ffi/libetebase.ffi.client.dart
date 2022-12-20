// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// EtebaseClientGenerator
// **************************************************************************

// ignore_for_file: require_trailing_commas, avoid_positional_boolean_parameters, lines_longer_than_80_chars, comment_references, prefer_relative_imports, prefer_if_elements_to_conditional_expressions, unused_element
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:ffi' as _i4;
import 'dart:isolate' as _i7;
import 'dart:typed_data' as _i6;

import 'package:etebase/src/gen/ffi/libetebase.ffi.dart' as _i5;
import 'package:etebase/src/isolate/destroy_reference.dart' as _i3;
import 'package:etebase/src/isolate/etebase_isolate_reference.dart' as _i1;
import 'package:etebase/src/model/etebase_collection_access_level.dart' as _i8;
import 'package:etebase/src/model/etebase_prefetch_option.dart' as _i2;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'libetebase.ffi.client.freezed.dart';

/// The URL of the main hosted server
Future<Uri> etebaseGetDefaultServerUrl() async {
  final isolate = await _i1.EtebaseIsolateReference.create();
  try {
    return await isolate.invoke<Uri>(
      #etebase_get_default_server_url,
      const <dynamic>[],
    );
  } finally {
    await isolate.dispose();
  }
}

/// The dart binding of the EtebaseUser rust class
@freezed
class EtebaseUser with _$EtebaseUser {
  /// Return a new user instance
  ///
  /// Should be destroyed with `etebase_user_destroy`
  ///
  /// @param username the user's username
  /// @param email the user's email
  const factory EtebaseUser({
    /// Get the username
    ///
    /// @param this_ the object handle
    required String username,

    /// Get the email address
    ///
    /// @param this_ the object handle
    required String email,
  }) = _EtebaseUser;
}

/// The dart binding of the EtebaseItemMetadata rust class
@freezed
class EtebaseItemMetadata with _$EtebaseItemMetadata {
  /// Create a new metadata object
  ///
  /// Should be destroyed with `etebase_item_metadata_destroy`
  const factory EtebaseItemMetadata({
    /// The item color in `#RRGGBB` or `#RRGGBBAA` format
    ///
    /// @param this_ the object handle
    String? color,

    /// The item description
    ///
    /// @param this_ the object handle
    String? description,

    /// Modification time of the item
    ///
    /// @param this_ the object handle
    DateTime? mtime,

    /// The item name
    ///
    /// @param this_ the object handle
    String? name,

    /// The item type
    ///
    /// @param this_ the object handle
    String? itemType,
  }) = _EtebaseItemMetadata;
}

/// The dart binding of the EtebaseFetchOptions rust class
@freezed
class EtebaseFetchOptions with _$EtebaseFetchOptions {
  /// Return a new fetch options object
  ///
  /// Should be destroyed with `etebase_fetch_options_destroy`
  const factory EtebaseFetchOptions({
    /// The sync token to fetch with
    ///
    /// @param this_ the object handle
    /// @param stoken the sync token to set
    String? stoken,

    /// The current iterator to start from (when iterating lists)
    ///
    /// @param this_ the object handle
    /// @param iterator the iterator to start from
    String? iterator,

    /// Toggle fetching the collection's item
    ///
    /// @param this_ the object handle
    /// @param with_collection set whether to fetch the collection's item
    bool? withCollection,

    /// How much data to prefetech
    ///
    /// @param this_ the object handle
    /// @param prefetch the prefetch option to set
    _i2.EtebasePrefetchOption? prefetch,

    /// Limit the amount of items returned
    ///
    /// @param this_ the object handle
    /// @param limit the limit to set
    int? limit,
  }) = _EtebaseFetchOptions;
}

/// The dart binding of the EtebaseUserProfile rust class
class EtebaseUserProfile {
  EtebaseUserProfile._(
    this._isolate,
    this._pointer, [
    this._owner,
  ]) {
    if (_owner == null) {
      _finalizer.attach(
        this,
        _i3.DestroyReference(
          _isolate,
          _pointer,
        ),
        detach: this,
      );
    }
  }

  static final _finalizer = Finalizer(_destroy);

  final _i1.EtebaseIsolateReference _isolate;

  final _i4.Pointer<_i5.EtebaseUserProfile> _pointer;

  final Object? _owner;

  /// The user's identity public key
  ///
  /// This is used for identifying the user and safely sending them data (such as \ref invitations EtebaseSignedInvitation).
  Future<_i6.Uint8List> getPubkey() async {
    final data = await _isolate.invoke<_i7.TransferableTypedData>(
      #etebase_user_profile_get_pubkey,
      <dynamic>[_pointer.address],
    );
    return data.materialize().asUint8List();
  }

  static Future<void> _destroy(
          _i3.DestroyReference<_i5.EtebaseUserProfile> this_) =>
      this_.isolate.invoke<void>(
        #etebase_user_profile_destroy,
        <dynamic>[this_.pointer.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    if (_owner == null) {
      _finalizer.detach(this);
      await _destroy(_i3.DestroyReference(
        _isolate,
        _pointer,
      ));
    }
  }
}

/// The dart binding of the EtebaseSignedInvitation rust class
class EtebaseSignedInvitation {
  EtebaseSignedInvitation._(
    this._isolate,
    this._pointer, [
    this._owner,
  ]) {
    if (_owner == null) {
      _finalizer.attach(
        this,
        _i3.DestroyReference(
          _isolate,
          _pointer,
        ),
        detach: this,
      );
    }
  }

  static final _finalizer = Finalizer(_destroy);

  final _i1.EtebaseIsolateReference _isolate;

  final _i4.Pointer<_i5.EtebaseSignedInvitation> _pointer;

  final Object? _owner;

  /// Clone the invitation object
  ///
  /// @param this_ the object handle
  Future<EtebaseSignedInvitation> clone() async => EtebaseSignedInvitation._(
        _isolate,
        _i4.Pointer.fromAddress(await _isolate.invoke<int>(
          #etebase_signed_invitation_clone,
          <dynamic>[_pointer.address],
        )),
      );

  /// The uid of the invitation
  ///
  /// @param this_ the object handle
  Future<String> getUid() => _isolate.invoke<String>(
        #etebase_signed_invitation_get_uid,
        <dynamic>[_pointer.address],
      );

  /// The username this invitation is for
  ///
  /// @param this_ the object handle
  Future<String> getUsername() => _isolate.invoke<String>(
        #etebase_signed_invitation_get_username,
        <dynamic>[_pointer.address],
      );

  /// The uid of the collection this invitation is for
  ///
  /// @param this_ the object handle
  Future<String> getCollection() => _isolate.invoke<String>(
        #etebase_signed_invitation_get_collection,
        <dynamic>[_pointer.address],
      );

  /// The access level offered in this invitation
  ///
  /// @param this_ the object handle
  Future<_i8.EtebaseCollectionAccessLevel> getAccessLevel() =>
      _isolate.invoke<_i8.EtebaseCollectionAccessLevel>(
        #etebase_signed_invitation_get_access_level,
        <dynamic>[_pointer.address],
      );

  /// The username this invitation is from
  ///
  /// @param this_ the object handle
  Future<String> getFromUsername() => _isolate.invoke<String>(
        #etebase_signed_invitation_get_from_username,
        <dynamic>[_pointer.address],
      );

  /// The public key of the inviting user
  ///
  /// @param this_ the object handle
  Future<_i6.Uint8List> getFromPubkey() async {
    final data = await _isolate.invoke<_i7.TransferableTypedData>(
      #etebase_signed_invitation_get_from_pubkey,
      <dynamic>[_pointer.address],
    );
    return data.materialize().asUint8List();
  }

  static Future<void> _destroy(
          _i3.DestroyReference<_i5.EtebaseSignedInvitation> this_) =>
      this_.isolate.invoke<void>(
        #etebase_signed_invitation_destroy,
        <dynamic>[this_.pointer.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    if (_owner == null) {
      _finalizer.detach(this);
      await _destroy(_i3.DestroyReference(
        _isolate,
        _pointer,
      ));
    }
  }
}

/// The dart binding of the EtebaseRemovedCollection rust class
class EtebaseRemovedCollection {
  EtebaseRemovedCollection._(
    this._isolate,
    this._pointer, [
    this._owner,
  ]) {
    if (_owner == null) {
      _finalizer.attach(
        this,
        _i3.DestroyReference(
          _isolate,
          _pointer,
        ),
        detach: this,
      );
    }
  }

  static final _finalizer = Finalizer(_destroy);

  final _i1.EtebaseIsolateReference _isolate;

  final _i4.Pointer<_i5.EtebaseRemovedCollection> _pointer;

  final Object? _owner;

  /// The uid of the removed collection
  ///
  /// @param this_ the object handle
  Future<String> getUid() => _isolate.invoke<String>(
        #etebase_removed_collection_get_uid,
        <dynamic>[_pointer.address],
      );
  static Future<void> _destroy(
          _i3.DestroyReference<_i5.EtebaseRemovedCollection> this_) =>
      this_.isolate.invoke<void>(
        #etebase_removed_collection_destroy,
        <dynamic>[this_.pointer.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    if (_owner == null) {
      _finalizer.detach(this);
      await _destroy(_i3.DestroyReference(
        _isolate,
        _pointer,
      ));
    }
  }
}

/// The dart binding of the EtebaseInvitationListResponse rust class
class EtebaseInvitationListResponse {
  EtebaseInvitationListResponse._(
    this._isolate,
    this._pointer, [
    this._owner,
  ]) {
    if (_owner == null) {
      _finalizer.attach(
        this,
        _i3.DestroyReference(
          _isolate,
          _pointer,
        ),
        detach: this,
      );
    }
  }

  static final _finalizer = Finalizer(_destroy);

  final _i1.EtebaseIsolateReference _isolate;

  final _i4.Pointer<_i5.EtebaseInvitationListResponse> _pointer;

  final Object? _owner;

  /// Iterator for the list response
  ///
  /// @param this_ the object handle
  Future<String> getIterator() => _isolate.invoke<String>(
        #etebase_invitation_list_response_get_iterator,
        <dynamic>[_pointer.address],
      );

  /// List of invitations included in the response
  ///
  /// @param this_ the object handle
  /// @param[out] data the array to store the items in
  Future<List<EtebaseSignedInvitation>> getData() async {
    final addressList = await _isolate.invoke<List<int>>(
      #etebase_invitation_list_response_get_data,
      <dynamic>[_pointer.address],
    );
    return addressList
        .map((a) => EtebaseSignedInvitation._(
              _isolate,
              _i4.Pointer.fromAddress(a),
              this,
            ))
        .toList();
  }

  /// Indicates whether there is no more data to fetch
  ///
  /// @param this_ the object handle
  Future<bool> isDone() => _isolate.invoke<bool>(
        #etebase_invitation_list_response_is_done,
        <dynamic>[_pointer.address],
      );
  static Future<void> _destroy(
          _i3.DestroyReference<_i5.EtebaseInvitationListResponse> this_) =>
      this_.isolate.invoke<void>(
        #etebase_invitation_list_response_destroy,
        <dynamic>[this_.pointer.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    if (_owner == null) {
      _finalizer.detach(this);
      await _destroy(_i3.DestroyReference(
        _isolate,
        _pointer,
      ));
    }
  }
}

/// The dart binding of the EtebaseItemRevisionsListResponse rust class
class EtebaseItemRevisionsListResponse {
  EtebaseItemRevisionsListResponse._(
    this._isolate,
    this._pointer, [
    this._owner,
  ]) {
    if (_owner == null) {
      _finalizer.attach(
        this,
        _i3.DestroyReference(
          _isolate,
          _pointer,
        ),
        detach: this,
      );
    }
  }

  static final _finalizer = Finalizer(_destroy);

  final _i1.EtebaseIsolateReference _isolate;

  final _i4.Pointer<_i5.EtebaseItemRevisionsListResponse> _pointer;

  final Object? _owner;

  /// Iterator for the list response
  ///
  /// @param this_ the object handle
  Future<String> getIterator() => _isolate.invoke<String>(
        #etebase_item_revisions_list_response_get_iterator,
        <dynamic>[_pointer.address],
      );

  /// List of item revisions included in the response
  ///
  /// @param this_ the object handle
  /// @param[out] data the array to store the items in
  Future<List<EtebaseItem>> getData() async {
    final addressList = await _isolate.invoke<List<int>>(
      #etebase_item_revisions_list_response_get_data,
      <dynamic>[_pointer.address],
    );
    return addressList
        .map((a) => EtebaseItem._(
              _isolate,
              _i4.Pointer.fromAddress(a),
              this,
            ))
        .toList();
  }

  /// Indicates whether there is no more data to fetch
  ///
  /// @param this_ the object handle
  Future<bool> isDone() => _isolate.invoke<bool>(
        #etebase_item_revisions_list_response_is_done,
        <dynamic>[_pointer.address],
      );
  static Future<void> _destroy(
          _i3.DestroyReference<_i5.EtebaseItemRevisionsListResponse> this_) =>
      this_.isolate.invoke<void>(
        #etebase_item_revisions_list_response_destroy,
        <dynamic>[this_.pointer.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    if (_owner == null) {
      _finalizer.detach(this);
      await _destroy(_i3.DestroyReference(
        _isolate,
        _pointer,
      ));
    }
  }
}

/// The dart binding of the EtebaseMemberListResponse rust class
class EtebaseMemberListResponse {
  EtebaseMemberListResponse._(
    this._isolate,
    this._pointer, [
    this._owner,
  ]) {
    if (_owner == null) {
      _finalizer.attach(
        this,
        _i3.DestroyReference(
          _isolate,
          _pointer,
        ),
        detach: this,
      );
    }
  }

  static final _finalizer = Finalizer(_destroy);

  final _i1.EtebaseIsolateReference _isolate;

  final _i4.Pointer<_i5.EtebaseMemberListResponse> _pointer;

  final Object? _owner;

  /// Iterator for the list response
  ///
  /// @param this_ the object handle
  Future<String> getIterator() => _isolate.invoke<String>(
        #etebase_member_list_response_get_iterator,
        <dynamic>[_pointer.address],
      );

  /// List of collection members included in the response
  ///
  /// @param this_ the object handle
  /// @param[out] data the array to store the collection members in
  Future<List<EtebaseCollectionMember>> getData() async {
    final addressList = await _isolate.invoke<List<int>>(
      #etebase_member_list_response_get_data,
      <dynamic>[_pointer.address],
    );
    return addressList
        .map((a) => EtebaseCollectionMember._(
              _isolate,
              _i4.Pointer.fromAddress(a),
              this,
            ))
        .toList();
  }

  /// Indicates whether there is no more data to fetch
  ///
  /// @param this_ the object handle
  Future<bool> isDone() => _isolate.invoke<bool>(
        #etebase_member_list_response_is_done,
        <dynamic>[_pointer.address],
      );
  static Future<void> _destroy(
          _i3.DestroyReference<_i5.EtebaseMemberListResponse> this_) =>
      this_.isolate.invoke<void>(
        #etebase_member_list_response_destroy,
        <dynamic>[this_.pointer.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    if (_owner == null) {
      _finalizer.detach(this);
      await _destroy(_i3.DestroyReference(
        _isolate,
        _pointer,
      ));
    }
  }
}

/// The dart binding of the EtebaseItemManager rust class
class EtebaseItemManager {
  EtebaseItemManager._(
    this._isolate,
    this._pointer, [
    this._owner,
  ]) {
    if (_owner == null) {
      _finalizer.attach(
        this,
        _i3.DestroyReference(
          _isolate,
          _pointer,
        ),
        detach: this,
      );
    }
  }

  static final _finalizer = Finalizer(_destroy);

  final _i1.EtebaseIsolateReference _isolate;

  final _i4.Pointer<_i5.EtebaseItemManager> _pointer;

  final Object? _owner;

  /// Fetch a single item from the server using its UID
  ///
  /// @param this_ the object handle
  /// @param item_uid the UID of the item to be fetched
  /// @param fetch_options the `EtebaseFetchOptions` to fetch with
  Future<EtebaseItem> fetch(
    String itemUid, [
    EtebaseFetchOptions? fetchOptions,
  ]) async =>
      EtebaseItem._(
        _isolate,
        _i4.Pointer.fromAddress(await _isolate.invoke<int>(
          #etebase_item_manager_fetch,
          <dynamic>[
            _pointer.address,
            itemUid,
            fetchOptions,
          ],
        )),
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
    _i6.Uint8List content,
  ) async =>
      EtebaseItem._(
        _isolate,
        _i4.Pointer.fromAddress(await _isolate.invoke<int>(
          #etebase_item_manager_create,
          <dynamic>[
            _pointer.address,
            meta,
            _i7.TransferableTypedData.fromList([content]),
          ],
        )),
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
    _i6.Uint8List meta,
    _i6.Uint8List content,
  ) async =>
      EtebaseItem._(
        _isolate,
        _i4.Pointer.fromAddress(await _isolate.invoke<int>(
          #etebase_item_manager_create_raw,
          <dynamic>[
            _pointer.address,
            _i7.TransferableTypedData.fromList([meta]),
            _i7.TransferableTypedData.fromList([content]),
          ],
        )),
      );

  /// Fetch all items of a collection and return a list response
  ///
  /// @param this_ the object handle
  /// @param fetch_options the `EtebaseFetchOptions` to fetch with
  Future<EtebaseItemListResponse> list(
          [EtebaseFetchOptions? fetchOptions]) async =>
      EtebaseItemListResponse._(
        _isolate,
        _i4.Pointer.fromAddress(await _isolate.invoke<int>(
          #etebase_item_manager_list,
          <dynamic>[
            _pointer.address,
            fetchOptions,
          ],
        )),
      );

  /// Fetch and return a list response of items with each item as the revision
  ///
  /// @param this_ the object handle
  /// @param item the item for which to fetch the revision history
  /// @param fetch_options the `EtebaseFetchOptions` to fetch with
  Future<EtebaseItemRevisionsListResponse> itemRevisions(
    EtebaseItem item, [
    EtebaseFetchOptions? fetchOptions,
  ]) async =>
      EtebaseItemRevisionsListResponse._(
        _isolate,
        _i4.Pointer.fromAddress(await _isolate.invoke<int>(
          #etebase_item_manager_item_revisions,
          <dynamic>[
            _pointer.address,
            item._pointer.address,
            fetchOptions,
          ],
        )),
      );

  /// Fetch the latest revision of the supplied items from the server and return a list response
  ///
  /// @param this_ the object handle
  /// @param items the list of items to be fetched
  /// @param items_size the number of items
  /// @param fetch_options the `EtebaseFetchOptions` to fetch with
  Future<EtebaseItemListResponse> fetchUpdates(
    List<EtebaseItem> items, [
    EtebaseFetchOptions? fetchOptions,
  ]) async =>
      EtebaseItemListResponse._(
        _isolate,
        _i4.Pointer.fromAddress(await _isolate.invoke<int>(
          #etebase_item_manager_fetch_updates,
          <dynamic>[
            _pointer.address,
            items.map((e) => e._pointer.address).toList(),
            fetchOptions,
          ],
        )),
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
    List<String> items, [
    EtebaseFetchOptions? fetchOptions,
  ]) async =>
      EtebaseItemListResponse._(
        _isolate,
        _i4.Pointer.fromAddress(await _isolate.invoke<int>(
          #etebase_item_manager_fetch_multi,
          <dynamic>[
            _pointer.address,
            items,
            fetchOptions,
          ],
        )),
      );

  /// Upload the supplied items to the server
  ///
  /// @param this_ the object handle
  /// @param items the list of items to be uploaded
  /// @param items_size the number of items
  /// @param fetch_options the `EtebaseFetchOptions` to upload with
  Future<void> batch(
    List<EtebaseItem> items, [
    EtebaseFetchOptions? fetchOptions,
  ]) =>
      _isolate.invoke<void>(
        #etebase_item_manager_batch,
        <dynamic>[
          _pointer.address,
          items.map((e) => e._pointer.address).toList(),
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
    List<EtebaseItem> deps, [
    EtebaseFetchOptions? fetchOptions,
  ]) =>
      _isolate.invoke<void>(
        #etebase_item_manager_batch_deps,
        <dynamic>[
          _pointer.address,
          items.map((e) => e._pointer.address).toList(),
          deps.map((e) => e._pointer.address).toList(),
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
    List<EtebaseItem> items, [
    EtebaseFetchOptions? fetchOptions,
  ]) =>
      _isolate.invoke<void>(
        #etebase_item_manager_transaction,
        <dynamic>[
          _pointer.address,
          items.map((e) => e._pointer.address).toList(),
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
    List<EtebaseItem> deps, [
    EtebaseFetchOptions? fetchOptions,
  ]) =>
      _isolate.invoke<void>(
        #etebase_item_manager_transaction_deps,
        <dynamic>[
          _pointer.address,
          items.map((e) => e._pointer.address).toList(),
          deps.map((e) => e._pointer.address).toList(),
          fetchOptions,
        ],
      );

  /// Load and return a cached item from a byte buffer
  ///
  /// @param this_ the object handle
  /// @param cached the byte buffer holding the cached item obtained using [cache_save]
  /// @param cached_size size of the buffer
  Future<EtebaseItem> cacheLoad(_i6.Uint8List cached) async => EtebaseItem._(
        _isolate,
        _i4.Pointer.fromAddress(await _isolate.invoke<int>(
          #etebase_item_manager_cache_load,
          <dynamic>[
            _pointer.address,
            _i7.TransferableTypedData.fromList([cached]),
          ],
        )),
      );

  /// Save the item object to a byte buffer for caching
  ///
  /// The item can later be loaded using `etebase_item_manager_cache_load`
  ///
  /// @param this_ the object handle
  /// @param item the item object to be cached
  /// @param[out] ret_size to hold the size of the returned buffer
  Future<_i6.Uint8List> cacheSave(EtebaseItem item) async {
    final data = await _isolate.invoke<_i7.TransferableTypedData>(
      #etebase_item_manager_cache_save,
      <dynamic>[
        _pointer.address,
        item._pointer.address,
      ],
    );
    return data.materialize().asUint8List();
  }

  /// Save the item object and its content to a byte buffer for caching
  ///
  /// The item can later be loaded using `etebase_item_manager_cache_load`
  ///
  /// @param this_ the object handle
  /// @param item the item object to be cached
  /// @param[out] ret_size to hold the size of the returned buffer
  Future<_i6.Uint8List> cacheSaveWithContent(EtebaseItem item) async {
    final data = await _isolate.invoke<_i7.TransferableTypedData>(
      #etebase_item_manager_cache_save_with_content,
      <dynamic>[
        _pointer.address,
        item._pointer.address,
      ],
    );
    return data.materialize().asUint8List();
  }

  static Future<void> _destroy(
          _i3.DestroyReference<_i5.EtebaseItemManager> this_) =>
      this_.isolate.invoke<void>(
        #etebase_item_manager_destroy,
        <dynamic>[this_.pointer.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    if (_owner == null) {
      _finalizer.detach(this);
      await _destroy(_i3.DestroyReference(
        _isolate,
        _pointer,
      ));
    }
  }
}

/// The dart binding of the EtebaseItemListResponse rust class
class EtebaseItemListResponse {
  EtebaseItemListResponse._(
    this._isolate,
    this._pointer, [
    this._owner,
  ]) {
    if (_owner == null) {
      _finalizer.attach(
        this,
        _i3.DestroyReference(
          _isolate,
          _pointer,
        ),
        detach: this,
      );
    }
  }

  static final _finalizer = Finalizer(_destroy);

  final _i1.EtebaseIsolateReference _isolate;

  final _i4.Pointer<_i5.EtebaseItemListResponse> _pointer;

  final Object? _owner;

  /// Sync token for the list response
  ///
  /// @param this_ the object handle
  Future<String> getStoken() => _isolate.invoke<String>(
        #etebase_item_list_response_get_stoken,
        <dynamic>[_pointer.address],
      );

  /// List of items included in the response
  ///
  /// @param this_ the object handle
  /// @param[out] data the array to store the items in
  Future<List<EtebaseItem>> getData() async {
    final addressList = await _isolate.invoke<List<int>>(
      #etebase_item_list_response_get_data,
      <dynamic>[_pointer.address],
    );
    return addressList
        .map((a) => EtebaseItem._(
              _isolate,
              _i4.Pointer.fromAddress(a),
              this,
            ))
        .toList();
  }

  /// Indicates whether there are no more items to fetch
  ///
  /// @param this_ the object handle
  Future<bool> isDone() => _isolate.invoke<bool>(
        #etebase_item_list_response_is_done,
        <dynamic>[_pointer.address],
      );
  static Future<void> _destroy(
          _i3.DestroyReference<_i5.EtebaseItemListResponse> this_) =>
      this_.isolate.invoke<void>(
        #etebase_item_list_response_destroy,
        <dynamic>[this_.pointer.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    if (_owner == null) {
      _finalizer.detach(this);
      await _destroy(_i3.DestroyReference(
        _isolate,
        _pointer,
      ));
    }
  }
}

/// The dart binding of the EtebaseItem rust class
class EtebaseItem {
  EtebaseItem._(
    this._isolate,
    this._pointer, [
    this._owner,
  ]) {
    if (_owner == null) {
      _finalizer.attach(
        this,
        _i3.DestroyReference(
          _isolate,
          _pointer,
        ),
        detach: this,
      );
    }
  }

  static final _finalizer = Finalizer(_destroy);

  final _i1.EtebaseIsolateReference _isolate;

  final _i4.Pointer<_i5.EtebaseItem> _pointer;

  final Object? _owner;

  /// Clone an item object
  ///
  /// @param this_ the object handle
  Future<EtebaseItem> clone() async => EtebaseItem._(
        _isolate,
        _i4.Pointer.fromAddress(await _isolate.invoke<int>(
          #etebase_item_clone,
          <dynamic>[_pointer.address],
        )),
      );

  /// Manually verify the integrity of the item
  ///
  /// This is also done automatically by the API
  ///
  /// @param this_ the object handle
  Future<bool> verify() => _isolate.invoke<bool>(
        #etebase_item_verify,
        <dynamic>[_pointer.address],
      );

  /// Set metadata for the item object
  ///
  /// @param this_ the object handle
  /// @param meta the metadata object to be set for the item
  Future<void> setMeta(EtebaseItemMetadata meta) => _isolate.invoke<void>(
        #etebase_item_set_meta,
        <dynamic>[
          _pointer.address,
          meta,
        ],
      );

  /// Return the metadata of the item
  ///
  /// @param this_ the object handle
  Future<EtebaseItemMetadata> getMeta() => _isolate.invoke<EtebaseItemMetadata>(
        #etebase_item_get_meta,
        <dynamic>[_pointer.address],
      );

  /// Set metadata for the item object from a byte array
  ///
  /// @param this_ the object handle
  /// @param meta the metadata for the item. This needs to be a valid `EtebaseItemMetadata`-like struct encoded using `msgpack`.
  /// @param meta_size the metadata size
  Future<void> setMetaRaw(_i6.Uint8List meta) => _isolate.invoke<void>(
        #etebase_item_set_meta_raw,
        <dynamic>[
          _pointer.address,
          _i7.TransferableTypedData.fromList([meta]),
        ],
      );

  /// Write the metadata of the item to a byte array and return its length
  ///
  /// @param this_ the object handle
  /// @param[out] buf the output byte buffer
  /// @param buf_size the maximum number of bytes to be written to buf
  Future<_i6.Uint8List> getMetaRaw([int? sizeHint]) async {
    final data = await _isolate.invoke<_i7.TransferableTypedData>(
      #etebase_item_get_meta_raw,
      <dynamic>[
        _pointer.address,
        sizeHint,
      ],
    );
    return data.materialize().asUint8List();
  }

  /// Set the content of the item
  ///
  /// @param this_ the object handle
  /// @param content the content of the item as a byte array
  /// @param content_size the content size
  Future<void> setContent(_i6.Uint8List content) => _isolate.invoke<void>(
        #etebase_item_set_content,
        <dynamic>[
          _pointer.address,
          _i7.TransferableTypedData.fromList([content]),
        ],
      );

  /// Write the content of the item to a byte array and return its length
  ///
  /// @param this_ the object handle
  /// @param[out] buf the output byte buffer
  /// @param buf_size the maximum number of bytes to be written to buf
  Future<_i6.Uint8List> getContent([int? sizeHint]) async {
    final data = await _isolate.invoke<_i7.TransferableTypedData>(
      #etebase_item_get_content,
      <dynamic>[
        _pointer.address,
        sizeHint,
      ],
    );
    return data.materialize().asUint8List();
  }

  /// Mark the item as deleted
  ///
  /// The item needs to be \ref uploaded `etebase_item_manager_batch` for this to take effect
  ///
  /// @param this_ the object handle
  Future<void> delete() => _isolate.invoke<void>(
        #etebase_item_delete,
        <dynamic>[_pointer.address],
      );

  /// Check whether the item is marked as deleted
  ///
  /// @param this_ the object handle
  Future<bool> isDeleted() => _isolate.invoke<bool>(
        #etebase_item_is_deleted,
        <dynamic>[_pointer.address],
      );

  /// The UID of the item
  ///
  /// @param this_ the object handle
  Future<String> getUid() => _isolate.invoke<String>(
        #etebase_item_get_uid,
        <dynamic>[_pointer.address],
      );

  /// The etag of the item
  ///
  /// @param this_ the object handle
  Future<String> getEtag() => _isolate.invoke<String>(
        #etebase_item_get_etag,
        <dynamic>[_pointer.address],
      );
  static Future<void> _destroy(_i3.DestroyReference<_i5.EtebaseItem> this_) =>
      this_.isolate.invoke<void>(
        #etebase_item_destroy,
        <dynamic>[this_.pointer.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    if (_owner == null) {
      _finalizer.detach(this);
      await _destroy(_i3.DestroyReference(
        _isolate,
        _pointer,
      ));
    }
  }
}

/// The dart binding of the EtebaseFileSystemCache rust class
class EtebaseFileSystemCache {
  EtebaseFileSystemCache._(
    this._isolate,
    this._pointer, [
    this._owner,
  ]) {
    if (_owner == null) {
      _finalizer.attach(
        this,
        _i3.DestroyReference(
          _isolate,
          _pointer,
        ),
        detach: this,
      );
    }
  }

  static final _finalizer = Finalizer(_destroy);

  final _i1.EtebaseIsolateReference _isolate;

  final _i4.Pointer<_i5.EtebaseFileSystemCache> _pointer;

  final Object? _owner;

  /// Initialize a file system cache object
  ///
  /// Should be destroyed with `etebase_fs_cache_destroy`
  ///
  /// @param path the path to a directory to store cache in
  /// @param username username of the user to cache data for
  static Future<EtebaseFileSystemCache> create(
    EtebaseClient client,
    String path,
    String username,
  ) async =>
      EtebaseFileSystemCache._(
        client._isolate,
        _i4.Pointer.fromAddress(await client._isolate.invoke<int>(
          #etebase_fs_cache_new,
          <dynamic>[
            path,
            username,
          ],
        )),
      );

  /// Clear all cache for the user
  ///
  /// @param this_ the object handle
  Future<void> clearUser() => _isolate.invoke<void>(
        #etebase_fs_cache_clear_user,
        <dynamic>[_pointer.address],
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
    EtebaseAccount etebase, [
    _i6.Uint8List? encryptionKey,
  ]) =>
      _isolate.invoke<void>(
        #etebase_fs_cache_save_account,
        <dynamic>[
          _pointer.address,
          etebase._pointer.address,
          encryptionKey == null
              ? null
              : _i7.TransferableTypedData.fromList([encryptionKey]),
        ],
      );

  /// Load the account object from cache
  ///
  /// @param this_ the object handle
  /// @param client the already setup [Client] object
  /// @param encryption_key the same encryption key passed to [Self::save_account] while saving the account
  /// @param encryption_key_size the size of the encryption_key
  Future<EtebaseAccount> loadAccount(
    EtebaseClient client, [
    _i6.Uint8List? encryptionKey,
  ]) async =>
      EtebaseAccount._(
        _isolate,
        _i4.Pointer.fromAddress(await _isolate.invoke<int>(
          #etebase_fs_cache_load_account,
          <dynamic>[
            _pointer.address,
            client._pointer.address,
            encryptionKey == null
                ? null
                : _i7.TransferableTypedData.fromList([encryptionKey]),
          ],
        )),
      );

  /// Save the collection list sync token
  ///
  /// @param this_ the object handle
  /// @param stoken the sync token to be saved
  Future<void> saveStoken(String stoken) => _isolate.invoke<void>(
        #etebase_fs_cache_save_stoken,
        <dynamic>[
          _pointer.address,
          stoken,
        ],
      );

  /// Load the collection list sync token from cache
  ///
  /// @param this_ the object handle
  Future<String?> loadStoken() => _isolate.invoke<String?>(
        #etebase_fs_cache_load_stoken,
        <dynamic>[_pointer.address],
      );

  /// Save a collection's sync token
  ///
  /// @param this_ the object handle
  /// @param col_uid the UID of the collection
  /// @param stoken the sync token to be saved
  Future<void> collectionSaveStoken(
    String colUid,
    String stoken,
  ) =>
      _isolate.invoke<void>(
        #etebase_fs_cache_collection_save_stoken,
        <dynamic>[
          _pointer.address,
          colUid,
          stoken,
        ],
      );

  /// Load the sync token for a collection
  ///
  /// @param this_ the object handle
  /// @param col_uid the UID of the collection
  Future<String?> collectionLoadStoken(String colUid) =>
      _isolate.invoke<String?>(
        #etebase_fs_cache_collection_load_stoken,
        <dynamic>[
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
  ) =>
      _isolate.invoke<void>(
        #etebase_fs_cache_collection_set,
        <dynamic>[
          _pointer.address,
          colMgr._pointer.address,
          col._pointer.address,
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
  ) =>
      _isolate.invoke<void>(
        #etebase_fs_cache_collection_unset,
        <dynamic>[
          _pointer.address,
          colMgr._pointer.address,
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
      EtebaseCollection._(
        _isolate,
        _i4.Pointer.fromAddress(await _isolate.invoke<int>(
          #etebase_fs_cache_collection_get,
          <dynamic>[
            _pointer.address,
            colMgr._pointer.address,
            colUid,
          ],
        )),
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
  ) =>
      _isolate.invoke<void>(
        #etebase_fs_cache_item_set,
        <dynamic>[
          _pointer.address,
          itemMgr._pointer.address,
          colUid,
          item._pointer.address,
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
  ) =>
      _isolate.invoke<void>(
        #etebase_fs_cache_item_unset,
        <dynamic>[
          _pointer.address,
          itemMgr._pointer.address,
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
      EtebaseItem._(
        _isolate,
        _i4.Pointer.fromAddress(await _isolate.invoke<int>(
          #etebase_fs_cache_item_get,
          <dynamic>[
            _pointer.address,
            itemMgr._pointer.address,
            colUid,
            itemUid,
          ],
        )),
      );
  static Future<void> _destroy(
          _i3.DestroyReference<_i5.EtebaseFileSystemCache> this_) =>
      this_.isolate.invoke<void>(
        #etebase_fs_cache_destroy,
        <dynamic>[this_.pointer.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    if (_owner == null) {
      _finalizer.detach(this);
      await _destroy(_i3.DestroyReference(
        _isolate,
        _pointer,
      ));
    }
  }
}

/// The dart binding of the EtebaseCollectionMemberManager rust class
class EtebaseCollectionMemberManager {
  EtebaseCollectionMemberManager._(
    this._isolate,
    this._pointer, [
    this._owner,
  ]) {
    if (_owner == null) {
      _finalizer.attach(
        this,
        _i3.DestroyReference(
          _isolate,
          _pointer,
        ),
        detach: this,
      );
    }
  }

  static final _finalizer = Finalizer(_destroy);

  final _i1.EtebaseIsolateReference _isolate;

  final _i4.Pointer<_i5.EtebaseCollectionMemberManager> _pointer;

  final Object? _owner;

  /// List the members of a collection
  ///
  /// @param this_ the object handle
  /// @param fetch_options the `EtebaseFetchOptions` to fetch with
  Future<EtebaseMemberListResponse> list(
          [EtebaseFetchOptions? fetchOptions]) async =>
      EtebaseMemberListResponse._(
        _isolate,
        _i4.Pointer.fromAddress(await _isolate.invoke<int>(
          #etebase_collection_member_manager_list,
          <dynamic>[
            _pointer.address,
            fetchOptions,
          ],
        )),
      );

  /// Remove a member from the collection
  ///
  /// @param this_ the object handle
  /// @param username the member's username
  Future<void> remove(String username) => _isolate.invoke<void>(
        #etebase_collection_member_manager_remove,
        <dynamic>[
          _pointer.address,
          username,
        ],
      );

  /// Leave a collection the user is a member of
  ///
  /// @param this_ the object handle
  Future<void> leave() => _isolate.invoke<void>(
        #etebase_collection_member_manager_leave,
        <dynamic>[_pointer.address],
      );

  /// Modify the access level of a member
  ///
  /// @param this_ the object handle
  /// @param username the member's username
  /// @param access_level the new `EtebaseCollectionAccessLevel`
  Future<void> modifyAccessLevel(
    String username,
    _i8.EtebaseCollectionAccessLevel accessLevel,
  ) =>
      _isolate.invoke<void>(
        #etebase_collection_member_manager_modify_access_level,
        <dynamic>[
          _pointer.address,
          username,
          accessLevel,
        ],
      );
  static Future<void> _destroy(
          _i3.DestroyReference<_i5.EtebaseCollectionMemberManager> this_) =>
      this_.isolate.invoke<void>(
        #etebase_collection_member_manager_destroy,
        <dynamic>[this_.pointer.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    if (_owner == null) {
      _finalizer.detach(this);
      await _destroy(_i3.DestroyReference(
        _isolate,
        _pointer,
      ));
    }
  }
}

/// The dart binding of the EtebaseCollectionMember rust class
class EtebaseCollectionMember {
  EtebaseCollectionMember._(
    this._isolate,
    this._pointer, [
    this._owner,
  ]) {
    if (_owner == null) {
      _finalizer.attach(
        this,
        _i3.DestroyReference(
          _isolate,
          _pointer,
        ),
        detach: this,
      );
    }
  }

  static final _finalizer = Finalizer(_destroy);

  final _i1.EtebaseIsolateReference _isolate;

  final _i4.Pointer<_i5.EtebaseCollectionMember> _pointer;

  final Object? _owner;

  /// Clone the object
  ///
  /// @param this_ the object handle
  Future<EtebaseCollectionMember> clone() async => EtebaseCollectionMember._(
        _isolate,
        _i4.Pointer.fromAddress(await _isolate.invoke<int>(
          #etebase_collection_member_clone,
          <dynamic>[_pointer.address],
        )),
      );

  /// The username of a member
  ///
  /// @param this_ the object handle
  Future<String> getUsername() => _isolate.invoke<String>(
        #etebase_collection_member_get_username,
        <dynamic>[_pointer.address],
      );

  /// The access_level of the member
  ///
  /// @param this_ the object handle
  Future<_i8.EtebaseCollectionAccessLevel> getAccessLevel() =>
      _isolate.invoke<_i8.EtebaseCollectionAccessLevel>(
        #etebase_collection_member_get_access_level,
        <dynamic>[_pointer.address],
      );
  static Future<void> _destroy(
          _i3.DestroyReference<_i5.EtebaseCollectionMember> this_) =>
      this_.isolate.invoke<void>(
        #etebase_collection_member_destroy,
        <dynamic>[this_.pointer.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    if (_owner == null) {
      _finalizer.detach(this);
      await _destroy(_i3.DestroyReference(
        _isolate,
        _pointer,
      ));
    }
  }
}

/// The dart binding of the EtebaseCollectionManager rust class
class EtebaseCollectionManager {
  EtebaseCollectionManager._(
    this._isolate,
    this._pointer, [
    this._owner,
  ]) {
    if (_owner == null) {
      _finalizer.attach(
        this,
        _i3.DestroyReference(
          _isolate,
          _pointer,
        ),
        detach: this,
      );
    }
  }

  static final _finalizer = Finalizer(_destroy);

  final _i1.EtebaseIsolateReference _isolate;

  final _i4.Pointer<_i5.EtebaseCollectionManager> _pointer;

  final Object? _owner;

  /// Fetch a single collection from the server using its UID
  ///
  /// @param this_ the object handle
  /// @param col_uid the UID of the collection to be fetched
  /// @param fetch_options the `EtebaseFetchOptions` to fetch with
  Future<EtebaseCollection> fetch(
    String colUid, [
    EtebaseFetchOptions? fetchOptions,
  ]) async =>
      EtebaseCollection._(
        _isolate,
        _i4.Pointer.fromAddress(await _isolate.invoke<int>(
          #etebase_collection_manager_fetch,
          <dynamic>[
            _pointer.address,
            colUid,
            fetchOptions,
          ],
        )),
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
    _i6.Uint8List content,
  ) async =>
      EtebaseCollection._(
        _isolate,
        _i4.Pointer.fromAddress(await _isolate.invoke<int>(
          #etebase_collection_manager_create,
          <dynamic>[
            _pointer.address,
            collectionType,
            meta,
            _i7.TransferableTypedData.fromList([content]),
          ],
        )),
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
    _i6.Uint8List meta,
    _i6.Uint8List content,
  ) async =>
      EtebaseCollection._(
        _isolate,
        _i4.Pointer.fromAddress(await _isolate.invoke<int>(
          #etebase_collection_manager_create_raw,
          <dynamic>[
            _pointer.address,
            collectionType,
            _i7.TransferableTypedData.fromList([meta]),
            _i7.TransferableTypedData.fromList([content]),
          ],
        )),
      );

  /// Return the item manager for the supplied collection
  ///
  /// @param this_ the object handle
  /// @param col the collection for which the item manager is required
  Future<EtebaseItemManager> getItemManager(EtebaseCollection col) async =>
      EtebaseItemManager._(
        _isolate,
        _i4.Pointer.fromAddress(await _isolate.invoke<int>(
          #etebase_collection_manager_get_item_manager,
          <dynamic>[
            _pointer.address,
            col._pointer.address,
          ],
        )),
      );

  /// Fetch all collections of a specific type from the server and return a list response
  ///
  /// @param this_ the object handle
  /// @param collection_type the type of items stored in the collection
  /// @param fetch_options the `EtebaseFetchOptions` to fetch with
  Future<EtebaseCollectionListResponse> list(
    String collectionType, [
    EtebaseFetchOptions? fetchOptions,
  ]) async =>
      EtebaseCollectionListResponse._(
        _isolate,
        _i4.Pointer.fromAddress(await _isolate.invoke<int>(
          #etebase_collection_manager_list,
          <dynamic>[
            _pointer.address,
            collectionType,
            fetchOptions,
          ],
        )),
      );

  /// Fetch all collections of the supplied types from the server and return a list response
  ///
  /// @param this_ the object handle
  /// @param collection_types array of strings denoting the collection types
  /// @param collection_types_size size of the collection_types array
  /// @param fetch_options the `EtebaseFetchOptions` to fetch with
  Future<EtebaseCollectionListResponse> listMulti(
    List<String> collectionTypes, [
    EtebaseFetchOptions? fetchOptions,
  ]) async =>
      EtebaseCollectionListResponse._(
        _isolate,
        _i4.Pointer.fromAddress(await _isolate.invoke<int>(
          #etebase_collection_manager_list_multi,
          <dynamic>[
            _pointer.address,
            collectionTypes,
            fetchOptions,
          ],
        )),
      );

  /// Upload a collection
  ///
  /// @param this_ the object handle
  /// @param collection the collection object to be uploaded
  /// @param fetch_options the `EtebaseFetchOptions` to upload with
  Future<void> upload(
    EtebaseCollection collection, [
    EtebaseFetchOptions? fetchOptions,
  ]) =>
      _isolate.invoke<void>(
        #etebase_collection_manager_upload,
        <dynamic>[
          _pointer.address,
          collection._pointer.address,
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
    EtebaseCollection collection, [
    EtebaseFetchOptions? fetchOptions,
  ]) =>
      _isolate.invoke<void>(
        #etebase_collection_manager_transaction,
        <dynamic>[
          _pointer.address,
          collection._pointer.address,
          fetchOptions,
        ],
      );

  /// Load and return a cached collection object from a byte buffer
  ///
  /// @param this_ the object handle
  /// @param cached the byte buffer holding the cached collection obtained using [cache_save]
  /// @param cached_size size of the buffer
  Future<EtebaseCollection> cacheLoad(_i6.Uint8List cached) async =>
      EtebaseCollection._(
        _isolate,
        _i4.Pointer.fromAddress(await _isolate.invoke<int>(
          #etebase_collection_manager_cache_load,
          <dynamic>[
            _pointer.address,
            _i7.TransferableTypedData.fromList([cached]),
          ],
        )),
      );

  /// Save the collection object to a byte buffer for caching
  ///
  /// The collection can later be loaded using `etebase_collection_manager_cache_load`
  ///
  /// @param this_ the object handle
  /// @param collection the collection object to be cached
  /// @param[out] ret_size to hold the size of the returned buffer
  Future<_i6.Uint8List> cacheSave(EtebaseCollection collection) async {
    final data = await _isolate.invoke<_i7.TransferableTypedData>(
      #etebase_collection_manager_cache_save,
      <dynamic>[
        _pointer.address,
        collection._pointer.address,
      ],
    );
    return data.materialize().asUint8List();
  }

  /// Save the collection object and its content to a byte buffer for caching
  ///
  /// The collection can later be loaded using `etebase_collection_manager_cache_load`
  ///
  /// @param this_ the object handle
  /// @param collection the collection object to be cached
  /// @param[out] ret_size to hold the size of the returned buffer
  Future<_i6.Uint8List> cacheSaveWithContent(
      EtebaseCollection collection) async {
    final data = await _isolate.invoke<_i7.TransferableTypedData>(
      #etebase_collection_manager_cache_save_with_content,
      <dynamic>[
        _pointer.address,
        collection._pointer.address,
      ],
    );
    return data.materialize().asUint8List();
  }

  /// Return the collection member manager for the supplied collection
  ///
  /// @param this_ the object handle
  /// @param col the collection for which the manager is required
  Future<EtebaseCollectionMemberManager> getMemberManager(
          EtebaseCollection col) async =>
      EtebaseCollectionMemberManager._(
        _isolate,
        _i4.Pointer.fromAddress(await _isolate.invoke<int>(
          #etebase_collection_manager_get_member_manager,
          <dynamic>[
            _pointer.address,
            col._pointer.address,
          ],
        )),
      );
  static Future<void> _destroy(
          _i3.DestroyReference<_i5.EtebaseCollectionManager> this_) =>
      this_.isolate.invoke<void>(
        #etebase_collection_manager_destroy,
        <dynamic>[this_.pointer.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    if (_owner == null) {
      _finalizer.detach(this);
      await _destroy(_i3.DestroyReference(
        _isolate,
        _pointer,
      ));
    }
  }
}

/// The dart binding of the EtebaseCollectionListResponse rust class
class EtebaseCollectionListResponse {
  EtebaseCollectionListResponse._(
    this._isolate,
    this._pointer, [
    this._owner,
  ]) {
    if (_owner == null) {
      _finalizer.attach(
        this,
        _i3.DestroyReference(
          _isolate,
          _pointer,
        ),
        detach: this,
      );
    }
  }

  static final _finalizer = Finalizer(_destroy);

  final _i1.EtebaseIsolateReference _isolate;

  final _i4.Pointer<_i5.EtebaseCollectionListResponse> _pointer;

  final Object? _owner;

  /// Sync token for the list response
  ///
  /// @param this_ the object handle
  Future<String?> getStoken() => _isolate.invoke<String?>(
        #etebase_collection_list_response_get_stoken,
        <dynamic>[_pointer.address],
      );

  /// List of collections included in the response
  ///
  /// @param this_ the object handle
  /// @param[out] data the array to store the collections in
  Future<List<EtebaseCollection>> getData() async {
    final addressList = await _isolate.invoke<List<int>>(
      #etebase_collection_list_response_get_data,
      <dynamic>[_pointer.address],
    );
    return addressList
        .map((a) => EtebaseCollection._(
              _isolate,
              _i4.Pointer.fromAddress(a),
              this,
            ))
        .toList();
  }

  /// Indicates whether there are no more collections to fetch
  ///
  /// @param this_ the object handle
  Future<bool> isDone() => _isolate.invoke<bool>(
        #etebase_collection_list_response_is_done,
        <dynamic>[_pointer.address],
      );

  /// The list of collections to which the user lost access
  ///
  /// @param this_ the object handle
  /// @param[out] data the array to store the collections in
  Future<List<EtebaseRemovedCollection>> getRemovedMemberships() async {
    final addressList = await _isolate.invoke<List<int>>(
      #etebase_collection_list_response_get_removed_memberships,
      <dynamic>[_pointer.address],
    );
    return addressList
        .map((a) => EtebaseRemovedCollection._(
              _isolate,
              _i4.Pointer.fromAddress(a),
              this,
            ))
        .toList();
  }

  static Future<void> _destroy(
          _i3.DestroyReference<_i5.EtebaseCollectionListResponse> this_) =>
      this_.isolate.invoke<void>(
        #etebase_collection_list_response_destroy,
        <dynamic>[this_.pointer.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    if (_owner == null) {
      _finalizer.detach(this);
      await _destroy(_i3.DestroyReference(
        _isolate,
        _pointer,
      ));
    }
  }
}

/// The dart binding of the EtebaseCollectionInvitationManager rust class
class EtebaseCollectionInvitationManager {
  EtebaseCollectionInvitationManager._(
    this._isolate,
    this._pointer, [
    this._owner,
  ]) {
    if (_owner == null) {
      _finalizer.attach(
        this,
        _i3.DestroyReference(
          _isolate,
          _pointer,
        ),
        detach: this,
      );
    }
  }

  static final _finalizer = Finalizer(_destroy);

  final _i1.EtebaseIsolateReference _isolate;

  final _i4.Pointer<_i5.EtebaseCollectionInvitationManager> _pointer;

  final Object? _owner;

  /// List the incoming collection invitations for the account
  ///
  /// @param this_ the object handle
  /// @param fetch_options the `EtebaseFetchOptions` to fetch with
  Future<EtebaseInvitationListResponse> listIncoming(
          [EtebaseFetchOptions? fetchOptions]) async =>
      EtebaseInvitationListResponse._(
        _isolate,
        _i4.Pointer.fromAddress(await _isolate.invoke<int>(
          #etebase_invitation_manager_list_incoming,
          <dynamic>[
            _pointer.address,
            fetchOptions,
          ],
        )),
      );

  /// List the outgoing collection invitations for the account
  ///
  /// @param this_ the object handle
  /// @param fetch_options the `EtebaseFetchOptions` to fetch with
  Future<EtebaseInvitationListResponse> listOutgoing(
          [EtebaseFetchOptions? fetchOptions]) async =>
      EtebaseInvitationListResponse._(
        _isolate,
        _i4.Pointer.fromAddress(await _isolate.invoke<int>(
          #etebase_invitation_manager_list_outgoing,
          <dynamic>[
            _pointer.address,
            fetchOptions,
          ],
        )),
      );

  /// Accept an invitation
  ///
  /// @param this_ the object handle
  /// @param invitation the invitation to accept
  Future<void> accept(EtebaseSignedInvitation invitation) =>
      _isolate.invoke<void>(
        #etebase_invitation_manager_accept,
        <dynamic>[
          _pointer.address,
          invitation._pointer.address,
        ],
      );

  /// Reject an invitation
  ///
  /// @param this_ the object handle
  /// @param invitation the invitation to reject
  Future<void> reject(EtebaseSignedInvitation invitation) =>
      _isolate.invoke<void>(
        #etebase_invitation_manager_reject,
        <dynamic>[
          _pointer.address,
          invitation._pointer.address,
        ],
      );

  /// Fetch and return a user's profile
  ///
  /// @param this_ the object handle
  /// @param username the username of the user to fetch
  Future<EtebaseUserProfile> fetchUserProfile(String username) async =>
      EtebaseUserProfile._(
        _isolate,
        _i4.Pointer.fromAddress(await _isolate.invoke<int>(
          #etebase_invitation_manager_fetch_user_profile,
          <dynamic>[
            _pointer.address,
            username,
          ],
        )),
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
    _i6.Uint8List pubkey,
    _i8.EtebaseCollectionAccessLevel accessLevel,
  ) =>
      _isolate.invoke<void>(
        #etebase_invitation_manager_invite,
        <dynamic>[
          _pointer.address,
          collection._pointer.address,
          username,
          _i7.TransferableTypedData.fromList([pubkey]),
          accessLevel,
        ],
      );

  /// Cancel an invitation (disinvite)
  ///
  /// @param this_ the object handle
  /// @param invitation the invitation to cancel
  Future<void> disinvite(EtebaseSignedInvitation invitation) =>
      _isolate.invoke<void>(
        #etebase_invitation_manager_disinvite,
        <dynamic>[
          _pointer.address,
          invitation._pointer.address,
        ],
      );

  /// Our identity's public key
  ///
  /// This is the key users see when we send invitations.
  /// Can be pretty printed with `etebase_utils_pretty_fingerprint`.
  ///
  /// @param this_ the object handle
  Future<_i6.Uint8List> getPubkey() async {
    final data = await _isolate.invoke<_i7.TransferableTypedData>(
      #etebase_invitation_manager_get_pubkey,
      <dynamic>[_pointer.address],
    );
    return data.materialize().asUint8List();
  }

  static Future<void> _destroy(
          _i3.DestroyReference<_i5.EtebaseCollectionInvitationManager> this_) =>
      this_.isolate.invoke<void>(
        #etebase_invitation_manager_destroy,
        <dynamic>[this_.pointer.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    if (_owner == null) {
      _finalizer.detach(this);
      await _destroy(_i3.DestroyReference(
        _isolate,
        _pointer,
      ));
    }
  }
}

/// The dart binding of the EtebaseCollection rust class
class EtebaseCollection {
  EtebaseCollection._(
    this._isolate,
    this._pointer, [
    this._owner,
  ]) {
    if (_owner == null) {
      _finalizer.attach(
        this,
        _i3.DestroyReference(
          _isolate,
          _pointer,
        ),
        detach: this,
      );
    }
  }

  static final _finalizer = Finalizer(_destroy);

  final _i1.EtebaseIsolateReference _isolate;

  final _i4.Pointer<_i5.EtebaseCollection> _pointer;

  final Object? _owner;

  /// Clone a collection object
  ///
  /// @param this_ the object handle
  Future<EtebaseCollection> clone() async => EtebaseCollection._(
        _isolate,
        _i4.Pointer.fromAddress(await _isolate.invoke<int>(
          #etebase_collection_clone,
          <dynamic>[_pointer.address],
        )),
      );

  /// Manually verify the integrity of the collection
  ///
  /// This is also done automatically by the API
  ///
  /// @param this_ the object handle
  Future<bool> verify() => _isolate.invoke<bool>(
        #etebase_collection_verify,
        <dynamic>[_pointer.address],
      );

  /// Set metadata for the collection object
  ///
  /// @param this_ the object handle
  /// @param meta the metadata object to be set for the collection
  Future<void> setMeta(EtebaseItemMetadata meta) => _isolate.invoke<void>(
        #etebase_collection_set_meta,
        <dynamic>[
          _pointer.address,
          meta,
        ],
      );

  /// Return the metadata of the collection
  ///
  /// @param this_ the object handle
  Future<EtebaseItemMetadata> getMeta() => _isolate.invoke<EtebaseItemMetadata>(
        #etebase_collection_get_meta,
        <dynamic>[_pointer.address],
      );

  /// Set metadata for the collection object from a byte array
  ///
  /// @param this_ the object handle
  /// @param meta the metadata for the collection. This needs to be a valid `EtebaseItemMetadata`-like struct encoded using `msgpack`.
  /// @param meta_size the metadata size
  Future<void> setMetaRaw(_i6.Uint8List meta) => _isolate.invoke<void>(
        #etebase_collection_set_meta_raw,
        <dynamic>[
          _pointer.address,
          _i7.TransferableTypedData.fromList([meta]),
        ],
      );

  /// Write the metadata of the collection to a byte array and return its length
  ///
  /// @param this_ the object handle
  /// @param[out] buf the output byte buffer
  /// @param buf_size the maximum number of bytes to be written to buf
  Future<_i6.Uint8List> getMetaRaw([int? sizeHint]) async {
    final data = await _isolate.invoke<_i7.TransferableTypedData>(
      #etebase_collection_get_meta_raw,
      <dynamic>[
        _pointer.address,
        sizeHint,
      ],
    );
    return data.materialize().asUint8List();
  }

  /// Set the content of the collection
  ///
  /// @param this_ the object handle
  /// @param content the content of the collection as a byte array
  /// @param content_size the content size
  Future<void> setContent(_i6.Uint8List content) => _isolate.invoke<void>(
        #etebase_collection_set_content,
        <dynamic>[
          _pointer.address,
          _i7.TransferableTypedData.fromList([content]),
        ],
      );

  /// Write the content of the collection to a byte array and return its length
  ///
  /// @param this_ the object handle
  /// @param[out] buf the output byte buffer
  /// @param buf_size the maximum number of bytes to be written to buf
  Future<_i6.Uint8List> getContent([int? sizeHint]) async {
    final data = await _isolate.invoke<_i7.TransferableTypedData>(
      #etebase_collection_get_content,
      <dynamic>[
        _pointer.address,
        sizeHint,
      ],
    );
    return data.materialize().asUint8List();
  }

  /// Mark the collection as deleted
  ///
  /// The collection needs to be \ref uploaded `etebase_collection_manager_upload` for this to take effect
  ///
  /// @param this_ the object handle
  Future<void> delete() => _isolate.invoke<void>(
        #etebase_collection_delete,
        <dynamic>[_pointer.address],
      );

  /// Check whether the collection is marked as deleted
  ///
  /// @param this_ the object handle
  Future<bool> isDeleted() => _isolate.invoke<bool>(
        #etebase_collection_is_deleted,
        <dynamic>[_pointer.address],
      );

  /// The UID of the collection
  ///
  /// @param this_ the object handle
  Future<String> getUid() => _isolate.invoke<String>(
        #etebase_collection_get_uid,
        <dynamic>[_pointer.address],
      );

  /// The etag of the collection
  ///
  /// @param this_ the object handle
  Future<String> getEtag() => _isolate.invoke<String>(
        #etebase_collection_get_etag,
        <dynamic>[_pointer.address],
      );

  /// The sync token for the collection
  ///
  /// The sync token reflects changes to the collection properties or its items on the server
  ///
  /// @param this_ the object handle
  Future<String?> getStoken() => _isolate.invoke<String?>(
        #etebase_collection_get_stoken,
        <dynamic>[_pointer.address],
      );

  /// Return the collection as an item
  ///
  /// @param this_ the object handle
  Future<EtebaseItem> asItem() async => EtebaseItem._(
        _isolate,
        _i4.Pointer.fromAddress(await _isolate.invoke<int>(
          #etebase_collection_as_item,
          <dynamic>[_pointer.address],
        )),
      );

  /// The type of the collection
  ///
  /// @param this_ the object handle
  Future<String> getCollectionType() => _isolate.invoke<String>(
        #etebase_collection_get_collection_type,
        <dynamic>[_pointer.address],
      );

  /// Return the access level of the collection for the current user
  ///
  /// @param this_ the object handle
  Future<_i8.EtebaseCollectionAccessLevel> getAccessLevel() =>
      _isolate.invoke<_i8.EtebaseCollectionAccessLevel>(
        #etebase_collection_get_access_level,
        <dynamic>[_pointer.address],
      );
  static Future<void> _destroy(
          _i3.DestroyReference<_i5.EtebaseCollection> this_) =>
      this_.isolate.invoke<void>(
        #etebase_collection_destroy,
        <dynamic>[this_.pointer.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    if (_owner == null) {
      _finalizer.detach(this);
      await _destroy(_i3.DestroyReference(
        _isolate,
        _pointer,
      ));
    }
  }
}

/// The dart binding of the EtebaseClient rust class
class EtebaseClient {
  EtebaseClient._(
    this._isolate,
    this._pointer, [
    this._owner,
  ]) {
    if (_owner == null) {
      _finalizer.attach(
        this,
        _i3.DestroyReference(
          _isolate,
          _pointer,
        ),
        detach: this,
      );
    }
  }

  static final _finalizer = Finalizer(_destroy);

  final _i1.EtebaseIsolateReference _isolate;

  final _i4.Pointer<_i5.EtebaseClient> _pointer;

  final Object? _owner;

  /// Creates a new etebase client.
  static Future<EtebaseClient> create(
    String clientName, [
    Uri? serverUrl,
  ]) async {
    final isolate = await _i1.EtebaseIsolateReference.create();
    return EtebaseClient._(
      isolate,
      _i4.Pointer.fromAddress(await isolate.invoke<int>(
        #etebase_client_new,
        <dynamic>[
          clientName,
          serverUrl,
        ],
      )),
    );
  }

  /// Sets the server URL of the client.
  Future<void> setServerUrl(Uri serverUrl) => _isolate.invoke<void>(
        #etebase_client_set_server_url,
        <dynamic>[
          _pointer.address,
          serverUrl,
        ],
      );

  /// Returns 0 if client is pointing an etebase server, 1 if not, -1 on error
  ///
  /// @param client the object handle
  Future<bool> checkEtebaseServer() => _isolate.invoke<bool>(
        #etebase_client_check_etebase_server,
        <dynamic>[_pointer.address],
      );
  static Future<void> _destroy(
      _i3.DestroyReference<_i5.EtebaseClient> this_) async {
    await this_.isolate.invoke<void>(
      #etebase_client_destroy,
      <dynamic>[this_.pointer.address],
    );
    await this_.isolate.dispose();
  }

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    if (_owner == null) {
      _finalizer.detach(this);
      await _destroy(_i3.DestroyReference(
        _isolate,
        _pointer,
      ));
    }
  }
}

/// The dart binding of the EtebaseAccount rust class
class EtebaseAccount {
  EtebaseAccount._(
    this._isolate,
    this._pointer, [
    this._owner,
  ]) {
    if (_owner == null) {
      _finalizer.attach(
        this,
        _i3.DestroyReference(
          _isolate,
          _pointer,
        ),
        detach: this,
      );
    }
  }

  static final _finalizer = Finalizer(_destroy);

  final _i1.EtebaseIsolateReference _isolate;

  final _i4.Pointer<_i5.EtebaseAccount> _pointer;

  final Object? _owner;

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
      EtebaseAccount._(
        client._isolate,
        _i4.Pointer.fromAddress(await client._isolate.invoke<int>(
          #etebase_account_login,
          <dynamic>[
            client._pointer.address,
            username,
            password,
          ],
        )),
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
      EtebaseAccount._(
        client._isolate,
        _i4.Pointer.fromAddress(await client._isolate.invoke<int>(
          #etebase_account_signup,
          <dynamic>[
            client._pointer.address,
            user,
            password,
          ],
        )),
      );

  /// Fetch a new auth token for the account and update the `EtebaseAccount` object with it
  ///
  /// @param this_ the object handle
  Future<void> fetchToken() => _isolate.invoke<void>(
        #etebase_account_fetch_token,
        <dynamic>[_pointer.address],
      );

  /// Fetch the link to the user dashboard of the account
  ///
  /// @param this_ the object handle
  Future<Uri> fetchDashboardUrl() => _isolate.invoke<Uri>(
        #etebase_account_fetch_dashboard_url,
        <dynamic>[_pointer.address],
      );

  /// Change the server URL for this account handle
  ///
  /// @param this_ the object handle
  /// @param server_url the new server URL to be set
  Future<void> forceServerUrl(Uri serverUrl) => _isolate.invoke<void>(
        #etebase_account_force_server_url,
        <dynamic>[
          _pointer.address,
          serverUrl,
        ],
      );

  /// Change the user's login password
  ///
  /// @param this_ the object handle
  /// @param password the new password to be set
  Future<void> changePassword(String password) => _isolate.invoke<void>(
        #etebase_account_change_password,
        <dynamic>[
          _pointer.address,
          password,
        ],
      );

  /// Logout the user from the current session and invalidate the authentication token
  ///
  /// @param this_ the object handle
  Future<void> logout() => _isolate.invoke<void>(
        #etebase_account_logout,
        <dynamic>[_pointer.address],
      );

  /// Return a `EtebaseCollectionManager` for creating, fetching and uploading collections
  ///
  /// @param this_ the object handle
  Future<EtebaseCollectionManager> getCollectionManager() async =>
      EtebaseCollectionManager._(
        _isolate,
        _i4.Pointer.fromAddress(await _isolate.invoke<int>(
          #etebase_account_get_collection_manager,
          <dynamic>[_pointer.address],
        )),
      );

  /// Return a `EtebaseCollectionInvitationManager` for managing collection invitations
  ///
  /// @param this_ the object handle
  Future<EtebaseCollectionInvitationManager> getInvitationManager() async =>
      EtebaseCollectionInvitationManager._(
        _isolate,
        _i4.Pointer.fromAddress(await _isolate.invoke<int>(
          #etebase_account_get_invitation_manager,
          <dynamic>[_pointer.address],
        )),
      );

  /// Save the account object to a string for restoring it later using `etebase_account_restore`
  ///
  /// @param this_ the object handle
  /// @param encryption_key used to encrypt the returned account string to enhance security
  /// @param encryption_key_size size of the encryption_key
  Future<String> save([_i6.Uint8List? encryptionKey]) =>
      _isolate.invoke<String>(
        #etebase_account_save,
        <dynamic>[
          _pointer.address,
          encryptionKey == null
              ? null
              : _i7.TransferableTypedData.fromList([encryptionKey]),
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
    String accountDataStored, [
    _i6.Uint8List? encryptionKey,
  ]) async =>
      EtebaseAccount._(
        client._isolate,
        _i4.Pointer.fromAddress(await client._isolate.invoke<int>(
          #etebase_account_restore,
          <dynamic>[
            client._pointer.address,
            accountDataStored,
            encryptionKey == null
                ? null
                : _i7.TransferableTypedData.fromList([encryptionKey]),
          ],
        )),
      );
  static Future<void> _destroy(
          _i3.DestroyReference<_i5.EtebaseAccount> this_) =>
      this_.isolate.invoke<void>(
        #etebase_account_destroy,
        <dynamic>[this_.pointer.address],
      );

  /// Destroy the object
  ///
  /// @param this_ the object handle
  Future<void> dispose() async {
    if (_owner == null) {
      _finalizer.detach(this);
      await _destroy(_i3.DestroyReference(
        _isolate,
        _pointer,
      ));
    }
  }
}

/// The dart binding of the EtebaseUtils rust class
abstract class EtebaseUtils {
  EtebaseUtils._();

  /// Return a buffer filled with cryptographically random bytes
  ///
  /// @param[out] buf the output byte buffer
  /// @param size the size of the returned buffer
  static Future<_i6.Uint8List> randombytes(
    EtebaseClient client,
    int size,
  ) async {
    final data = await client._isolate.invoke<_i7.TransferableTypedData>(
      #etebase_utils_randombytes,
      <dynamic>[size],
    );
    return data.materialize().asUint8List();
  }

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
  static Future<String> prettyFingerprint(
    EtebaseClient client,
    _i6.Uint8List content,
  ) =>
      client._isolate.invoke<String>(
        #etebase_utils_pretty_fingerprint,
        <dynamic>[
          _i7.TransferableTypedData.fromList([content])
        ],
      );
}
