import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:meta/meta.dart';
import 'package:msgpack_dart/msgpack_dart.dart' as msgPack;

@internal
class MsgPackConverter implements Converter {
  static const _contentTypeHeader = 'Content-Type';

  @override
  Request convertRequest(Request request) => applyHeader(
        request.copyWith(
          body: request.body != null
              // ignore: avoid_dynamic_calls
              ? msgPack.serialize(request.body.toJson())
              : null,
        ),
        _contentTypeHeader,
        'application/msgpack',
      );

  @override
  FutureOr<Response<BodyType>> convertResponse<BodyType, InnerType>(
    Response<dynamic> response,
  ) {
    // TODO: implement convertResponse
    throw UnimplementedError();
  }
}
