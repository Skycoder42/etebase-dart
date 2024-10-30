import 'dart:async';
import 'dart:typed_data';

import 'package:chopper/chopper.dart';
import 'package:meta/meta.dart';
import 'package:msgpack_dart/msgpack_dart.dart' as msgPack;

import '../../api/exceptions/conflict.dart';
import '../../api/exceptions/http_error_content.dart';
import '../../api/exceptions/http_failure.dart';
import '../../api/exceptions/invalid_message_pack_data.dart';
import '../../api/exceptions/not_found.dart';
import '../../api/exceptions/permission_denied.dart';
import '../../api/exceptions/server_problem.dart';
import '../../api/exceptions/temporary_server_problem.dart';
import '../../api/exceptions/unauthorized.dart';
import 'models/login_response.dart';
import 'models/signup_request.dart';

typedef _FromJson<T> = T Function(Map<String, dynamic> json);

@internal
class MsgPackConverter implements Converter, ErrorConverter {
  static const _msgPackContentType = 'application/msgpack';

  final _factories = <Type, _FromJson<dynamic>>{};

  MsgPackConverter() {
    _add(SignupRequest.fromJson);
    _add(LoginResponse.fromJson);
  }

  @override
  Request convertRequest(Request request) {
    final body = request.body;
    if (body case null || Uint8List() || String()) {
      return request;
    }

    return applyHeader(
      request.copyWith(
        // ignore: avoid_dynamic_calls
        body: msgPack.serialize(request.body.toJson()),
      ),
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

    final fromJson = _factories[InnerType] as _FromJson<InnerType>?;
    if (fromJson == null) {
      throw UnsupportedError('Cannot convert a response of type $BodyType');
    }

    try {
      BodyType body;
      if (isTypeOf<BodyType, Iterable<InnerType>>()) {
        body = _deserializeList(response.bodyBytes, fromJson);
      } else if (isTypeOf<BodyType, Map<String, InnerType>>()) {
        body = _deserializeMap(response.bodyBytes, fromJson);
      } else {
        body = _deserializeValue(response.bodyBytes, fromJson);
      }
      return response.copyWith(body: body);
    } on InvalidMessagePackData catch (_) {
      rethrow;
    } catch (e, s) {
      Error.throwWithStackTrace(InvalidMessagePackData(e.toString()), s);
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

  void _add<T>(_FromJson<T> fromJson) => _factories[T] = fromJson;

  bool _checkContentType(Response<dynamic> response) {
    final contentType = response.headers[contentTypeKey];
    return contentType == _msgPackContentType;
  }

  BodyType _deserializeList<BodyType, InnerType>(
    Uint8List data,
    _FromJson<InnerType> fromJson,
  ) =>
      _deserialize<Iterable<dynamic>>(data)
          .cast<Map<String, dynamic>>()
          .map(fromJson)
          .toList() as BodyType;

  BodyType _deserializeMap<BodyType, InnerType>(
    Uint8List data,
    _FromJson<InnerType> fromJson,
  ) =>
      _deserialize<Map<dynamic, dynamic>>(data)
          .cast<String, Map<String, dynamic>>()
          .map((k, v) => MapEntry(k, fromJson(v))) as BodyType;

  BodyType _deserializeValue<BodyType, InnerType>(
    Uint8List data,
    _FromJson<InnerType> fromJson,
  ) =>
      fromJson(_deserialize<Map<dynamic, dynamic>>(data).cast()) as BodyType;

  T _deserialize<T>(Uint8List data) {
    try {
      final jsonData = msgPack.deserialize(data);
      if (jsonData is! T) {
        throw InvalidMessagePackData(
          'Expected deserialized data to be of type $T, '
          'but was ${jsonData.runtimeType}',
        );
      }

      return jsonData;
    } on msgPack.FormatError catch (e, s) {
      Error.throwWithStackTrace(InvalidMessagePackData(e.message), s);
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
        HttpErrorContent.fromJson,
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
}
