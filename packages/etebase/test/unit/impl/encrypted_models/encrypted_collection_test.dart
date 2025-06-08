// ignore_for_file: discarded_futures

import 'dart:convert';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:dart_test_tools/test.dart';
import 'package:etebase/src/api/models/collection_access_level.dart';
import 'package:etebase/src/api/models/item_metadata.dart';
import 'package:etebase/src/impl/codec/message_pack_converter.dart';
import 'package:etebase/src/impl/crypto/account_crypto_manager.dart';
import 'package:etebase/src/impl/crypto/box_crypto_manager.dart';
import 'package:etebase/src/impl/crypto/collection_crypto_manager.dart';
import 'package:etebase/src/impl/crypto/collection_item_crypto_manager.dart';
import 'package:etebase/src/impl/crypto/crypto_service.dart';
import 'package:etebase/src/impl/crypto/crypto_utils.dart';
import 'package:etebase/src/impl/encrypted_models/cached/cached_chunk.dart';
import 'package:etebase/src/impl/encrypted_models/cached/cached_collection.dart';
import 'package:etebase/src/impl/encrypted_models/cached/cached_collection_item.dart';
import 'package:etebase/src/impl/encrypted_models/cached/cached_revision.dart';
import 'package:etebase/src/impl/encrypted_models/encrypted_collection.dart';
import 'package:etebase/src/impl/encrypted_models/encrypted_collection_item.dart';
import 'package:etebase/src/impl/managers/client_impl.dart';
import 'package:etebase/src/impl/models/signed_invitation_content.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

// ignore: directives_ordering
import '../../test_helpers.dart';
import '../crypto/crypto_mocks.dart';
@GenerateNiceMocks([
  MockSpec<ClientImpl>(),
  MockSpec<EncryptedCollectionItem>(),
  MockSpec<AccountCryptoManager>(),
  MockSpec<CollectionCryptoManager>(),
  MockSpec<CollectionItemCryptoManager>(),
  MockSpec<BoxCryptoManager>(),
  MockSpec<MessagePackConverter>(),
  MockSpec<CryptoService>(),
])
import 'encrypted_collection_test.mocks.dart';

class FakeEtebaseItemMetadata extends Fake implements ItemMetadata {}

void main() {
  group('$EncryptedCollection', () {
    final mockClient = MockClientImpl();
    final mockItem = MockEncryptedCollectionItem();
    final mockAccountCm = MockAccountCryptoManager();
    final mockColCm = MockCollectionCryptoManager();
    final mockItemCm = MockCollectionItemCryptoManager();
    final mockMessagePackConverter = MockMessagePackConverter();
    final mockCryptoService = MockCryptoService();

    setUp(() {
      reset(mockClient);
      reset(mockItem);
      reset(mockAccountCm);
      reset(mockColCm);
      reset(mockItemCm);
      reset(mockMessagePackConverter);
      reset(mockCryptoService);

      when(mockClient.converter).thenReturn(mockMessagePackConverter);
      when(mockClient.crypto).thenReturn(mockCryptoService);
      when(
        mockClient.createEncryptedCollectionItem(any, any, any),
      ).thenReturnAsync((mockItem, mockItemCm));

      when(
        mockCryptoService.createCollectionCryptoManager(
          any,
          any,
          version: anyNamed('version'),
        ),
      ).thenReturn(mockColCm);
    });

    group('create', () {
      const testColName = 'test-collection';
      const testMeta = ItemMetadata(name: 'test-col');
      final testContent = Uint8List.fromList([6, 8, 4, 1, 1, 3]);

      final testColUid = Uint8List.fromList([4, 5, 1, 1, 3, 3]);
      final testKey1 = FakeSecureKey(12);
      final testKey2 = FakeSecureKey(13);
      final testEncKey = Uint8List.fromList([9, 5, 1]);

      setUp(() {
        when(mockCryptoService.secureRandom(any)).thenReturn(testKey1);
        when(mockAccountCm.colTypeToUid(any)).thenReturn(testColUid);
        when(mockAccountCm.encryptKey(any, any)).thenReturn(testEncKey);
        when(mockAccountCm.decryptKey(any, any, any)).thenReturn(testKey2);
      });

      test('constructs new instance', () async {
        final (col, colCm) = await EncryptedCollection.create(
          mockClient,
          mockAccountCm,
          testColName,
          testMeta,
          testContent,
        );

        expect(col.item, same(mockItem));
        expect(col.accessLevel, CollectionAccessLevel.admin);
        expect(col.stoken, isNull);

        expect(colCm, same(mockColCm));

        verifyInOrder([
          mockAccountCm.colTypeToUid(testColName),
          mockCryptoService.secureRandom(CryptoUtils.symmetricKeySize),
          mockAccountCm.encryptKey(testKey1, testColUid),
          mockAccountCm.decryptKey(
            testEncKey,
            testColUid,
            CryptoUtils.symmetricKeySize,
          ),
          mockCryptoService.createCollectionCryptoManager(
            mockAccountCm,
            testKey2,
          ),
          mockClient.createEncryptedCollectionItem(
            mockColCm,
            testMeta,
            testContent,
          ),
          mockItemCm.dispose(),
        ]);
        verifyNever(mockColCm.dispose());
        verifyNever(mockAccountCm.dispose());

        expect(testKey1.disposed, isTrue);
        expect(testKey2.disposed, isFalse);
      });

      test('correctly cleans up resources on an exception', () async {
        final testException = Exception('test');

        when(
          mockClient.createEncryptedCollectionItem(any, any, any),
        ).thenThrow(testException);

        await expectLater(
          () => EncryptedCollection.create(
            mockClient,
            mockAccountCm,
            testColName,
            testMeta,
            testContent,
          ),
          throwsA(testException),
        );

        verify(mockColCm.dispose());
        verifyNever(mockAccountCm.dispose());

        expect(testKey1.disposed, isTrue);
        expect(testKey2.disposed, isFalse);
      });
    });

    test('fromJson/toJson correctly decodes/encodes data from/to JSON', () {
      final testColKey = Uint8List.fromList([4, 4, 1, 2, 4]);
      final testColType = Uint8List.fromList([4, 8, 4, 2, 8]);
      const testAccessLevel = CollectionAccessLevel.readWrite;
      const testStoken = 'test-stoken';
      const testItemUid = 'test-uid';

      final testJsonDataOut = {
        'collectionKey': testColKey,
        'collectionType': testColType,
        'item': {
          'uid': testItemUid,
          'version': 0,
          'encryptionKey': Uint8List(0),
          'content': {
            'uid': '',
            'meta': Uint8List(0),
            'chunks': <dynamic>[],
            'deleted': false,
          },
          'etag': '',
        },
      };
      final testJsonDataIn = {
        ...testJsonDataOut,
        'accessLevel': testAccessLevel.value,
        'stoken': testStoken,
      };

      final sut = EncryptedCollection.fromJson(testJsonDataIn);

      // key and type cannot be accessed on purpose
      expect(sut.accessLevel, testAccessLevel);
      expect(sut.stoken, testStoken);
      expect(sut.item.uid, testItemUid);

      final json = sut.toJson();

      expect(json, testJsonDataOut);
    });

    test('cacheLoad/cacheSave correctly loads/saves data from/to cache', () {
      // revision
      final testRevisionCacheData = CachedRevision(
        uid: Uint8List(0),
        meta: Uint8List(0),
        deleted: false,
        chunks: [
          CachedChunk(Uint8List.fromList([2]), Uint8List.fromList([4])),
        ],
      );
      final testEncodedContent = Uint8List.fromList([4, 1, 44, 12]);
      // item
      final testItemUid = Uint8List.fromList([4, 3, 1, 2, 3]);
      final testItemCacheData = CachedCollectionItem(
        uid: testItemUid,
        version: 0,
        encryptionKey: Uint8List(0),
        etag: Uint8List(0),
        revision: testEncodedContent,
      );
      final testEncodedItem = Uint8List.fromList([5, 12, 4, 121, 41]);
      // collection
      final testColKey = Uint8List.fromList([4, 4, 1, 2, 4]);
      final testColType = Uint8List.fromList([4, 8, 4, 2, 8]);
      const testAccessLevel = CollectionAccessLevel.readOnly;
      const testStoken = 'test-stoken';
      final testColCacheData = CachedCollection(
        collectionKey: testColKey,
        collectionType: testColType,
        accessLevel: testAccessLevel,
        stoken: testStoken,
        item: testEncodedItem,
      );
      final testEncodedCol = Uint8List.fromList([88, 23, 12]);

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
      provideDummy(testColCacheData);
      when(
        mockMessagePackConverter.decode<CachedCollection>(testEncodedCol),
      ).thenReturn(testColCacheData);

      final sut = EncryptedCollection.cacheLoad(mockClient, testEncodedCol);

      // key and type cannot be accessed on purpose
      expect(sut.accessLevel, testAccessLevel);
      expect(sut.stoken, testStoken);
      expect(sut.item.uid, base64.encode(testItemUid));

      verifyInOrder([
        mockMessagePackConverter.decode<CachedCollection>(testEncodedCol),
        mockMessagePackConverter.decode<CachedCollectionItem>(testEncodedItem),
        mockMessagePackConverter.decode<CachedRevision>(testEncodedContent),
      ]);
      clearInteractions(mockMessagePackConverter);

      // with content
      when(
        mockMessagePackConverter.encode(testColCacheData),
      ).thenReturn(testEncodedCol);
      when(
        mockMessagePackConverter.encode(testItemCacheData),
      ).thenReturn(testEncodedItem);
      when(
        mockMessagePackConverter.encode(testRevisionCacheData),
      ).thenReturn(testEncodedContent);

      final cachedWithContent = sut.cacheSave(mockClient, saveContent: true);
      expect(cachedWithContent, testEncodedCol);

      verifyInOrder([
        mockMessagePackConverter.encode(testRevisionCacheData),
        mockMessagePackConverter.encode(testItemCacheData),
        mockMessagePackConverter.encode(testColCacheData),
      ]);
      clearInteractions(mockMessagePackConverter);

      // without content
      final testRevisionWithoutContentCacheData = CachedRevision(
        uid: Uint8List(0),
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
      expect(cachedWithoutContent, testEncodedCol);

      verifyInOrder([
        mockMessagePackConverter.encode(testRevisionWithoutContentCacheData),
        mockMessagePackConverter.encode(testItemCacheData),
        mockMessagePackConverter.encode(testColCacheData),
      ]);
      clearInteractions(mockMessagePackConverter);
    });

    group('members', () {
      const testMeta = ItemMetadata(name: 'test-col-name');
      final testContent = Uint8List.fromList([76, 4, 1, 22]);
      const testColTypeName = 'test-col-type';
      final testColType = Uint8List.fromList([66, 2, 3, 5, 12]);
      final testKey = FakeSecureKey(23);
      final testEncKey = Uint8List.fromList([5, 23, 12, 4]);

      late EncryptedCollection sut;

      void setupWithCm<T>() =>
          when(mockItem.withCm<T>(any, any, any)).thenAnswer((i) async {
            final [_, _, WithCmCallback<T> cb] = i.positionalArguments;
            return await cb(mockItemCm);
          });

      setUp(() async {
        when(mockCryptoService.secureRandom(any)).thenReturn(testKey);
        when(mockAccountCm.colTypeToUid(any)).thenReturn(testColType);
        when(mockAccountCm.encryptKey(any, any)).thenReturn(testEncKey);
        when(mockAccountCm.decryptKey(any, any, any)).thenReturn(testKey);

        setupWithCm<void>();

        final (item, _) = await EncryptedCollection.create(
          mockClient,
          mockAccountCm,
          testColTypeName,
          testMeta,
          testContent,
        );
        sut = item;
        testKey.disposed = false;

        clearInteractions(mockClient);
        clearInteractions(mockCryptoService);
        clearInteractions(mockAccountCm);
      });

      test('properties return correct values', () {
        const testUid = 'test-uid';
        const testEtag = 'test-etag';
        const testLastEtag = 'test-last-etag';
        const testVersion = 744;

        when(mockItem.uid).thenReturn(testUid);
        when(mockItem.etag).thenReturn(testEtag);
        when(mockItem.lastEtag).thenReturn(testLastEtag);
        when(mockItem.version).thenReturn(testVersion);
        when(mockItem.isDeleted).thenReturn(true);
        when(mockItem.isMissingContent).thenReturn(true);

        expect(sut.item, same(mockItem));
        expect(sut.accessLevel, CollectionAccessLevel.admin);
        expect(sut.stoken, isNull);
        expect(sut.uid, testUid);
        expect(sut.etag, testEtag);
        expect(sut.lastEtag, testLastEtag);
        expect(sut.version, testVersion);
        expect(sut.isDeleted, isTrue);
        expect(sut.isMissingContent, isTrue);

        verifyInOrder([
          mockItem.uid,
          mockItem.etag,
          mockItem.lastEtag,
          mockItem.version,
          mockItem.isDeleted,
          mockItem.isMissingContent,
        ]);
      });

      test('markSaved marks item as saved', () {
        sut.markSaved();

        verify(mockItem.markSaved());
      });

      test('verify verifies item with crypto manager', () async {
        await sut.verify(mockClient, mockColCm);

        verifyInOrder([
          mockItem.withCm<void>(mockClient, mockColCm, any),
          mockItem.verify(mockClient, mockItemCm),
        ]);
      });

      group('setMeta', () {
        test('sets metadata with crypto manager', () async {
          await sut.setMeta(mockClient, mockColCm, testMeta);

          verifyInOrder([
            mockItem.withCm<void>(mockClient, mockColCm, any),
            mockItem.setMeta(mockClient, mockItemCm, testMeta),
          ]);
        });

        test('can handle custom metadata classes', () async {
          final otherMeta = FakeEtebaseItemMetadata();

          await sut.setMeta(mockClient, mockColCm, otherMeta);

          verifyInOrder([
            mockItem.withCm<void>(mockClient, mockColCm, any),
            mockItem.setMeta(mockClient, mockItemCm, otherMeta),
          ]);
        });
      });

      group('getMeta', () {
        test('gets metadata with crypto manager', () async {
          setupWithCm<ItemMetadata>();
          when(
            mockItem.getMeta<ItemMetadata>(any, any),
          ).thenReturnAsync(testMeta);

          final result = await sut.getMeta(mockClient, mockColCm);

          expect(result, testMeta);

          verifyInOrder([
            mockItem.withCm<ItemMetadata>(mockClient, mockColCm, any),
            mockItem.getMeta(mockClient, mockItemCm),
          ]);
        });

        test('can handle custom metadata classes', () async {
          final otherMeta = FakeEtebaseItemMetadata();

          setupWithCm<FakeEtebaseItemMetadata>();
          when(
            mockItem.getMeta<FakeEtebaseItemMetadata>(any, any),
          ).thenReturnAsync(otherMeta);

          final result = await sut.getMeta<FakeEtebaseItemMetadata>(
            mockClient,
            mockColCm,
          );

          expect(result, otherMeta);

          verifyInOrder([
            mockItem.withCm<FakeEtebaseItemMetadata>(
              mockClient,
              mockColCm,
              any,
            ),
            mockItem.getMeta<FakeEtebaseItemMetadata>(mockClient, mockItemCm),
          ]);
        });
      });

      test('setContent sets content with crypto manager', () async {
        await sut.setContent(mockClient, mockColCm, testContent);

        verifyInOrder([
          mockItem.withCm<void>(mockClient, mockColCm, any),
          mockItem.setContent(mockClient, mockItemCm, testContent),
        ]);
      });

      test('setContentStream sets content with crypto manager', () async {
        final testContentStream = Stream.value(testContent);
        await sut.setContentStream(mockClient, mockColCm, testContentStream);

        verifyInOrder([
          mockItem.withCm<void>(mockClient, mockColCm, any),
          mockItem.setContentStream(mockClient, mockItemCm, testContentStream),
        ]);
      });

      test('getContent sets content with crypto manager', () async {
        setupWithCm<Uint8List>();
        when(mockItem.getContent(any, any)).thenReturnAsync(testContent);

        final result = await sut.getContent(mockClient, mockColCm);

        expect(result, testContent);

        verifyInOrder([
          mockItem.withCm<Uint8List>(mockClient, mockColCm, any),
          mockItem.getContent(mockClient, mockItemCm),
        ]);
      });

      test('getContentStream sets content with crypto manager', () async {
        clearInteractions(mockItemCm);

        when(mockItem.getCryptoManager(any, any)).thenReturn(mockItemCm);
        when(
          mockItem.getContentStream(any, any),
        ).thenStream(Stream.value(testContent));

        final result = sut.getContentStream(mockClient, mockColCm);

        final sq = StreamQueue(result);
        expect(await sq.next, testContent);

        verifyInOrder([
          mockItem.getCryptoManager(mockClient, mockColCm),
          mockItem.getContentStream(mockClient, mockItemCm),
        ]);
        verifyNever(mockItemCm.dispose());

        expect(await sq.hasNext, isFalse);
        verify(mockItemCm.dispose()).called(1);
      });

      testData(
        'delete marks item as deleted with crypto manager',
        [false, true],
        dataToString: (fixture) => 'preserveContent: $fixture',
        (fixture) async {
          await sut.delete(mockClient, mockColCm, preserveContent: fixture);

          verifyInOrder([
            mockItem.withCm<void>(mockClient, mockColCm, any),
            mockItem.delete(mockClient, mockItemCm, preserveContent: fixture),
          ]);
        },
      );

      test('getCollectionType decodes collection type', () {
        when(mockAccountCm.colTypeFromUid(any)).thenReturn(testColTypeName);

        final result = sut.getCollectionType(mockClient, mockAccountCm);

        expect(result, testColTypeName);

        verify(mockAccountCm.colTypeFromUid(testColType));
      });

      group('createInvitation', () {
        const testUserName = 'test-user';
        final testPubKey = Uint8List.fromList([45, 5, 112, 4]);

        final mockIdCm = MockBoxCryptoManager();

        setUp(() {
          reset(mockIdCm);

          when(mockMessagePackConverter.base64Encode(any)).thenAnswer(
            (i) => base64.encode(i.positionalArguments.single as Uint8List),
          );
        });

        test('creates invitation for peer', () async {
          const testItemUid = 'test-item-uid';
          final testInvitationId = Uint8List.fromList([5, 4, 1, 5, 12, 1]);
          final testInvitationData = SignedInvitationContent(
            encryptionKey: await testKey.runUnlockedAsync((b) => b),
            collectionType: testColTypeName,
          );
          final testEncodedInvitationData = Uint8List.fromList([5, 12, 6, 77]);
          final testPaddedInvitationData = Uint8List.fromList([9, 88, 5, 1]);
          final testSignedInvitationData = Uint8List.fromList([4, 1, 2, 11]);

          when(
            mockMessagePackConverter.encode(any),
          ).thenReturn(testEncodedInvitationData);
          when(mockCryptoService.randomBytes(any)).thenReturn(testInvitationId);
          when(
            mockCryptoService.bufferPadSmall(any),
          ).thenReturn(testPaddedInvitationData);
          when(mockAccountCm.colTypeFromUid(any)).thenReturn(testColTypeName);
          when(
            mockIdCm.encrypt(
              message: anyNamed('message'),
              pubkey: anyNamed('pubkey'),
            ),
          ).thenReturn(testSignedInvitationData);
          when(mockItem.uid).thenReturn(testItemUid);

          final result = await sut.createInvitation(
            mockClient,
            mockAccountCm,
            mockIdCm,
            testUserName,
            testPubKey,
            CollectionAccessLevel.readWrite,
          );

          expect(result.uid, base64.encode(testInvitationId));
          expect(result.version, CryptoUtils.currentVersion);
          expect(result.username, testUserName);
          expect(result.collection, testItemUid);
          expect(result.accessLevel, CollectionAccessLevel.readWrite);
          expect(result.signedEncryptionKey, testSignedInvitationData);

          verifyInOrder([
            mockAccountCm.decryptKey(
              testEncKey,
              testColType,
              CryptoUtils.symmetricKeySize,
            ),
            mockCryptoService.randomBytes(32),
            mockAccountCm.colTypeFromUid(testColType),
            mockMessagePackConverter.encode(testInvitationData),
            mockCryptoService.bufferPadSmall(testEncodedInvitationData),
            mockIdCm.encrypt(
              message: testPaddedInvitationData,
              pubkey: testPubKey,
            ),
            mockMessagePackConverter.base64Encode(testInvitationId),
            mockItem.uid,
          ]);

          expect(testKey.disposed, isTrue);
        });

        test('disposes encryption key on exception', () async {
          final testException = Exception('test');

          when(mockCryptoService.randomBytes(any)).thenThrow(testException);

          await expectLater(
            () => sut.createInvitation(
              mockClient,
              mockAccountCm,
              mockIdCm,
              testUserName,
              testPubKey,
              CollectionAccessLevel.readOnly,
            ),
            throwsA(testException),
          );

          verifyInOrder([
            mockAccountCm.decryptKey(
              testEncKey,
              testColType,
              CryptoUtils.symmetricKeySize,
            ),
            mockCryptoService.randomBytes(32),
          ]);
          verifyZeroInteractions(mockIdCm);

          expect(testKey.disposed, isTrue);
        });
      });

      test('getCryptoManager creates collection crypto manager', () {
        final result = sut.getCryptoManager(mockClient, mockAccountCm);

        expect(result, same(mockColCm));

        verifyInOrder([
          mockAccountCm.decryptKey(
            testEncKey,
            testColType,
            CryptoUtils.symmetricKeySize,
          ),
          mockCryptoService.createCollectionCryptoManager(
            mockAccountCm,
            testKey,
          ),
        ]);

        expect(testKey.disposed, isFalse);
      });
    });
  });
}
