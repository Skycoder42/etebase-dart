import 'dart:typed_data';

import 'package:etebase/src/api/models/item_metadata.dart';
import 'package:etebase/src/impl/crypto/collection_item_crypto_manager.dart';
import 'package:etebase/src/impl/encrypted_models/encrypted_collection_item.dart';
import 'package:etebase/src/impl/managers/client_impl.dart';
import 'package:etebase/src/impl/managers/item_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../test_helpers.dart';
@GenerateNiceMocks([
  MockSpec<ClientImpl>(),
  MockSpec<CollectionItemCryptoManager>(),
  MockSpec<EncryptedCollectionItem>(),
])
import 'item_impl_test.mocks.dart';

void main() {
  group('$ItemImpl', () {
    const testColUid = 'test-col-uid';

    final mockClient = MockClientImpl();
    final mockItemCM = MockCollectionItemCryptoManager();
    final mockEncrypted = MockEncryptedCollectionItem();

    late ItemImpl sut;

    setUp(() {
      reset(mockClient);
      reset(mockItemCM);
      reset(mockEncrypted);

      sut = ItemImpl(mockClient, mockItemCM, mockEncrypted, testColUid);
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

    test('dispose disposes crypto manager', () {
      sut.dispose();

      verify(mockItemCM.dispose());
    });

    test('verify calls verify on encrypted', () async {
      await sut.verify();

      verify(mockEncrypted.verify(mockClient, mockItemCM));
    });

    test('setMeta calls setMeta on encrypted', () async {
      const testMeta = ItemMetadata(name: 'test');

      await sut.setMeta(testMeta);

      verify(mockEncrypted.setMeta(mockClient, mockItemCM, testMeta));
    });

    test('getMeta calls getMeta on encrypted', () async {
      const testMeta = ItemMetadata(name: 'test');

      when(mockEncrypted.getMeta<ItemMetadata>(mockClient, mockItemCM))
          .thenReturnAsync(testMeta);

      final result = await sut.getMeta<ItemMetadata>();
      expect(result, testMeta);

      verify(mockEncrypted.getMeta<ItemMetadata>(mockClient, mockItemCM));
    });

    test('setContent calls setContent on encrypted', () async {
      final testContent = Uint8List.fromList([33, 4, 12, 12]);

      await sut.setContent(testContent);

      verify(mockEncrypted.setContent(mockClient, mockItemCM, testContent));
    });

    test('setContentStream calls setContentStream on encrypted', () async {
      final testContent = Stream.value([33, 4, 12, 12]);

      await sut.setContentStream(testContent);

      verify(
        mockEncrypted.setContentStream(mockClient, mockItemCM, testContent),
      );
    });

    test('getContent calls getContent on encrypted', () async {
      final testContent = Uint8List.fromList([33, 4, 12, 12]);

      when(mockEncrypted.getContent(mockClient, mockItemCM))
          .thenReturnAsync(testContent);

      final result = await sut.getContent();
      expect(result, testContent);

      verify(mockEncrypted.getContent(mockClient, mockItemCM));
    });

    test('getContentStream calls getContentStream on encrypted', () async {
      final testContent = Uint8List.fromList([33, 4, 12, 12]);

      when(mockEncrypted.getContentStream(mockClient, mockItemCM))
          .thenStream(Stream.value(testContent));

      final result = sut.getContentStream();
      await expectLater(result, emitsInOrder([testContent, emitsDone]));

      verify(mockEncrypted.getContentStream(mockClient, mockItemCM));
    });

    test('delete calls delete on encrypted', () async {
      await sut.delete(preserveContent: true);

      verify(
        mockEncrypted.delete(mockClient, mockItemCM, preserveContent: true),
      );
    });
  });
}
