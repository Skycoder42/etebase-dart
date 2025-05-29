import 'dart:typed_data';

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
  }) = _ValidateCollection;
  @_binary
  const factory Action.createCollection(
    String collectionType,
    EtebaseItemMetadata meta,
    Uint8List content,
  ) = _CreateCollection;

  factory Action.fromJson(Map<String, dynamic> json) => _$ActionFromJson(json);

  const Action._();

  @internal
  String get $type;
}

abstract class JsClientWrapper {
  late final String username;
  late final String password;

  factory JsClientWrapper() => throw UnimplementedError('Unsupported platform');

  JsClientWrapper.base();

  void configureAccount(String username, String password) {
    this.username = username;
    this.password = password;
  }

  Future<TRes> executeSignedIn<TRes>(
    Action action, {
    bool useDefaultServer = false,
    TRes Function(Map<String, dynamic> json)? fromJson,
  });

  static Future<TRes> execute<TRes>(
    Action action, {
    bool useDefaultServer = false,
    Map<String, dynamic>? actionExtra,
    TRes Function(Map<String, dynamic> json)? fromJson,
  }) => throw UnsupportedError('Unsupported platform');
}
