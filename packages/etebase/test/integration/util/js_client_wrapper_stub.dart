import 'dart:typed_data';

// ignore: no_self_package_imports
import 'package:etebase/etebase.dart';
import 'package:etebase/src/impl/codec/base64_url_no_pad_codec.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'js_client_wrapper_stub.freezed.dart';
part 'js_client_wrapper_stub.g.dart';

final class _BinaryConverter implements JsonConverter<Uint8List, String> {
  const new();

  @override
  Uint8List fromJson(String json) => base64UrlNoPad.decode(json);

  @override
  String toJson(Uint8List object) => base64UrlNoPad.encode(object);
}

const _binary = _BinaryConverter();

@Freezed(unionKey: 'action')
sealed class Action with _$Action {
  // account test
  const factory signUp(String username, String email, String password) =
      _SignUp;
  const factory signIn(String username, String password) = _SignIn;
  @_binary
  const factory saveAccount(
    String username,
    String password,
    Uint8List encryptionKey,
  ) = _SaveAccount;
  @_binary
  const factory restoreAccount(String data, Uint8List encryptionKey) =
      _RestoreAccount;

  // collection test
  const factory listCollections(List<String> types) = _ListCollections;
  @_binary
  const factory validateCollection(
    String uid, {
    ItemMetadata? meta,
    Uint8List? content,
    bool? isDeleted,
    CollectionAccessLevel? accessLevel,
  }) = _ValidateCollection;
  @_binary
  const factory createCollection(
    String collectionType,
    ItemMetadata meta,
    Uint8List content,
  ) = _CreateCollection;
  @_binary
  const factory updateCollection(
    String uid, {
    ItemMetadata? meta,
    Uint8List? content,
    @Default(false) bool delete,
    @Default(false) bool preserveContent,
  }) = _UpdateCollection;
  @_binary
  const factory restoreCollection(
    Uint8List data, {
    ItemMetadata? meta,
    Uint8List? content,
    @Default(false) bool noContent,
    bool? isDeleted,
  }) = _RestoreCollection;
  const factory saveCollection(
    String uid, {
    @Default(true) bool preserveContent,
  }) = _SaveCollection;

  // item test
  const factory listItems() = _ListItems;
  @_binary
  const factory validateItem(
    String uid, {
    ItemMetadata? meta,
    Uint8List? content,
    bool? isDeleted,
  }) = _ValidateItem;
  @_binary
  const factory createItem(ItemMetadata meta, Uint8List content) = _CreateItem;
  @_binary
  const factory updateItem(
    String uid, {
    ItemMetadata? meta,
    Uint8List? content,
    @Default(false) bool delete,
    @Default(false) bool preserveContent,
  }) = _UpdateItem;
  @_binary
  const factory restoreItem(
    Uint8List data, {
    ItemMetadata? meta,
    Uint8List? content,
    @Default(false) bool noContent,
    bool? isDeleted,
  }) = _RestoreItem;
  const factory saveItem(String uid, {@Default(true) bool preserveContent}) =
      _SaveItem;

  // sharing test
  @_binary
  const factory validatePubkey(Uint8List pubkey, String fingerprint) =
      _ValidatePubkey;
  @_binary
  const factory acceptInvitation({
    required String collection,
    required Uint8List fromPubKey,
    required String fromUsername,
    required String username,
    @Default(true) bool accept,
  }) = _AcceptInvitation;
  @_binary
  const factory invite({
    required String colUid,
    required Uint8List pubKey,
    required String username,
    required CollectionAccessLevel accessLevel,
  }) = _Invite;

  factory fromJson(Map<String, dynamic> json) => _$ActionFromJson(json);

  const new _();

  @internal
  String get $type;
}

abstract class JsClientWrapper {
  @protected
  late final Account account;
  @protected
  late final Collection collection;

  factory() => throw UnimplementedError('Unsupported platform');

  new base();

  void configureAccount(Account account, [Collection? collection]) {
    this.account = account;
    if (collection != null) {
      this.collection = collection;
    }
  }

  Future<TRes> executeSignedIn<TRes>(
    Action action, {
    TRes Function(Map<String, dynamic> json)? fromJson,
  });

  Future<TRes> executeForCollection<TRes>(
    Action action, {
    TRes Function(Map<String, dynamic> json)? fromJson,
  });

  static Future<TRes> execute<TRes>(
    Action action, {
    bool useDefaultServer = false,
    Map<String, dynamic>? actionExtra,
    TRes Function(Map<String, dynamic> json)? fromJson,
  }) => throw UnsupportedError('Unsupported platform');
}
