import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:meta/meta.dart';

@internal
class MessagePackInterceptor implements Interceptor {
  static const _acceptHeader = 'Accept';

  static const _msgPackContentType = 'application/msgpack';

  const MessagePackInterceptor();

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(Chain<BodyType> chain) {
    final request =
        applyHeader(chain.request, _acceptHeader, _msgPackContentType);
    return chain.proceed(request);
  }
}
