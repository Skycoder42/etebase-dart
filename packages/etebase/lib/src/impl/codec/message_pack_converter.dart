import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:msgpack_codec/msgpack_codec.dart';

import '../../api/exceptions/http_error_content.dart';
import '../../api/exceptions/invalid_message_pack_data.dart';
import '../../api/models/etebase_collection_member.dart';
import '../../api/models/etebase_item_metadata.dart';
import '../../api/models/etebase_list_response.dart';
import '../../api/models/etebase_user_profile.dart';
import '../encrypted_models/cached/cached_chunk.dart';
import '../encrypted_models/cached/cached_collection.dart';
import '../encrypted_models/cached/cached_collection_item.dart';
import '../encrypted_models/cached/cached_revision.dart';
import '../encrypted_models/encrypted_collection.dart';
import '../encrypted_models/encrypted_collection_item.dart';
import '../encrypted_models/encrypted_revision.dart';
import '../models/account_data.dart';
import '../models/account_data_stored.dart';
import '../models/challenge_request.dart';
import '../models/collection_item_fetch_info.dart';
import '../models/invitation_accept_request.dart';
import '../models/item_batch_request.dart';
import '../models/login_challenge.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/modify_access_level_request.dart';
import '../models/signed_invitation.dart';
import '../models/signed_invitation_content.dart';
import '../models/signup_request.dart';
import '../models/web_socket_ticket_response.dart';
import 'base64_url_no_pad_codec.dart';
import 'type_converter.dart';

@internal
class MessagePackConverter {
  final _factories = <Type, TypeConverter<dynamic>>{};

  MessagePackConverter() {
    _add(EtebaseItemMetadata.fromJson);
    _add(EtebaseUserProfile.fromJson);
    _addWithContainer(
      EtebaseCollectionMember.fromJson,
      EtebaseListResponse.iteratorFromJson<EtebaseCollectionMember>,
    );
    _add(AccountDataStored.fromJson);
    _add(AccountData.fromJson);
    _add(SignedInvitationContent.fromJson);

    _add(HttpErrorContent.fromJson);
    _add(SignupRequest.fromJson);
    _add(LoginResponse.fromJson);
    _add(ChallengeRequest.fromJson);
    _add(LoginChallenge.fromJson);
    _add(LoginRequest.fromJson);
    _addWithContainer(
      EncryptedCollection.fromJson,
      EtebaseListResponse.collectionFromJson<EncryptedCollection>,
    );
    _addWithContainer(
      EncryptedCollectionItem.fromJson,
      EtebaseListResponse.itemFromJson<EncryptedCollectionItem>,
    );
    _addWithContainer(
      EncryptedRevision.fromJson,
      EtebaseListResponse.iteratorFromJson<EncryptedRevision>,
    );
    _add(CollectionItemFetchInfo.fromJson);
    _add(ItemBatchRequest.fromJson);
    _add(WebSocketTicketResponse.fromJson);
    _addWithContainer(
      SignedInvitationRead.fromJson,
      EtebaseListResponse.iteratorFromJson<SignedInvitationRead>,
    );
    _add(InvitationAcceptRequest.fromJson);
    _add(SignedInvitationWrite.fromJson);
    _add(ModifyAccessLevelRequest.fromJson);

    _addList(CachedChunk.fromJson);
    _addList(CachedRevision.fromJson);
    _addList(CachedCollectionItem.fromJson);
    _addList(CachedCollection.fromJson);
  }

  Uint8List encode(dynamic data) =>
      _wrapped(() => msgPack.encode(_toJson(data)));

  Uint8List encodeRaw(dynamic data) => _wrapped(() => msgPack.encode(data));

  String encode64(dynamic data) =>
      _wrapped(() => msgPack64UrlNoPad.encode(_toJson(data)));

  String encode64Raw(dynamic data) =>
      _wrapped(() => msgPack64UrlNoPad.encode(data));

  String base64Encode(Uint8List data) =>
      _wrapped(() => base64UrlNoPad.encode(data));

  T decode<T>(Uint8List data) => _wrapped(() => _fromJson<T>(decodeRaw(data)));

  dynamic decodeRaw(Uint8List data) => _wrapped(() => msgPack.decode(data));

  T decode64<T>(String data) => _wrapped(() => _fromJson<T>(decode64Raw(data)));

  dynamic decode64Raw(String data) =>
      _wrapped(() => msgPack64UrlNoPad.decode(data));

  Uint8List base64Decode(String data) =>
      _wrapped(() => base64UrlNoPad.decode(data));

  void addCustom<T>(FromJson<T> fromJson) => _add<T>(fromJson);

  void _add<T>(FromJson<T> fromJson) =>
      _factories[T] = TypeConverter<T>(fromJson);

  void _addList<T>(FromJsonList<T> fromJson) =>
      _factories[T] = TypeConverter<T>.list(fromJson);

  void _addWithContainer<TContainer, TData>(
    FromJson<TData> fromJson,
    ContainerFromJson<TContainer, TData> containerFromJson,
  ) {
    _add<TData>(fromJson);
    _factories[TContainer] = TypeConverter.generic<TContainer, TData>(
      containerFromJson,
      fromJson,
    );
  }

  // ignore: avoid_dynamic_calls
  dynamic _toJson(dynamic data) => switch (data) {
        List() => data.map(_toJson).toList(),
        Map<String, dynamic>() => data.map((k, v) => MapEntry(k, _toJson(v))),
        // ignore: avoid_dynamic_calls
        _ => data.toJson(),
      };

  T _fromJson<T>(dynamic data) {
    final converter = _factories[T] as TypeConverter<T>?;
    if (converter == null) {
      throw UnsupportedError('No converter for $T registered');
    }

    return converter(data);
  }

  T _wrapped<T>(T Function() callback) {
    try {
      return callback();
    } on InvalidMessagePackData {
      rethrow;
      // ignore: avoid_catching_errors
    } on UnsupportedError {
      rethrow;
    } on MsgpackFormatException catch (e, s) {
      Error.throwWithStackTrace(InvalidMessagePackData(e.message, e), s);
    } on CheckedFromJsonException catch (e, s) {
      Error.throwWithStackTrace(
        InvalidMessagePackData(e.message ?? e.toString(), e),
        e.innerStack ?? s,
      );
    } on FormatException catch (e, s) {
      Error.throwWithStackTrace(InvalidMessagePackData(e.message, e), s);
      // ignore: avoid_catches_without_on_clauses
    } catch (e, s) {
      Error.throwWithStackTrace(InvalidMessagePackData(e.toString(), e), s);
    }
  }
}
