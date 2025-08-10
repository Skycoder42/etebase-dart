import 'dart:typed_data';

import 'package:etebase/src/api/models/collection_access_level.dart';
import 'package:etebase/src/api/models/item_metadata.dart';
import 'package:etebase/src/impl/crypto/account_crypto_manager.dart';
import 'package:etebase/src/impl/crypto/collection_crypto_manager.dart';
import 'package:etebase/src/impl/encrypted_models/encrypted_collection.dart';
import 'package:etebase/src/impl/managers/client_impl.dart';
import 'package:etebase/src/impl/managers/collection_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../test_helpers.dart';
@GenerateNiceMocks([
  MockSpec<ClientImpl>(),
  MockSpec<CollectionCryptoManager>(),
  MockSpec<AccountCryptoManager>(),
  MockSpec<EncryptedCollection>(),
])
import 'collection_impl_test.mocks.dart';

void main() {
  group('$CollectionImpl', () {
    final mockClient = MockClientImpl();
    final mockCollectionCM = MockCollectionCryptoManager();
    final mockAccountCM = MockAccountCryptoManager();
    final mockEncrypted = MockEncryptedCollection();

    late CollectionImpl sut;

    setUp(() {
      reset(mockClient);
      reset(mockCollectionCM);
      reset(mockAccountCM);
      reset(mockEncrypted);

      when(mockCollectionCM.accountCryptoManager).thenReturn(mockAccountCM);

      sut = CollectionImpl(mockClient, mockCollectionCM, mockEncrypted);
    });

    test('uid returns encrypted.uid', () {
      const testUid = 'test-uid';

      when(mockEncrypted.uid).thenReturn(testUid);

      expect(sut.uid, testUid);

      verify(mockEncrypted.uid).called(1);
    });

    test('etag returns encrypted.etag', () {
      const testEtag = 'test-etag';

      when(mockEncrypted.etag).thenReturn(testEtag);

      expect(sut.etag, testEtag);

      verify(mockEncrypted.etag).called(1);
    });

    test('isDeleted returns encrypted.isDeleted', () {
      when(mockEncrypted.isDeleted).thenReturn(true);

      expect(sut.isDeleted, isTrue);

      verify(mockEncrypted.isDeleted).called(1);
    });

    test('isMissingContent returns encrypted.isMissingContent', () {
      when(mockEncrypted.isMissingContent).thenReturn(true);

      expect(sut.isMissingContent, isTrue);

      verify(mockEncrypted.isMissingContent).called(1);
    });

    test('stoken returns encrypted.stoken', () {
      const testStoken = 'test-stoken';

      when(mockEncrypted.stoken).thenReturn(testStoken);

      expect(sut.stoken, testStoken);

      verify(mockEncrypted.stoken).called(1);
    });

    test('collectionType decodes collection type from encrypted', () {
      const testColType = 'test-col-type';

      when(mockEncrypted.getCollectionType(any, any)).thenReturn(testColType);

      final result = sut.collectionType;
      expect(result, testColType);

      verifyInOrder([
        mockCollectionCM.accountCryptoManager,
        mockEncrypted.getCollectionType(mockClient, mockAccountCM),
      ]);
    });

    test('accessLevel returns encrypted.accessLevel', () {
      when(
        mockEncrypted.accessLevel,
      ).thenReturn(CollectionAccessLevel.readWrite);

      expect(sut.accessLevel, CollectionAccessLevel.readWrite);

      verify(mockEncrypted.accessLevel).called(1);
    });

    test('dispose disposes crypto manager', () {
      sut.dispose();

      verify(mockCollectionCM.dispose());
    });

    test('verify calls verify on encrypted', () async {
      await sut.verify();

      verify(mockEncrypted.verify(mockClient, mockCollectionCM));
    });

    test('setMeta calls setMeta on encrypted', () async {
      const testMeta = ItemMetadata(name: 'test');

      await sut.setMeta(testMeta);

      verify(mockEncrypted.setMeta(mockClient, mockCollectionCM, testMeta));
    });

    test('getMeta calls getMeta on encrypted', () async {
      const testMeta = ItemMetadata(name: 'test');

      when(
        mockEncrypted.getMeta<ItemMetadata>(mockClient, mockCollectionCM),
      ).thenReturnAsync(testMeta);

      final result = await sut.getMeta<ItemMetadata>();
      expect(result, testMeta);

      verify(mockEncrypted.getMeta<ItemMetadata>(mockClient, mockCollectionCM));
    });

    test('setContent calls setContent on encrypted', () async {
      final testContent = Uint8List.fromList([33, 4, 12, 12]);

      await sut.setContent(testContent);

      verify(
        mockEncrypted.setContent(mockClient, mockCollectionCM, testContent),
      );
    });

    test('setContentStream calls setContentStream on encrypted', () async {
      final testContent = Stream.value([33, 4, 12, 12]);

      await sut.setContentStream(testContent);

      verify(
        mockEncrypted.setContentStream(
          mockClient,
          mockCollectionCM,
          testContent,
        ),
      );
    });

    test('getContent calls getContent on encrypted', () async {
      final testContent = Uint8List.fromList([33, 4, 12, 12]);

      when(
        mockEncrypted.getContent(mockClient, mockCollectionCM),
      ).thenReturnAsync(testContent);

      final result = await sut.getContent();
      expect(result, testContent);

      verify(mockEncrypted.getContent(mockClient, mockCollectionCM));
    });

    test('getContentStream calls getContentStream on encrypted', () async {
      final testContent = Uint8List.fromList([33, 4, 12, 12]);

      when(
        mockEncrypted.getContentStream(mockClient, mockCollectionCM),
      ).thenStream(Stream.value(testContent));

      final result = sut.getContentStream();
      await expectLater(result, emitsInOrder([testContent, emitsDone]));

      verify(mockEncrypted.getContentStream(mockClient, mockCollectionCM));
    });

    test('delete calls delete on encrypted', () async {
      await sut.delete(preserveContent: true);

      verify(
        mockEncrypted.delete(
          mockClient,
          mockCollectionCM,
          preserveContent: true,
        ),
      );
    });
  });
}
