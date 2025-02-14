import 'package:etebase/src/api/managers/etebase_cache.dart';
import 'package:etebase/src/impl/cache/hive_cache.dart';
import 'package:etebase/src/impl/managers/client.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../test_helpers.dart';
@GenerateNiceMocks([MockSpec<Client>()])
import 'etebase_cache_test.mocks.dart';

class FakeEtebaseCache extends Fake implements HiveCache {}

void main() {
  group('$EtebaseCache', () {
    test('create creates cache instance via client', () async {
      const testUserName = 'test-user';

      final mockClient = MockClient();
      final testCache = FakeEtebaseCache();

      when(mockClient.createCache(any)).thenReturnAsync(testCache);

      final result = await EtebaseCache.create(mockClient, testUserName);
      expect(result, same(testCache));

      verify(mockClient.createCache(testUserName));
    });
  });
}
