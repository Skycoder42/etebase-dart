import 'dart:async';
import 'dart:typed_data';

import 'package:chopper/chopper.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:msgpack_dart/msgpack_dart.dart';

import '../../../api/exceptions/conflict.dart';
import '../../../api/exceptions/http_error_content.dart';
import '../../../api/exceptions/http_failure.dart';
import '../../../api/exceptions/invalid_message_pack_data.dart';
import '../../../api/exceptions/not_found.dart';
import '../../../api/exceptions/permission_denied.dart';
import '../../../api/exceptions/server_problem.dart';
import '../../../api/exceptions/temporary_server_problem.dart';
import '../../../api/exceptions/unauthorized.dart';
import '../../codec/message_pack_converter.dart';
import '../../encrypted_models/encrypted_collection.dart';
import '../../encrypted_models/encrypted_collection_item.dart';
import '../../models/challenge_request.dart';
import '../../models/collection_item_fetch_info.dart';
import '../../models/collection_item_list_response.dart';
import '../../models/collection_list_response.dart';
import '../../models/item_batch_request.dart';
import '../../models/login_challenge.dart';
import '../../models/login_request.dart';
import '../../models/login_response.dart';
import '../../models/signup_request.dart';
import '../../models/web_socket_ticket_response.dart';
import 'type_converter.dart';

@internal
class MsgPackConverter implements Converter, ErrorConverter {
  static const _msgPackContentType = 'application/msgpack';
  static const _binaryContentType = 'application/octet-stream';

  static const _errorTypeConverter = TypeConverter(HttpErrorContent.fromJson);

  final MessagePackConverter _converter;

  final _factories = <Type, TypeConverter<dynamic>>{};

  MsgPackConverter(this._converter) {
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

  T convertKnownType<T>(Uint8List body) =>
      _getConverter<T>()!(_converter.decodeRaw(body) as Map<String, dynamic>);

  @override
  Request convertRequest(Request request) {
    final body = request.body;
    if (body case null || String()) {
      return request;
    }

    if (body case Uint8List()) {
      return applyHeader(
        request,
        contentTypeKey,
        _binaryContentType,
        override: false,
      );
    }

    return applyHeader(
      request.copyWith(body: _converter.encode(body)),
      contentTypeKey,
      _msgPackContentType,
      override: false,
    );
  }

  @override
  FutureOr<Response<BodyType>> convertResponse<BodyType, InnerType>(
    Response<dynamic> response,
  ) {
    if (!_checkContentType(response)) {
      return response.copyWith();
    }

    final innerConverter = _getConverter<InnerType>();
    if (innerConverter == null) {
      throw UnsupportedError('Cannot convert a response of type $BodyType');
    }

    try {
      BodyType body;
      if (isTypeOf<BodyType, Iterable<InnerType>>()) {
        body = _deserializeList(response.bodyBytes, innerConverter);
      } else if (isTypeOf<BodyType, Map<String, InnerType>>()) {
        body = _deserializeMap(response.bodyBytes, innerConverter);
      } else {
        body = _deserializeValue(response.bodyBytes, innerConverter);
      }
      return response.copyWith(body: body);
    } on InvalidMessagePackData catch (e) {
      return response.copyWith(bodyError: e);
    } on CheckedFromJsonException catch (e) {
      return response.copyWith(
        bodyError: InvalidMessagePackData(e.message ?? e.toString(), e),
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      return response.copyWith(
        bodyError: InvalidMessagePackData(e.toString(), e),
      );
    }
  }

  @override
  FutureOr<Response<dynamic>> convertError<BodyType, InnerType>(
    Response<dynamic> response,
  ) {
    final (message, error) = _extractErrorData(response);
    return response.copyWith(
      bodyError: switch (response.statusCode) {
        Unauthorized.statusCode => Unauthorized(message, error),
        PermissionDenied.statusCode => PermissionDenied(message, error),
        NotFound.statusCode => NotFound(message, error),
        Conflict.statusCode => Conflict(message, error),
        502 ||
        503 ||
        504 =>
          TemporaryServerProblem(response.statusCode, message, error),
        >= 500 && < 600 => ServerProblem(response.statusCode, message, error),
        _ => HttpFailure(response.statusCode, message, error),
      },
    );
  }

  void _add<T>(FromJson<T> fromJson) =>
      _factories[T] = TypeConverter<T>(fromJson);

  void _addGeneric<TContainer, TData>(
    ContainerFromJson<TContainer, TData> containerFromJson,
    FromJson<TData> fromJson,
  ) =>
      _factories[TContainer] =
          TypeConverter.generic<TContainer, TData>(containerFromJson, fromJson);

  bool _checkContentType(Response<dynamic> response) {
    final contentType = response.headers[contentTypeKey];
    return contentType == _msgPackContentType;
  }

  BodyType _deserializeList<BodyType, InnerType>(
    Uint8List data,
    TypeConverter<InnerType> converter,
  ) =>
      _deserialize<Iterable<dynamic>>(data)
          .cast<Map<String, dynamic>>()
          .map(converter.call)
          .toList() as BodyType;

  BodyType _deserializeMap<BodyType, InnerType>(
    Uint8List data,
    TypeConverter<InnerType> converter,
  ) =>
      _deserialize<Map<dynamic, dynamic>>(data)
          .cast<String, Map<String, dynamic>>()
          .map((k, v) => MapEntry(k, converter(v))) as BodyType;

  BodyType _deserializeValue<BodyType, InnerType>(
    Uint8List data,
    TypeConverter<InnerType> converter,
  ) =>
      converter(_deserialize<Map<dynamic, dynamic>>(data).cast()) as BodyType;

  T _deserialize<T>(Uint8List data) {
    try {
      final jsonData = _converter.decodeRaw(data);
      if (jsonData is! T) {
        throw InvalidMessagePackData(
          'Expected deserialized data to be of type $T, '
          'but was ${jsonData.runtimeType}',
        );
      }

      return jsonData;
    } on FormatError catch (e, s) {
      Error.throwWithStackTrace(InvalidMessagePackData(e.message, e), s);
    }
  }

  (String, HttpErrorContent?) _extractErrorData(Response<dynamic> response) {
    final fallbackMessage = 'HTTP Error ${response.statusCode}';

    if (!_checkContentType(response)) {
      return (fallbackMessage, null);
    }

    if (response.bodyBytes.isEmpty) {
      return (fallbackMessage, null);
    }

    try {
      final error = _deserializeValue<HttpErrorContent, HttpErrorContent>(
        response.bodyBytes,
        _errorTypeConverter,
      );
      final message = error.toString(withErrors: false);
      return (message, error);
      // ignore: avoid_catches_without_on_clauses
    } catch (_) {
      // ignore
    }

    try {
      return (response.bodyString, null);
      // ignore: avoid_catches_without_on_clauses
    } catch (_) {
      // ignore
    }

    return (fallbackMessage, null);
  }

  TypeConverter<T>? _getConverter<T>() => _factories[T] as TypeConverter<T>?;
}
