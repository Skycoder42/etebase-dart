import 'package:etebase/src/api/managers/cache.dart';
import 'package:etebase/src/impl/cache/hive_cache.dart';
import 'package:etebase/src/impl/managers/client_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../test_helpers.dart';
@GenerateNiceMocks([MockSpec<ClientImpl>()])
import 'cache_test.mocks.dart';

class FakeCache extends Fake implements HiveCache {}

void main() {
  group('$Cache', () {
    test('create creates cache instance via client', () async {
      const testUserName = 'test-user';

      final mockClient = MockClientImpl();
      final testCache = FakeCache();

      when(mockClient.createCache(any)).thenReturnAsync(testCache);

      final result = await Cache.create(mockClient, testUserName);
      expect(result, same(testCache));

      verify(mockClient.createCache(testUserName));
    });
  });
}
