import 'package:etebase/src/api/models/collection_access_level.dart';
import 'package:etebase/src/api/models/collection_member.dart';
import 'package:etebase/src/api/models/fetch_options.dart';
import 'package:etebase/src/api/models/list_response.dart';
import 'package:etebase/src/impl/managers/collection_member_manager_impl.dart';
import 'package:etebase/src/impl/online_managers/collection_member_manager_online.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../test_helpers.dart';
@GenerateNiceMocks([MockSpec<CollectionMemberManagerOnline>()])
import 'collection_member_manager_impl_test.mocks.dart';

void main() {
  group('$CollectionMemberManagerImpl', () {
    const testOptions = IteratorFetchOptions(limit: 3);
    const testUsername = 'test-user';

    final mockOnline = MockCollectionMemberManagerOnline();

    late CollectionMemberManagerImpl sut;

    setUp(() {
      reset(mockOnline);

      sut = CollectionMemberManagerImpl(mockOnline);
    });

    test('list calls list on online', () async {
      const testResponse = IteratorListResponse<CollectionMember>(
        data: [],
        isDone: true,
        iterator: 'iterator',
      );
      when(mockOnline.list(any)).thenReturnAsync(testResponse);

      final result = await sut.list(testOptions);

      expect(result, same(testResponse));

      verify(mockOnline.list(testOptions)).called(1);
    });

    test('remove calls remove on online', () async {
      await sut.remove(testUsername);

      verify(mockOnline.remove(testUsername)).called(1);
    });

    test('leave calls leave on online', () async {
      await sut.leave();

      verify(mockOnline.leave()).called(1);
    });

    test('modifyAccessLevel calls modifyAccessLevel on online', () async {
      const testLevel = CollectionAccessLevel.admin;
      await sut.modifyAccessLevel(testUsername, testLevel);

      verify(mockOnline.modifyAccessLevel(testUsername, testLevel)).called(1);
    });
  });
}
