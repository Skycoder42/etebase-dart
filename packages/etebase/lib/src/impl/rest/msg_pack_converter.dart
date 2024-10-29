import 'dart:async';
import 'dart:typed_data';

import 'package:chopper/chopper.dart';
import 'package:meta/meta.dart';
import 'package:msgpack_dart/msgpack_dart.dart' as msgPack;

import 'models/login_response.dart';
import 'models/signup_request.dart';

typedef _FromJson<T> = T Function(Map<String, dynamic> json);

@internal
class MsgPackConverter implements Converter {
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
    final contentType = response.headers[contentTypeKey];
    if (contentType != _msgPackContentType) {
      return response.copyWith();
    }

    final fromJson = _factories[InnerType] as _FromJson<InnerType>?;
    if (fromJson == null) {
      throw UnsupportedError('Cannot convert a response of type $BodyType');
    }

    final jsonData = msgPack.deserialize(response.bodyBytes);

    BodyType body;
    if (isTypeOf<BodyType, Iterable<InnerType>>()) {
      body = (jsonData as Iterable<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(fromJson) as BodyType;
    } else if (isTypeOf<BodyType, Map<String, InnerType>>()) {
      body = (jsonData as Map<dynamic, dynamic>)
          .cast<String, Map<String, dynamic>>()
          .map((k, v) => MapEntry(k, fromJson(v))) as BodyType;
    } else {
      body = fromJson((jsonData as Map<dynamic, dynamic>).cast()) as BodyType;
    }

    return response.copyWith<BodyType>(body: body);
  }

  void _add<T>(_FromJson<T> fromJson) => _factories[T] = fromJson;
}
