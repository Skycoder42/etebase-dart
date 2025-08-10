import 'dart:typed_data';

import 'package:dart_test_tools/test.dart';
import 'package:etebase/src/api/exceptions/not_found.dart';
import 'package:etebase/src/api/managers/collection_manager.dart';
import 'package:etebase/src/api/managers/item_manager.dart';
import 'package:etebase/src/api/models/collection.dart';
import 'package:etebase/src/api/models/item.dart';
import 'package:etebase/src/impl/cache/hive_cache.dart';
import 'package:etebase/src/impl/managers/account_impl.dart';
import 'package:etebase/src/impl/managers/client_impl.dart';
import 'package:hive_ce/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sodium/sodium.dart';
import 'package:test/test.dart';

import '../../test_helpers.dart';

@GenerateNiceMocks([
  MockSpec<HiveInterface>(),
  // ignore: strict_raw_type
  MockSpec<LazyBox>(),
  MockSpec<ClientImpl>(),
  MockSpec<AccountImpl>(),
  MockSpec<CollectionManager>(),
  MockSpec<ItemManager>(),
])
import 'hive_cache_test.mocks.dart';

class FakeSecureKey extends Fake implements SecureKey {}

class FakeCollection extends Fake implements Collection {
  @override
  final String uid;

  FakeCollection(this.uid);
}

void main() {
  group('$HiveCache', () {
    const testUserName = 'test-user';
    const testEncodedUserName = 'dGVzdC11c2Vy';

    final mockClient = MockClientImpl();
    final mockHive = MockHiveInterface();
    final mockMetaBox = MockLazyBox<String>();
    final mockCollectionBox = MockLazyBox<Uint8List>();

    late HiveCache sut;

    setUp(() async {
      reset(mockClient);
      reset(mockHive);
      reset(mockMetaBox);
      reset(mockCollectionBox);

      when(
        mockHive.openLazyBox<String>('$testEncodedUserName.meta'),
      ).thenReturnAsync(mockMetaBox);
      when(
        mockHive.openLazyBox<Uint8List>('$testEncodedUserName.collection'),
      ).thenReturnAsync(mockCollectionBox);

      sut = HiveCache(mockClient, mockHive, testUserName);

      await sut.initialize();
      clearInteractions(mockHive);
    });

    test('initialize opens account and collection box', () async {
      sut = HiveCache(mockClient, mockHive, testUserName);
      await sut.initialize();

      verify(mockHive.openLazyBox<String>('$testEncodedUserName.meta'));
      verify(
        mockHive.openLazyBox<Uint8List?>('$testEncodedUserName.collection'),
      );
    });

    group('dispose', () {
      test('closes account and collection box', () async {
        await sut.dispose();

        verify(mockMetaBox.close());
        verify(mockCollectionBox.close());
      });

      test('closes open item boxes', () async {
        const itemBox1Id = '$testEncodedUserName.collection.col1';
        const itemBox2Id = '$testEncodedUserName.collection.col2';
        const itemBox3Id = '$testEncodedUserName.collection.col3';

        final itemBox1 = MockLazyBox<Uint8List>();
        final itemBox3 = MockLazyBox<Uint8List>();

        when(mockCollectionBox.isOpen).thenReturn(true);
        when(mockCollectionBox.keys).thenReturn(['col1', 'col2', 'col3']);
        when(mockHive.isBoxOpen(any)).thenReturn(true);
        when(mockHive.isBoxOpen(itemBox2Id)).thenReturn(false);
        when(mockHive.lazyBox<Uint8List>(itemBox1Id)).thenReturn(itemBox1);
        when(mockHive.lazyBox<Uint8List>(itemBox3Id)).thenReturn(itemBox3);

        await sut.dispose();

        verifyInOrder([
          mockCollectionBox.isOpen,
          mockCollectionBox.keys,
          mockHive.isBoxOpen(itemBox1Id),
          mockHive.lazyBox<Uint8List>(itemBox1Id),
          itemBox1.close(),
          mockHive.isBoxOpen(itemBox2Id),
          mockHive.isBoxOpen(itemBox3Id),
          mockHive.lazyBox<Uint8List>(itemBox3Id),
          itemBox3.close(),
        ]);
      });
    });

    group('clearUser', () {
      test(
        'deletes account and collection box if not reinitializing',
        () async {
          const accountBoxName = 'accountBox';
          const collectionBoxName = 'collectionBox';

          when(mockMetaBox.name).thenReturn(accountBoxName);
          when(mockMetaBox.isOpen).thenReturn(true);
          when(mockCollectionBox.name).thenReturn(collectionBoxName);
          when(mockCollectionBox.isOpen).thenReturn(true);

          await sut.clearUser();

          verifyInOrder([
            mockMetaBox.isOpen,
            mockMetaBox.close(),
            mockMetaBox.name,
            mockHive.deleteBoxFromDisk(accountBoxName),
          ]);
          verifyInOrder([
            mockCollectionBox.isOpen,
            mockCollectionBox.close(),
            mockCollectionBox.name,
            mockHive.deleteBoxFromDisk(collectionBoxName),
          ]);
        },
      );

      test(
        'deletes account and collection box without closing if not open',
        () async {
          const accountBoxName = 'accountBox';
          const collectionBoxName = 'collectionBox';

          when(mockMetaBox.name).thenReturn(accountBoxName);
          when(mockMetaBox.isOpen).thenReturn(false);
          when(mockCollectionBox.name).thenReturn(collectionBoxName);
          when(mockCollectionBox.isOpen).thenReturn(false);

          await sut.clearUser();

          verifyInOrder([
            mockMetaBox.isOpen,
            mockMetaBox.name,
            mockHive.deleteBoxFromDisk(accountBoxName),
          ]);
          verifyNoMoreInteractions(mockMetaBox);
          verifyInOrder([
            mockCollectionBox.isOpen,
            mockCollectionBox.isOpen,
            mockCollectionBox.name,
            mockHive.deleteBoxFromDisk(collectionBoxName),
          ]);
          verifyNoMoreInteractions(mockCollectionBox);
        },
      );

      test('clears account and collection box if reinitializing', () async {
        await sut.clearUser(reInitialize: true);

        verify(mockMetaBox.clear());
        verify(mockCollectionBox.clear());
      });

      test('delete all item boxes', () async {
        const itemBox1Id = '$testEncodedUserName.collection.col1';
        const itemBox2Id = '$testEncodedUserName.collection.col2';
        const itemBox3Id = '$testEncodedUserName.collection.col3';

        final itemBox1 = MockLazyBox<Uint8List>();
        final itemBox3 = MockLazyBox<Uint8List>();

        when(mockCollectionBox.isOpen).thenReturn(true);
        when(mockCollectionBox.keys).thenReturn(['col1', 'col2', 'col3']);
        when(mockHive.isBoxOpen(any)).thenReturn(true);
        when(mockHive.isBoxOpen(itemBox2Id)).thenReturn(false);
        when(mockHive.lazyBox<Uint8List>(itemBox1Id)).thenReturn(itemBox1);
        when(mockHive.lazyBox<Uint8List>(itemBox3Id)).thenReturn(itemBox3);

        await sut.clearUser(reInitialize: true);

        verifyInOrder([
          mockCollectionBox.isOpen,
          mockCollectionBox.keys,
          mockHive.isBoxOpen(itemBox1Id),
          mockHive.lazyBox<Uint8List>(itemBox1Id),
          itemBox1.close(),
          mockHive.isBoxOpen(itemBox2Id),
          mockHive.deleteBoxFromDisk(itemBox2Id),
          mockHive.isBoxOpen(itemBox3Id),
          mockHive.lazyBox<Uint8List>(itemBox3Id),
          itemBox3.close(),
          // deferred at the end because of Future.wait
          mockHive.deleteBoxFromDisk(itemBox1Id),
          mockHive.deleteBoxFromDisk(itemBox3Id),
        ]);
      });
    });

    group('account', () {
      const accountData = 'account-data';
      final mockAccount = MockAccountImpl();

      setUp(() {
        reset(mockAccount);
      });

      test(
        'hasAccount returns true if account box has account data key',
        () async {
          when(mockMetaBox.containsKey(any)).thenReturn(true);

          expect(await sut.hasAccount, isTrue);

          verify(mockMetaBox.containsKey('account.data'));
        },
      );

      testData(
        'saveAccount saves account to account box',
        [null, FakeSecureKey()],
        (fixture) async {
          when(mockAccount.save(any)).thenReturnAsync(accountData);

          await sut.saveAccount(mockAccount, fixture);

          verifyInOrder([
            mockAccount.save(fixture),
            mockMetaBox.put('account.data', accountData),
          ]);
        },
      );

      group('loadAccount', () {
        testData('returns account data if it exists', [null, FakeSecureKey()], (
          fixture,
        ) async {
          when(mockMetaBox.get(any)).thenReturnAsync(accountData);
          when(
            mockClient.restoreAccount(any, any),
          ).thenReturnAsync(mockAccount);

          final result = await sut.loadAccount(fixture);
          expect(result, same(mockAccount));

          verifyInOrder([
            mockMetaBox.get('account.data'),
            mockClient.restoreAccount(accountData, fixture),
          ]);
        });

        test('throws if account data does not exists', () {
          expect(() => sut.loadAccount(), throwsA(isA<NotFound>()));
        });
      });
    });

    group('stoken', () {
      const testStoken = 's-token';

      test('hasStoken returns true if account box has stoken key', () async {
        when(mockMetaBox.containsKey(any)).thenReturn(true);

        expect(await sut.hasStoken, isTrue);

        verify(mockMetaBox.containsKey('account.stoken'));
      });

      test('saveStoken puts stoken into account box', () async {
        await sut.saveStoken(testStoken);

        verify(mockMetaBox.put('account.stoken', testStoken));
      });

      group('loadStoken', () {
        test('returns stoken data if it exists', () async {
          when(mockMetaBox.get(any)).thenReturnAsync(testStoken);

          final result = await sut.loadStoken();
          expect(result, testStoken);

          verify(mockMetaBox.get('account.stoken'));
        });

        test('throws if stoken does not exists', () {
          expect(() => sut.loadStoken(), throwsA(isA<NotFound>()));
        });
      });
    });

    group('collectionStoken', () {
      const testColUid = 'test-col';
      const testStoken = 'teSt-token';

      test(
        'persistedCollectionStokenUids returns all collection stoken keys',
        () {
          when(mockMetaBox.keys).thenReturn([
            'fake-key-1',
            'col.stoken.col1',
            'col.stoken',
            'col.stoken.col2',
            '',
            'col.stoken.col3',
          ]);

          expect(
            sut.persistedCollectionStokenUids,
            emitsInAnyOrder(['col1', 'col2', 'col3', emitsDone]),
          );
        },
      );

      test('collectionSaveStoken puts stoken in account box', () async {
        await sut.collectionSaveStoken(testColUid, testStoken);

        verify(mockMetaBox.put('col.stoken.$testColUid', testStoken));
      });

      group('collectionLoadStoken', () {
        test('returns stoken data if it exists', () async {
          when(mockMetaBox.get(any)).thenReturnAsync(testStoken);

          final result = await sut.collectionLoadStoken(testColUid);
          expect(result, testStoken);

          verify(mockMetaBox.get('col.stoken.$testColUid'));
        });

        test('throws if stoken does not exists', () {
          expect(
            () => sut.collectionLoadStoken('id'),
            throwsA(isA<NotFound>()),
          );
        });
      });
    });

    group('collections', () {
      const testColUid = 'col-uid';
      final testCollection = FakeCollection(testColUid);
      final testColData = Uint8List.fromList([2, 3, 2]);
      final mockColMgr = MockCollectionManager();

      setUp(() {
        reset(mockColMgr);
      });

      test('persistedCollectionUids returns all keys in collection box', () {
        when(mockCollectionBox.keys).thenReturn(['col1', 'col2', 'col3']);

        expect(
          sut.persistedCollectionUids,
          emitsInAnyOrder(['col1', 'col2', 'col3', emitsDone]),
        );
      });

      testData(
        'collectionSet persists collection in collection box',
        [false, true],
        (fixture) async {
          when(
            mockColMgr.cacheSave(any, saveContent: anyNamed('saveContent')),
          ).thenReturn(testColData);

          await sut.collectionSet(
            mockColMgr,
            testCollection,
            saveContent: fixture,
          );

          verifyInOrder([
            mockColMgr.cacheSave(testCollection, saveContent: fixture),
            mockCollectionBox.put(testColUid, testColData),
          ]);
        },
      );

      group('collectionUnset', () {
        test('deletes references in all boxes', () async {
          const itemBoxName = '$testEncodedUserName.collection.$testColUid';
          final mockItemBox = MockLazyBox<Uint8List>();

          when(mockHive.isBoxOpen(any)).thenReturn(true);
          when(mockHive.lazyBox<Uint8List>(any)).thenReturn(mockItemBox);

          await sut.collectionUnset(testColUid);

          verify(mockMetaBox.delete('col.stoken.$testColUid'));
          verify(mockCollectionBox.delete(testColUid));
          verifyInOrder([
            mockHive.isBoxOpen(itemBoxName),
            mockHive.lazyBox<Uint8List>(itemBoxName),
            mockItemBox.close(),
            mockHive.deleteBoxFromDisk(itemBoxName),
          ]);
        });

        test('does not delete item box if it does not exist', () async {
          const itemBoxName = '$testEncodedUserName.collection.$testColUid';

          when(mockHive.isBoxOpen(any)).thenReturn(false);

          await sut.collectionUnset(testColUid);

          verify(mockMetaBox.delete('col.stoken.$testColUid'));
          verify(mockCollectionBox.delete(testColUid));
          verifyInOrder([
            mockHive.isBoxOpen(itemBoxName),
            mockHive.deleteBoxFromDisk(itemBoxName),
          ]);
          verifyNoMoreInteractions(mockHive);
        });
      });

      group('collectionGet', () {
        test('returns loaded collection if it exists', () async {
          when(mockCollectionBox.get(any)).thenReturnAsync(testColData);
          when(mockColMgr.cacheLoad(any)).thenReturn(testCollection);

          final result = await sut.collectionGet(mockColMgr, testColUid);
          expect(result, same(testCollection));

          verifyInOrder([
            mockCollectionBox.get(testColUid),
            mockColMgr.cacheLoad(testColData),
          ]);
        });

        test('throws if collection does not exist', () {
          expect(
            () => sut.collectionGet(mockColMgr, testColUid),
            throwsA(isA<NotFound>()),
          );
        });
      });
    });

    group('items', () {
      const testColUid = 'test-col';
      const testItemBoxName = '$testEncodedUserName.collection.$testColUid';
      const testItemUid = 'test-item';
      final Item testItem = FakeCollection(testItemUid);
      final testItemData = Uint8List.fromList([3, 3, 4]);

      final mockItemMgr = MockItemManager();
      final mockItemBox = MockLazyBox<Uint8List>();

      setUp(() {
        reset(mockItemMgr);
        reset(mockItemBox);

        when(mockHive.openLazyBox<Uint8List>(any)).thenReturnAsync(mockItemBox);
        when(mockHive.lazyBox<Uint8List>(any)).thenReturn(mockItemBox);
      });

      group('persistedItemUids', () {
        test('returns empty list if box does not exist', () async {
          await expectLater(sut.persistedItemUids(testColUid), emitsDone);

          verifyInOrder([
            mockHive.isBoxOpen(testItemBoxName),
            mockHive.boxExists(testItemBoxName),
          ]);
          verifyNoMoreInteractions(mockHive);
        });

        test('returns all keys in already opened item box', () async {
          when(mockHive.isBoxOpen(any)).thenReturn(true);
          when(mockItemBox.keys).thenReturn(['item1', 'item2']);

          await expectLater(
            sut.persistedItemUids(testColUid),
            emitsInAnyOrder(['item1', 'item2', emitsDone]),
          );

          verifyInOrder([
            mockHive.isBoxOpen(testItemBoxName),
            mockHive.lazyBox<Uint8List>(testItemBoxName),
            mockItemBox.keys,
          ]);
          verifyNoMoreInteractions(mockHive);
        });

        test(
          'returns all keys from newly opened box if not already open',
          () async {
            when(mockHive.boxExists(any)).thenReturnAsync(true);
            when(mockItemBox.keys).thenReturn(['item1', 'item2']);

            await expectLater(
              sut.persistedItemUids(testColUid),
              emitsInAnyOrder(['item1', 'item2', emitsDone]),
            );

            verifyInOrder([
              mockHive.isBoxOpen(testItemBoxName),
              mockHive.boxExists(testItemBoxName),
              mockHive.openLazyBox<Uint8List>(testItemBoxName),
              mockItemBox.keys,
            ]);
            verifyNoMoreInteractions(mockHive);
          },
        );
      });

      group('itemSet', () {
        testData('persists item in open box', [false, true], (fixture) async {
          when(mockHive.isBoxOpen(any)).thenReturn(true);
          when(
            mockItemMgr.cacheSave(any, saveContent: anyNamed('saveContent')),
          ).thenReturn(testItemData);

          await sut.itemSet(
            mockItemMgr,
            testColUid,
            testItem,
            saveContent: fixture,
          );

          verifyInOrder([
            mockHive.isBoxOpen(testItemBoxName),
            mockHive.lazyBox<Uint8List>(testItemBoxName),
            mockItemMgr.cacheSave(testItem, saveContent: fixture),
            mockItemBox.put(testItemUid, testItemData),
          ]);
          verifyNoMoreInteractions(mockHive);
        });

        testData('persists item in newly opened box', [false, true], (
          fixture,
        ) async {
          when(
            mockItemMgr.cacheSave(any, saveContent: anyNamed('saveContent')),
          ).thenReturn(testItemData);

          await sut.itemSet(
            mockItemMgr,
            testColUid,
            testItem,
            saveContent: fixture,
          );

          verifyInOrder([
            mockHive.isBoxOpen(testItemBoxName),
            mockHive.openLazyBox<Uint8List>(testItemBoxName),
            mockItemMgr.cacheSave(testItem, saveContent: fixture),
            mockItemBox.put(testItemUid, testItemData),
          ]);
          verifyNoMoreInteractions(mockHive);
        });
      });

      group('itemUnset', () {
        test('deletes item from opened box', () async {
          when(mockHive.isBoxOpen(any)).thenReturn(true);

          await sut.itemUnset(testColUid, testItemUid);

          verifyInOrder([
            mockHive.isBoxOpen(testItemBoxName),
            mockHive.lazyBox<Uint8List>(testItemBoxName),
            mockItemBox.delete(testItemUid),
          ]);
          verifyNoMoreInteractions(mockHive);
        });

        test('deletes item from closed but existing box', () async {
          when(mockHive.boxExists(any)).thenReturnAsync(true);

          await sut.itemUnset(testColUid, testItemUid);

          verifyInOrder([
            mockHive.isBoxOpen(testItemBoxName),
            mockHive.boxExists(testItemBoxName),
            mockHive.openLazyBox<Uint8List>(testItemBoxName),
            mockItemBox.delete(testItemUid),
          ]);
          verifyNoMoreInteractions(mockHive);
        });

        test('does nothing if box does not exist', () async {
          await sut.itemUnset(testColUid, testItemUid);

          verifyInOrder([
            mockHive.isBoxOpen(testItemBoxName),
            mockHive.boxExists(testItemBoxName),
          ]);
          verifyNoMoreInteractions(mockHive);
        });
      });

      group('itemGet', () {
        test('restores item from opened box if it exists', () async {
          when(mockHive.isBoxOpen(any)).thenReturn(true);
          when(mockItemBox.get(any)).thenReturnAsync(testItemData);
          when(mockItemMgr.cacheLoad(any)).thenReturn(testItem);

          final result = await sut.itemGet(
            mockItemMgr,
            testColUid,
            testItemUid,
          );
          expect(result, same(testItem));

          verifyInOrder([
            mockHive.isBoxOpen(testItemBoxName),
            mockHive.lazyBox<Uint8List>(testItemBoxName),
            mockItemBox.get(testItemUid),
            mockItemMgr.cacheLoad(testItemData),
          ]);
          verifyNoMoreInteractions(mockHive);
        });

        test(
          'restores item from closed box and opens it if it exists',
          () async {
            when(mockHive.boxExists(any)).thenReturnAsync(true);
            when(mockItemBox.get(any)).thenReturnAsync(testItemData);
            when(mockItemMgr.cacheLoad(any)).thenReturn(testItem);

            final result = await sut.itemGet(
              mockItemMgr,
              testColUid,
              testItemUid,
            );
            expect(result, same(testItem));

            verifyInOrder([
              mockHive.isBoxOpen(testItemBoxName),
              mockHive.boxExists(testItemBoxName),
              mockHive.openLazyBox<Uint8List>(testItemBoxName),
              mockItemBox.get(testItemUid),
              mockItemMgr.cacheLoad(testItemData),
            ]);
            verifyNoMoreInteractions(mockHive);
          },
        );

        test('throws notFound if box exists but item does not', () async {
          when(mockHive.isBoxOpen(any)).thenReturn(true);

          await expectLater(
            () => sut.itemGet(mockItemMgr, testColUid, testItemUid),
            throwsA(isA<NotFound>()),
          );

          verifyInOrder([
            mockHive.isBoxOpen(testItemBoxName),
            mockHive.lazyBox<Uint8List>(testItemBoxName),
            mockItemBox.get(testItemUid),
          ]);
          verifyZeroInteractions(mockItemMgr);
        });

        test('throws notFound if box does not exist', () async {
          await expectLater(
            () => sut.itemGet(mockItemMgr, testColUid, testItemUid),
            throwsA(isA<NotFound>()),
          );

          verifyInOrder([
            mockHive.isBoxOpen(testItemBoxName),
            mockHive.boxExists(testItemBoxName),
          ]);
          verifyNoMoreInteractions(mockHive);
        });
      });
    });
  });
}
