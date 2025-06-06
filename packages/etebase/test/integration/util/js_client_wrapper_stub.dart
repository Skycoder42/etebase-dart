import 'dart:typed_data';

// ignore: no_self_package_imports
import 'package:etebase/etebase.dart';
import 'package:etebase/src/impl/codec/base64_url_no_pad_codec.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'js_client_wrapper_stub.freezed.dart';
part 'js_client_wrapper_stub.g.dart';

final class _BinaryConverter implements JsonConverter<Uint8List, String> {
  const _BinaryConverter();

  @override
  Uint8List fromJson(String json) => base64UrlNoPad.decode(json);

  @override
  String toJson(Uint8List object) => base64UrlNoPad.encode(object);
}

const _binary = _BinaryConverter();

@Freezed(unionKey: 'action')
sealed class Action with _$Action {
  // account test
  const factory Action.signUp(String username, String email, String password) =
      _SignUp;
  const factory Action.signIn(String username, String password) = _SignIn;
  @_binary
  const factory Action.saveAccount(
    String username,
    String password,
    Uint8List encryptionKey,
  ) = _SaveAccount;
  @_binary
  const factory Action.restoreAccount(String data, Uint8List encryptionKey) =
      _RestoreAccount;

  // collection test
  const factory Action.listCollections(List<String> types) = _ListCollections;
  @_binary
  const factory Action.validateCollection(
    String uid, {
    EtebaseItemMetadata? meta,
    Uint8List? content,
    bool? isDeleted,
    EtebaseCollectionAccessLevel? accessLevel,
  }) = _ValidateCollection;
  @_binary
  const factory Action.createCollection(
    String collectionType,
    EtebaseItemMetadata meta,
    Uint8List content,
  ) = _CreateCollection;
  @_binary
  const factory Action.updateCollection(
    String uid, {
    EtebaseItemMetadata? meta,
    Uint8List? content,
    @Default(false) bool delete,
    @Default(false) bool preserveContent,
  }) = _UpdateCollection;
  @_binary
  const factory Action.restoreCollection(
    Uint8List data, {
    EtebaseItemMetadata? meta,
    Uint8List? content,
    @Default(false) bool noContent,
    bool? isDeleted,
  }) = _RestoreCollection;
  const factory Action.saveCollection(
    String uid, {
    @Default(true) bool preserveContent,
  }) = _SaveCollection;

  // item test
  const factory Action.listItems() = _ListItems;
  @_binary
  const factory Action.validateItem(
    String uid, {
    EtebaseItemMetadata? meta,
    Uint8List? content,
    bool? isDeleted,
  }) = _ValidateItem;
  @_binary
  const factory Action.createItem(EtebaseItemMetadata meta, Uint8List content) =
      _CreateItem;
  @_binary
  const factory Action.updateItem(
    String uid, {
    EtebaseItemMetadata? meta,
    Uint8List? content,
    @Default(false) bool delete,
    @Default(false) bool preserveContent,
  }) = _UpdateItem;
  @_binary
  const factory Action.restoreItem(
    Uint8List data, {
    EtebaseItemMetadata? meta,
    Uint8List? content,
    @Default(false) bool noContent,
    bool? isDeleted,
  }) = _RestoreItem;
  const factory Action.saveItem(
    String uid, {
    @Default(true) bool preserveContent,
  }) = _SaveItem;

  // sharing test
  @_binary
  const factory Action.validatePubkey(Uint8List pubkey, String fingerprint) =
      _ValidatePubkey;
  @_binary
  const factory Action.acceptInvitation({
    required String collection,
    required Uint8List fromPubKey,
    required String fromUsername,
    required String username,
    @Default(true) bool accept,
  }) = _AcceptInvitation;
  @_binary
  const factory Action.invite({
    required String colUid,
    required Uint8List pubKey,
    required String username,
    required EtebaseCollectionAccessLevel accessLevel,
  }) = _Invite;

  factory Action.fromJson(Map<String, dynamic> json) => _$ActionFromJson(json);

  const Action._();

  @internal
  String get $type;
}

abstract class JsClientWrapper {
  @protected
  late final EtebaseAccount account;
  @protected
  late final EtebaseCollection collection;

  factory JsClientWrapper() => throw UnimplementedError('Unsupported platform');

  JsClientWrapper.base();

  // ignore: use_setters_to_change_properties
  void configureAccount(
    EtebaseAccount account, [
    EtebaseCollection? collection,
  ]) {
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
