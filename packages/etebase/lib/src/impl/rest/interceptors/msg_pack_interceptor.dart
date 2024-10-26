import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:meta/meta.dart';

@internal
class MessagePackInterceptor implements Interceptor {
  static const _msgPackContentType = 'application/msgpack';

  const MessagePackInterceptor();

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(Chain<BodyType> chain) {
    var request = applyHeader(chain.request, 'Accept', _msgPackContentType);
    if (chain.request.body != null) {
      request = applyHeader(request, 'Content-Type', _msgPackContentType);
    }
    return chain.proceed(request);
  }
}
