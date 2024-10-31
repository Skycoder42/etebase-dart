import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:meta/meta.dart';

@internal
class AuthToken {
  final String _token;

  static const empty = AuthToken('');

  const AuthToken(this._token);
}

@internal
class AuthInterceptor implements Interceptor {
  static const _authHeaderKey = 'Authorization';

  const AuthInterceptor();

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(Chain<BodyType> chain) {
    final token = switch (chain.request.tag) {
      AuthToken(:final _token) when _token.isNotEmpty => _token,
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
