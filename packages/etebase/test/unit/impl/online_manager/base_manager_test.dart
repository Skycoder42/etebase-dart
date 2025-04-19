import 'package:dart_test_tools/test.dart';
import 'package:etebase/src/api/models/etebase_fetch_options.dart';
import 'package:etebase/src/api/models/etebase_prefetch_option.dart';
import 'package:etebase/src/impl/models/auth_token.dart';
import 'package:etebase/src/impl/online_managers/base_manager.dart';
import 'package:etebase/src/impl/online_managers/base_network.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../test_helpers.dart';
import 'online_manager_mocks.dart';

class TestableBaseManager extends BaseManager {
  TestableBaseManager({
    required super.client,
    required super.authTokenSource,
    super.path,
  });

  TestableBaseManager.fromNetwork(super._network, super.authTokenSource)
    : super.fromNetwork();
}

void main() {
  group('$BaseManager', () {
    const testAuthToken = AuthToken('test');

    final mockBaseNetwork = MockBaseNetwork();
    final mockAuthTokenSource = MockAuthTokenSource();

    late BaseManager sut;

    setUpAll(() {
      provideDummy(testAuthToken);
    });

    setUp(() {
      reset(mockBaseNetwork);
      reset(mockAuthTokenSource);

      when(mockAuthTokenSource.authToken).thenReturn(testAuthToken);

      sut = TestableBaseManager.fromNetwork(
        mockBaseNetwork,
        mockAuthTokenSource,
      );
    });

    test('constructs base network from client and base path', () {
      final testBaseUri = Uri.http('example.com', '/base');
      final testSubPath = ['custom', 'stuff'];

      final mockNetworkClient = MockNetworkClient();
      when(mockNetworkClient.baseUrl).thenReturn(testBaseUri);

      final sut = TestableBaseManager(
        client: mockNetworkClient,
        authTokenSource: mockAuthTokenSource,
        path: testSubPath,
      );

      expect(sut.apiUrl, Uri.http('example.com', '/base/api/v1/custom/stuff'));
      expect(sut.client, same(mockNetworkClient));
    });

    group('invoke', () {
      test('preserves defaults but adds auth token', () async {
        await sut.invoke<void>();

        verify(mockBaseNetwork.invoke<void>(authToken: testAuthToken));
      });

      test('maps all custom parameters', () async {
        const testMethod = HttpMethod.put;
        final testPath = ['test', 'path'];
        final testHeaders = {'A': 'T1'};
        final testQuery = {'x': '42'};
        const testBody = 42;
        const testResponse = 'result';

        whenInvoke<String>(mockBaseNetwork).thenReturnAsync(testResponse);

        final result = await sut.invoke<String>(
          method: testMethod,
          path: testPath,
          headers: testHeaders,
          query: testQuery,
          body: testBody,
        );

        expect(result, testResponse);

        verify(
          mockBaseNetwork.invoke<String>(
            method: testMethod,
            path: testPath,
            headers: testHeaders,
            query: testQuery,
            body: testBody,
            authToken: testAuthToken,
          ),
        );
      });

      group('options', () {
        testData<(EtebaseFetchOptionsBase, Map<String, String>)>(
          'builds query parameters from options',
          const [
            (EtebaseFetchOptions(), {}),
            (
              EtebaseFetchOptions(
                limit: 10,
                stoken: 'test-stoken',
                prefetch: EtebasePrefetchOption.medium,
              ),
              {'limit': '10', 'stoken': 'test-stoken', 'prefetch': 'medium'},
            ),
            (EtebaseItemFetchOptions(), {}),
            (
              EtebaseItemFetchOptions(
                limit: 10,
                stoken: 'test-stoken',
                prefetch: EtebasePrefetchOption.medium,
                withCollection: true,
              ),
              {
                'limit': '10',
                'stoken': 'test-stoken',
                'prefetch': 'medium',
                'withCollection': 'true',
              },
            ),
            (EtebaseIteratorFetchOptions(), {}),
            (
              EtebaseIteratorFetchOptions(limit: 10, iterator: 'test-iterator'),
              {'limit': '10', 'iterator': 'test-iterator'},
            ),
            (EtebaseRevisionFetchOptions(), {}),
            (
              EtebaseRevisionFetchOptions(
                limit: 10,
                iterator: 'test-iterator',
                prefetch: EtebasePrefetchOption.auto,
              ),
              {'limit': '10', 'iterator': 'test-iterator', 'prefetch': 'auto'},
            ),
          ],
          (fixture) async {
            await sut.invoke<void>(options: fixture.$1);

            verify(
              mockBaseNetwork.invoke<void>(
                query: fixture.$2,
                authToken: testAuthToken,
              ),
            );
          },
        );

        test('merges options with original query', () async {
          const testOptions = EtebaseRevisionFetchOptions(
            limit: 24,
            iterator: 'iter-1',
          );

          await sut.invoke<void>(
            query: {'offset': '10', 'limit': '50'},
            options: testOptions,
          );

          verify(
            mockBaseNetwork.invoke<void>(
              query: {'offset': '10', 'limit': '24', 'iterator': 'iter-1'},
              authToken: testAuthToken,
            ),
          );
        });
      });
    });
  });
}
