// ignore_for_file: discarded_futures

import 'package:etebase/src/impl/models/auth_token.dart';
import 'package:etebase/src/impl/online_managers/base_manager.dart';
import 'package:etebase/src/impl/online_managers/base_network.dart';
import 'package:meta/meta.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../test_helpers.dart';

// ignore: directives_ordering
@GenerateNiceMocks([
  MockSpec<BaseNetwork>(),
  MockSpec<AuthTokenSource>(),
  MockSpec<NetworkClient>(),
])
import 'online_manager_mocks.mocks.dart';

export 'online_manager_mocks.mocks.dart';

PostExpectation<Future<T>> whenInvoke<T>(MockBaseNetwork mockNetwork) => when(
  mockNetwork.invoke<T>(
    method: anyNamed('method'),
    path: anyNamed('path'),
    headers: anyNamed('headers'),
    query: anyNamed('query'),
    body: anyNamed('body'),
    authToken: anyNamed('authToken'),
  ),
);

@isTest
void testInvoke<TReq, TRes>(
  String description, {
  required MockBaseNetwork mock,
  required TReq request,
  required TRes response,
  required Future<TRes> Function(TReq r) call,
  HttpMethod method = HttpMethod.get,
  List<String> path = const [],
  Map<String, String> headers = const {},
  Map<String, String> query = const {},
  AuthToken? authToken,
}) => test(description, () async {
  whenInvoke<TRes>(mock).thenReturnAsync(response);

  final result = await call(request);

  expect(result, response);

  verify(
    mock.invoke<TRes>(
      method: method,
      path: path,
      headers: headers,
      query: query,
      body: request,
      authToken: authToken,
    ),
  );
});
