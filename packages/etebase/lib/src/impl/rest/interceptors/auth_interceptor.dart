import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:meta/meta.dart';

@internal
class AuthToken {
  final String value;

  static const empty = AuthToken('');

  const AuthToken(this.value);
}

@internal
class AuthInterceptor implements Interceptor {
  static const _authHeaderKey = 'Authorization';

  const AuthInterceptor();

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(Chain<BodyType> chain) {
    final token = switch (chain.request.tag) {
      AuthToken(:final value) when value.isNotEmpty => value,
      _ => null,
    };

    if (token == null) {
      return chain.proceed(chain.request);
    }

    return chain.proceed(
      applyHeader(
        chain.request,
        _authHeaderKey,
        'Token $token',
      ),
    );
  }
}
