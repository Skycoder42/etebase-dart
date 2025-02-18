import 'dart:convert';
import 'dart:typed_data';

import 'package:etebase/src/api/exceptions/api_missuse.dart';
import 'package:etebase/src/api/models/etebase_item_metadata.dart';
import 'package:etebase/src/impl/codec/message_pack_converter.dart';
import 'package:etebase/src/impl/crypto/collection_item_crypto_manager.dart';
import 'package:etebase/src/impl/crypto/crypto_service.dart';
import 'package:etebase/src/impl/crypto/crypto_utils.dart';
import 'package:etebase/src/impl/crypto/minimal_collection_crypto_manager.dart';
import 'package:etebase/src/impl/encrypted_models/cached/cached_chunk.dart';
import 'package:etebase/src/impl/encrypted_models/cached/cached_collection_item.dart';
import 'package:etebase/src/impl/encrypted_models/cached/cached_revision.dart';
import 'package:etebase/src/impl/encrypted_models/chunk.dart';
import 'package:etebase/src/impl/encrypted_models/encrypted_collection_item.dart';
import 'package:etebase/src/impl/encrypted_models/encrypted_revision.dart';
import 'package:etebase/src/impl/managers/client.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

// ignore: directives_ordering
import '../../test_helpers.dart';
import '../crypto/crypto_mocks.dart';
@GenerateNiceMocks([
  MockSpec<Client>(),
  MockSpec<EncryptedRevision>(),
  MockSpec<MinimalCollectionCryptoManager>(),
  MockSpec<CollectionItemCryptoManager>(),
  MockSpec<MessagePackConverter>(),
  MockSpec<CryptoService>(),
])
import 'encrypted_collection_item_test.mocks.dart';

class FakeEtebaseItemMetadata extends Fake implements EtebaseItemMetadata {}

void main() {
  group('$EncryptedCollectionItem', () {
    final mockClient = MockClient();
    final mockRevision = MockEncryptedRevision();
    final mockParentCm = MockMinimalCollectionCryptoManager();
    final mockItemCm = MockCollectionItemCryptoManager();
    final mockMessagePackConverter = MockMessagePackConverter();
    final mockCryptoService = MockCryptoService();

    setUp(() async {
      reset(mockClient);
      reset(mockRevision);
      reset(mockParentCm);
      reset(mockItemCm);
      reset(mockMessagePackConverter);
      reset(mockCryptoService);

      when(
        mockClient.createEncryptedRevision(
          cryptoManager: anyNamed('cryptoManager'),
          additionalData: anyNamed('additionalData'),
          meta: anyNamed('meta'),
          content: anyNamed('content'),
        ),
      ).thenReturnAsync(mockRevision);

      when(mockClient.converter).thenReturn(mockMessagePackConverter);

      when(mockClient.crypto).thenReturn(mockCryptoService);
      when(
        mockCryptoService.createCollectionItemCryptoManager(
          any,
          version: anyNamed('version'),
        ),
      ).thenReturn(mockItemCm);
    });

    group('create', () {
      test('constructs new instance', () async {
        const testMeta = EtebaseItemMetadata(name: 'test-name');
        final testContent = Uint8List.fromList([4, 3, 1, 4, 51]);

        final testUid = Uint8List.fromList([23, 4, 2, 44]);
        const testUid64 = 'test-uid';
        final testKey = FakeSecureKey(13);

        when(mockCryptoService.randomBytes(any)).thenReturn(testUid);
        when(mockMessagePackConverter.base64Encode(any)).thenReturn(testUid64);
        when(mockParentCm.deriveSubkey(any)).thenReturn(testKey);

        final (item, cm) = await EncryptedCollectionItem.create(
          mockClient,
          mockParentCm,
          testMeta,
          testContent,
        );

        expect(item.uid, testUid64);
        expect(item.version, CryptoUtils.currentVersion);
        expect(item.content, same(mockRevision));
        expect(item.lastEtag, isNull);

        expect(cm, same(mockItemCm));

        verifyInOrder([
          mockCryptoService.randomBytes(24),
          mockMessagePackConverter.base64Encode(testUid),
          mockParentCm.deriveSubkey(utf8.encode(testUid64)),
          mockCryptoService.createCollectionItemCryptoManager(testKey),
          mockClient.createEncryptedRevision(
            cryptoManager: mockItemCm,
            additionalData: utf8.encode(testUid64),
            meta: testMeta,
            content: testContent,
          ),
        ]);
        verifyNever(mockItemCm.dispose());
      });

      test('disposes item cm if creating the revision fails', () async {
        final testException = Exception('test-exception');

        when(
          mockClient.createEncryptedRevision(
            cryptoManager: anyNamed('cryptoManager'),
            additionalData: anyNamed('additionalData'),
            meta: anyNamed('meta'),
            content: anyNamed('content'),
          ),
        ).thenThrow(testException);

        expect(
          () => EncryptedCollectionItem.create(
            mockClient,
            mockParentCm,
            const EtebaseItemMetadata(),
            Uint8List(0),
          ),
          throwsA(testException),
        );

        verify(mockItemCm.dispose());
      });
    });

    test('fromJson/toJson correctly decodes/encodes data from/to JSON', () {
      const testItemUid = 'test-uid';
      const testRevUid = 'test-rev-uid';
      const testVersion = 42;

      final testJsonData = {
        'uid': testItemUid,
        'version': testVersion,
        'encryptionKey': Uint8List.fromList([4, 1, 4, 3, 1]),
        'content': {
          'uid': testRevUid,
          'meta': Uint8List(0),
          'chunks': <dynamic>[],
          'deleted': false,
        },
        'etag': 'test-etag',
      };

      final sut = EncryptedCollectionItem.fromJson(testJsonData);

      expect(sut.uid, testItemUid);
      expect(sut.version, testVersion);
      // key cannot be accessed on purpose
      expect(sut.content.uid, testRevUid);
      // etag is overwritten by content uid
      expect(sut.lastEtag, testRevUid);

      final json = sut.toJson();

      expect(json, {...testJsonData, 'etag': testRevUid});
    });

    test('cacheLoad/cacheSave correctly loads/saves data from/to cache', () {
      // revision
      final testRevUid = Uint8List.fromList([9, 44, 1]);
      final testRevisionCacheData = CachedRevision(
        uid: testRevUid,
        meta: Uint8List(0),
        deleted: false,
        chunks: [
          CachedChunk(Uint8List.fromList([2]), Uint8List.fromList([4])),
        ],
      );
      final testEncodedContent = Uint8List.fromList([4, 1, 44, 12]);
      // item
      final testItemUid = Uint8List.fromList([4, 3, 1, 2, 3]);
      const testVersion = 42;
      final testEtag = Uint8List.fromList([5, 1, 1, 3, 1]);
      final testItemCacheData = CachedCollectionItem(
        uid: testItemUid,
        version: testVersion,
        encryptionKey: Uint8List.fromList([4, 1, 4, 3, 1]),
        etag: testEtag,
        revision: testEncodedContent,
      );
      final testEncodedItem = Uint8List.fromList([5, 12, 4, 121, 41]);

      when(mockMessagePackConverter.base64Encode(any)).thenAnswer(
        (i) => base64.encode(i.positionalArguments.single as Uint8List),
      );
      when(mockMessagePackConverter.base64Decode(any)).thenAnswer(
        (i) => base64.decode(i.positionalArguments.single as String),
      );

      provideDummy(testItemCacheData);
      when(
        mockMessagePackConverter.decode<CachedCollectionItem>(testEncodedItem),
      ).thenReturn(testItemCacheData);
      provideDummy(testRevisionCacheData);
      when(
        mockMessagePackConverter.decode<CachedRevision>(testEncodedContent),
      ).thenReturn(testRevisionCacheData);

      final sut = EncryptedCollectionItem.cacheLoad(
        mockClient,
        testEncodedItem,
      );

      expect(sut.uid, base64.encode(testItemUid));
      expect(sut.version, testVersion);
      // key cannot be accessed on purpose
      expect(sut.content.uid, base64.encode(testRevUid));
      expect(sut.lastEtag, base64.encode(testEtag));

      verifyInOrder([
        mockMessagePackConverter.decode<CachedCollectionItem>(testEncodedItem),
        mockMessagePackConverter.decode<CachedRevision>(testEncodedContent),
      ]);
      clearInteractions(mockMessagePackConverter);

      // with content
      when(
        mockMessagePackConverter.encode(testItemCacheData),
      ).thenReturn(testEncodedItem);
      when(
        mockMessagePackConverter.encode(testRevisionCacheData),
      ).thenReturn(testEncodedContent);

      final cachedWithContent = sut.cacheSave(mockClient, saveContent: true);
      expect(cachedWithContent, testEncodedItem);

      verifyInOrder([
        mockMessagePackConverter.encode(testRevisionCacheData),
        mockMessagePackConverter.encode(testItemCacheData),
      ]);
      clearInteractions(mockMessagePackConverter);

      // without content
      final testRevisionWithoutContentCacheData = CachedRevision(
        uid: testRevUid,
        meta: Uint8List(0),
        deleted: false,
        chunks: [
          CachedChunk(Uint8List.fromList([2])),
        ],
      );
      when(
        mockMessagePackConverter.encode(testRevisionWithoutContentCacheData),
      ).thenReturn(testEncodedContent);

      final cachedWithoutContent = sut.cacheSave(
        mockClient,
        saveContent: false,
      );
      expect(cachedWithoutContent, testEncodedItem);

      verifyInOrder([
        mockMessagePackConverter.encode(testRevisionWithoutContentCacheData),
        mockMessagePackConverter.encode(testItemCacheData),
      ]);
      clearInteractions(mockMessagePackConverter);
    });

    group('members', () {
      const testMeta = EtebaseItemMetadata(name: 'test-name');
      final testContent = Uint8List.fromList([6, 6, 3, 2, 33, 2]);
      final testUid = Uint8List.fromList([9, 2, 5, 12]);
      const testUid64 = 'test-uid';
      final testUidUtf8 = utf8.encode(testUid64);
      final testKey = FakeSecureKey(45);

      late EncryptedCollectionItem sut;

      setUp(() async {
        when(mockCryptoService.randomBytes(any)).thenReturn(testUid);
        when(mockMessagePackConverter.base64Encode(any)).thenReturn(testUid64);
        when(mockParentCm.deriveSubkey(any)).thenReturn(testKey);

        final (item, _) = await EncryptedCollectionItem.create(
          mockClient,
          mockParentCm,
          testMeta,
          testContent,
        );
        sut = item;
      });

      test('properties return correct default values', () {
        const revUid = 'revision-uid';

        when(mockRevision.uid).thenReturn(revUid);
        when(mockRevision.deleted).thenReturn(true);

        expect(sut.uid, testUid64);
        expect(sut.version, CryptoUtils.currentVersion);
        expect(sut.content, same(mockRevision));
        expect(sut.isDeleted, isTrue);
        expect(sut.etag, revUid);
        expect(sut.lastEtag, isNull);
        expect(sut.isMissingContent, isFalse);
        expect(sut.pendingChunks, isEmpty);
        expect(sut.missingChunks, isEmpty);

        verifyInOrder([
          mockRevision.deleted,
          mockRevision.uid,
          mockRevision.chunks,
          mockRevision.chunks,
          mockRevision.chunks,
        ]);
      });

      test('chunk getters report correct data', () {
        final c1 = Chunk('c1', Uint8List.fromList([1]));
        final c2 = Chunk('c2', Uint8List.fromList([2]));
        const c3 = Chunk('c3', null);
        final c4 = Chunk('c4', Uint8List.fromList([4]));

        when(mockRevision.chunks).thenReturn([c1, c2]);

        expect(sut.isMissingContent, isFalse);
        expect(sut.pendingChunks, [c1, c2]);
        expect(sut.missingChunks, isEmpty);

        when(mockRevision.chunks).thenReturn([c1, c3, c4]);

        expect(sut.isMissingContent, isTrue);
        expect(sut.pendingChunks, [c1, c3, c4]);
        expect(sut.missingChunks, [c3]);
      });

      test('cloneWithRevision creates a copy with a different revision', () {
        final otherRevision = MockEncryptedRevision();
        const otherUid = 'other-uid';

        when(otherRevision.uid).thenReturn(otherUid);

        final result = sut.cloneWithRevision(otherRevision);

        expect(result.uid, testUid64);
        expect(result.version, CryptoUtils.currentVersion);
        expect(result.content, same(otherRevision));
        expect(result.lastEtag, otherUid);
      });

      test('markSaved updates lastEtag to the current revision uid', () {
        const revUid = 'other-uid';

        when(mockRevision.uid).thenReturn(revUid);

        expect(sut.lastEtag, isNull);

        sut.markSaved();

        expect(sut.lastEtag, revUid);
      });

      group('updateChunk', () {
        test('replaces chunk in revision with new chunk', () {
          final c1 = Chunk('c1', Uint8List.fromList([1]));
          final c2Old = Chunk('c2', Uint8List.fromList([2]));
          final c3 = Chunk('c3', Uint8List.fromList([3]));
          final c2New = Chunk('c2', Uint8List.fromList([4]));
          final testChunks = [c1, c2Old, c3];

          when(mockRevision.chunks).thenReturn(testChunks);

          sut.updateChunk(c2New);

          expect(testChunks, [c1, c2New, c3]);
        });

        test('throws ApiMissuse if an unrelated chunk is updated', () {
          final c1 = Chunk('c1', Uint8List.fromList([1]));
          final c2 = Chunk('c2', Uint8List.fromList([2]));
          final c3 = Chunk('c3', Uint8List.fromList([3]));
          final c4 = Chunk('c4', Uint8List.fromList([4]));
          final testChunks = [c1, c2, c3];

          when(mockRevision.chunks).thenReturn(testChunks);

          expect(() => sut.updateChunk(c4), throwsA(isA<ApiMissuse>()));
        });

        test(
          'verify calls revision.verify with item uid as additional data',
          () async {
            await sut.verify(mockClient, mockItemCm);

            verify(mockRevision.verify(mockClient, mockItemCm, testUidUtf8));
          },
        );
      });

      group('setMeta', () {
        test('updates revision if it is already locally changed', () async {
          const newMeta = EtebaseItemMetadata(name: 'new-meta');

          await sut.setMeta(mockClient, mockItemCm, newMeta);

          verify(
            mockRevision.setMeta(mockClient, mockItemCm, testUidUtf8, newMeta),
          );
          verifyNever(mockRevision.clone());
        });

        test('clones revision if it has not been changed yet', () async {
          const newMeta = EtebaseItemMetadata(name: 'new-meta');
          final newRevision = MockEncryptedRevision();

          sut.markSaved();

          when(mockRevision.clone()).thenReturn(newRevision);

          await sut.setMeta(mockClient, mockItemCm, newMeta);

          verifyInOrder([
            mockRevision.clone(),
            newRevision.setMeta(mockClient, mockItemCm, testUidUtf8, newMeta),
          ]);
          verifyNever(mockRevision.setMeta(any, any, any, any));
        });

        test('can handle custom metadata classes', () async {
          final otherMeta = FakeEtebaseItemMetadata();

          await sut.setMeta(mockClient, mockItemCm, otherMeta);

          verify(
            mockRevision.setMeta(
              mockClient,
              mockItemCm,
              testUidUtf8,
              otherMeta,
            ),
          );
        });
      });

      group('getMeta', () {
        test(
          'verifies the data and returns the metadata from the revision',
          () async {
            when(mockRevision.getMeta(any, any, any)).thenReturnAsync(testMeta);

            final result = await sut.getMeta(mockClient, mockItemCm);

            expect(result, testMeta);

            verifyInOrder([
              mockRevision.verify(mockClient, mockItemCm, testUidUtf8),
              mockRevision.getMeta(mockClient, mockItemCm, testUidUtf8),
            ]);
          },
        );

        test('can handle custom metadata classes', () async {
          final otherMeta = FakeEtebaseItemMetadata();

          when(
            mockRevision.getMeta<FakeEtebaseItemMetadata>(any, any, any),
          ).thenReturnAsync(otherMeta);

          final result = await sut.getMeta<FakeEtebaseItemMetadata>(
            mockClient,
            mockItemCm,
          );

          expect(result, otherMeta);
        });
      });

      group('setContent', () {
        test('updates revision if it is already locally changed', () async {
          final newContent = Uint8List.fromList([6, 4, 5, 6, 2, 1, 1]);

          await sut.setContent(mockClient, mockItemCm, newContent);

          verify(
            mockRevision.setContent(
              mockClient,
              mockItemCm,
              additionalData: testUidUtf8,
              content: newContent,
            ),
          );
          verifyNever(mockRevision.clone());
        });

        test('clones revision if it has not been changed yet', () async {
          final newContent = Uint8List.fromList([6, 4, 5, 6, 2, 1, 1]);
          final newRevision = MockEncryptedRevision();

          sut.markSaved();

          when(mockRevision.clone()).thenReturn(newRevision);

          await sut.setContent(mockClient, mockItemCm, newContent);

          verifyInOrder([
            mockRevision.clone(),
            newRevision.setContent(
              mockClient,
              mockItemCm,
              additionalData: testUidUtf8,
              content: newContent,
            ),
          ]);
          verifyNever(
            mockRevision.setContent(
              any,
              any,
              additionalData: anyNamed('additionalData'),
              content: anyNamed('content'),
            ),
          );
        });
      });

      test('getContent', () async {
        when(mockRevision.getContent(any, any)).thenReturnAsync(testContent);

        final result = await sut.getContent(mockClient, mockItemCm);

        expect(result, testContent);

        verifyInOrder([
          mockRevision.verify(mockClient, mockItemCm, testUidUtf8),
          mockRevision.getContent(mockClient, mockItemCm),
        ]);
      });

      group('delete', () {
        test('updates revision if it is already locally changed', () async {
          await sut.delete(mockClient, mockItemCm, preserveContent: true);

          verify(
            mockRevision.delete(
              mockClient,
              mockItemCm,
              testUidUtf8,
              preserveContent: true,
            ),
          );
          verifyNever(mockRevision.clone());
        });

        test('clones revision if it has not been changed yet', () async {
          final newRevision = MockEncryptedRevision();

          sut.markSaved();

          when(mockRevision.clone()).thenReturn(newRevision);

          await sut.delete(mockClient, mockItemCm, preserveContent: false);

          verifyInOrder([
            mockRevision.clone(),
            newRevision.delete(
              mockClient,
              mockItemCm,
              testUidUtf8,
              preserveContent: false,
            ),
          ]);
          verifyNever(
            mockRevision.delete(
              any,
              any,
              any,
              preserveContent: anyNamed('preserveContent'),
            ),
          );
        });

        group('withCm', () {
          test(
            'execute the callback with the derived item crypto manager',
            () async {
              final cb = expectAsync1<bool, CollectionItemCryptoManager>((cm) {
                expect(cm, same(mockItemCm));
                return true;
              });

              final result = await sut.withCm(mockClient, mockParentCm, cb);
              expect(result, isTrue);

              verifyInOrder([
                mockCryptoService.createCollectionItemCryptoManager(testKey),
                mockItemCm.dispose(),
              ]);
            },
          );

          test('disposes item cm if callback throws', () async {
            final testException = Exception('test');
            final cb = expectAsync1<bool, CollectionItemCryptoManager>(
              (cm) => throw testException,
            );

            await expectLater(
              () => sut.withCm(mockClient, mockParentCm, cb),
              throwsA(testException),
            );

            verifyInOrder([
              mockCryptoService.createCollectionItemCryptoManager(testKey),
              mockItemCm.dispose(),
            ]);
          });
        });

        test('getCryptoManager returns item manager', () {
          final result = sut.getCryptoManager(mockClient, mockParentCm);
          expect(result, same(mockItemCm));

          verify(mockCryptoService.createCollectionItemCryptoManager(testKey));
          verifyNever(mockItemCm.dispose());
        });
      });
    });
  });
}
