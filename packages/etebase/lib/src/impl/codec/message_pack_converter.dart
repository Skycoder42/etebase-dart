import 'dart:convert';
import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:msgpack_dart/msgpack_dart.dart';

import '../../api/exceptions/http_error_content.dart';
import '../../api/exceptions/invalid_message_pack_data.dart';
import '../../api/models/etebase_item_metadata.dart';
import '../encrypted_models/encrypted_collection.dart';
import '../encrypted_models/encrypted_collection_item.dart';
import '../models/account_data.dart';
import '../models/account_data_stored.dart';
import '../models/challenge_request.dart';
import '../models/collection_item_fetch_info.dart';
import '../models/collection_item_list_response.dart';
import '../models/collection_list_response.dart';
import '../models/item_batch_request.dart';
import '../models/login_challenge.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/signup_request.dart';
import '../models/web_socket_ticket_response.dart';
import 'msg_pack_codec.dart';
import 'type_converter.dart';

@internal
class MessagePackConverter {
  final _factories = <Type, TypeConverter<dynamic>>{};

  MessagePackConverter() {
    _addRaw<void>();
    _addRaw<Uint8List>();
    _addRaw<String>();

    _add(EtebaseItemMetadata.fromJson);
    _add(AccountDataStored.fromJson);
    _add(AccountData.fromJson);

    _add(HttpErrorContent.fromJson);
    _add(SignupRequest.fromJson);
    _add(LoginResponse.fromJson);
    _add(ChallengeRequest.fromJson);
    _add(LoginChallenge.fromJson);
    _add(LoginRequest.fromJson);
    _add(EncryptedCollection.fromJson);
    _addGeneric(
      CollectionListResponse<EncryptedCollection>.fromJson,
      EncryptedCollection.fromJson,
    );
    _add(EncryptedCollectionItem.fromJson);
    _addGeneric(
      CollectionItemListResponse<EncryptedCollectionItem>.fromJson,
      EncryptedCollectionItem.fromJson,
    );
    _add(CollectionItemFetchInfo.fromJson);
    _add(ItemBatchRequest.fromJson);
    _add(WebSocketTicketResponse.fromJson);
  }

  Uint8List encode(dynamic data) => msgPack.encode(data);

  String encode64(dynamic data) => msgPack64.encode(data);

  String base64Encode(Uint8List data) => base64.encode(data);

  dynamic decodeRaw(Uint8List data) => msgPack.decode(data);

  T decode<T>(Uint8List data) => _fromJson<T>(decodeRaw(data));

  dynamic decode64Raw(String data) => msgPack64.decode(data);

  T decode64<T>(String data) => _fromJson<T>(decode64Raw(data));

  Uint8List base64Decode(String data) => base64.decode(data);

  void _addRaw<T>() => _factories[T] = TypeConverter<T>.raw();

  void _add<T>(
    FromJson<T> fromJson, {
    bool withPlain = true,
    bool withList = false,
    bool withMap = false,
  }) {
    if (withPlain) {
      _factories[T] = TypeConverter<T>(fromJson);
    }
    if (withList) {
      _factories[List<T>] = TypeConverter.list<T>(fromJson);
    }
    if (withMap) {
      _factories[Map<String, T>] = TypeConverter.map<T>(fromJson);
    }
  }

  void _addGeneric<TContainer, TData>(
    ContainerFromJson<TContainer, TData> containerFromJson,
    FromJson<TData> fromJson,
  ) =>
      _factories[TContainer] =
          TypeConverter.generic<TContainer, TData>(containerFromJson, fromJson);

  T _fromJson<T>(dynamic data) {
    final converter = _factories[T] as TypeConverter<T>?;
    if (converter == null) {
      throw UnsupportedError('No converter for $T registered');
    }

    try {
      return converter(data);
    } on FormatError catch (e, s) {
      Error.throwWithStackTrace(InvalidMessagePackData(e.message, e), s);
    } on CheckedFromJsonException catch (e, s) {
      Error.throwWithStackTrace(
        InvalidMessagePackData(e.message ?? e.toString(), e),
        s,
      );
    } on FormatException catch (e, s) {
      Error.throwWithStackTrace(InvalidMessagePackData(e.message, e), s);
      // ignore: avoid_catches_without_on_clauses
    } catch (e, s) {
      Error.throwWithStackTrace(InvalidMessagePackData(e.toString(), e), s);
    }
  }
}
