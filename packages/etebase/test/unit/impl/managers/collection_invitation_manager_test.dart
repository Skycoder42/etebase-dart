import 'dart:typed_data';

import 'package:etebase/src/api/models/collection_access_level.dart';
import 'package:etebase/src/api/models/fetch_options.dart';
import 'package:etebase/src/api/models/list_response.dart';
import 'package:etebase/src/api/models/user_profile.dart';
import 'package:etebase/src/impl/codec/message_pack_converter.dart';
import 'package:etebase/src/impl/crypto/account_crypto_manager.dart';
import 'package:etebase/src/impl/crypto/box_crypto_manager.dart';
import 'package:etebase/src/impl/crypto/crypto_service.dart';
import 'package:etebase/src/impl/encrypted_models/encrypted_collection.dart';
import 'package:etebase/src/impl/managers/account.dart';
import 'package:etebase/src/impl/managers/client.dart';
import 'package:etebase/src/impl/managers/collection_impl.dart';
import 'package:etebase/src/impl/managers/collection_invitation_manager.dart';
import 'package:etebase/src/impl/models/invitation_accept_request.dart';
import 'package:etebase/src/impl/models/signed_invitation_base.dart';
import 'package:etebase/src/impl/models/signed_invitation_content.dart';
import 'package:etebase/src/impl/online_managers/collection_invitation_manager_online.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

// ignore: directives_ordering
import '../../test_helpers.dart';
@GenerateNiceMocks([
  MockSpec<Client>(),
  MockSpec<Account>(),
  MockSpec<CollectionInvitationManagerOnline>(),
  MockSpec<CryptoService>(),
  MockSpec<MessagePackConverter>(),
  MockSpec<BoxCryptoManager>(),
  MockSpec<AccountCryptoManager>(),
  MockSpec<CollectionImpl>(),
  MockSpec<EncryptedCollection>(),
])
import 'collection_invitation_manager_test.mocks.dart';

void main() {
  group('$CollectionInvitationManager', () {
    const testOptions = IteratorFetchOptions();

    final mockClient = MockClient();
    final mockAccount = MockAccount();
    final mockOnline = MockCollectionInvitationManagerOnline();
    final mockCryptoService = MockCryptoService();
    final mockMessagePackConverter = MockMessagePackConverter();
    final mockBoxCM = MockBoxCryptoManager();
    final mockAccountCM = MockAccountCryptoManager();
    final mockCollection = MockCollectionImpl();
    final mockEncryptedCollection = MockEncryptedCollection();

    late CollectionInvitationManager sut;

    setUp(() {
      reset(mockClient);
      reset(mockAccount);
      reset(mockOnline);
      reset(mockCryptoService);
      reset(mockMessagePackConverter);
      reset(mockBoxCM);
      reset(mockAccountCM);
      reset(mockCollection);
      reset(mockEncryptedCollection);

      when(mockClient.crypto).thenReturn(mockCryptoService);
      when(mockClient.converter).thenReturn(mockMessagePackConverter);

      when(mockAccount.identityCryptoManager).thenReturn(mockBoxCM);
      when(mockAccount.accountCryptoManager).thenReturn(mockAccountCM);

      when(mockCollection.encrypted).thenReturn(mockEncryptedCollection);

      sut = CollectionInvitationManager(mockClient, mockAccount, mockOnline);
    });

    test('pubKey returns identity cm pub key', () {
      final testPubKey = Uint8List.fromList([24, 122]);

      when(mockBoxCM.pubkey).thenReturn(testPubKey);

      final result = sut.pubkey;

      expect(result, testPubKey);

      verify(mockBoxCM.pubkey).called(1);
    });

    test('listIncoming invokes listIncoming on online manager', () async {
      const testResponse = IteratorListResponse(
        data: <SignedInvitationRead>[],
        isDone: true,
        iterator: null,
      );

      when(mockOnline.listIncoming(any)).thenReturnAsync(testResponse);

      final result = await sut.listIncoming(testOptions);

      expect(result, same(testResponse));

      verify(mockOnline.listIncoming(testOptions));
    });

    test('listOutgoing invokes listOutgoing on online manager', () async {
      const testResponse = IteratorListResponse(
        data: <SignedInvitationRead>[],
        isDone: true,
        iterator: null,
      );

      when(mockOnline.listOutgoing(any)).thenReturnAsync(testResponse);

      final result = await sut.listOutgoing(testOptions);

      expect(result, same(testResponse));

      verify(mockOnline.listOutgoing(testOptions));
    });

    test(
      'accept decodes invitation and then accepts it with the online manager',
      () async {
        final testInvitation = SignedInvitationRead(
          uid: 'test-uid',
          version: 13,
          username: 'test-username',
          collection: 'test-collection',
          accessLevel: CollectionAccessLevel.readOnly,
          signedEncryptionKey: Uint8List.fromList([23, 44, 1]),
          fromPubKey: Uint8List.fromList([21, 124]),
        );

        final testContent = SignedInvitationContent(
          encryptionKey: Uint8List.fromList([66, 23, 1]),
          collectionType: 'test-collection-type',
        );
        final testPaddedData = Uint8List.fromList([34, 65]);
        final testUnpaddedData = Uint8List.fromList([76, 1, 55]);
        final testUid = Uint8List.fromList([78, 1, 43, 1, 2]);
        final testEncryptedKey = Uint8List.fromList([55, 123, 4]);

        provideDummy(testContent);

        when(
          mockCryptoService.bufferUnpadSmall(any),
        ).thenReturn(testUnpaddedData);

        when(
          mockMessagePackConverter.decode<SignedInvitationContent>(any),
        ).thenReturn(testContent);

        when(
          mockBoxCM.decrypt(
            nonceCipherText: anyNamed('nonceCipherText'),
            pubkey: anyNamed('pubkey'),
          ),
        ).thenReturn(testPaddedData);

        when(mockAccountCM.colTypeToUid(any)).thenReturn(testUid);
        when(mockAccountCM.encrypt(any, any)).thenReturn(testEncryptedKey);

        await sut.accept(testInvitation);

        verifyInOrder([
          mockBoxCM.decrypt(
            nonceCipherText: testInvitation.signedEncryptionKey,
            pubkey: testInvitation.fromPubKey,
          ),
          mockCryptoService.bufferUnpadSmall(testPaddedData),
          mockMessagePackConverter.decode<SignedInvitationContent>(
            testUnpaddedData,
          ),
          mockAccountCM.colTypeToUid(testContent.collectionType),
          mockAccountCM.encrypt(testContent.encryptionKey, testUid),
          mockOnline.accept(
            testInvitation,
            InvitationAcceptRequest(
              collectionType: testUid,
              encryptionKey: testEncryptedKey,
            ),
          ),
        ]);
      },
    );

    test('reject invokes reject on online manager', () async {
      final testInvitation = SignedInvitationRead(
        uid: 'test-uid',
        version: 13,
        username: 'test-username',
        collection: 'test-collection',
        accessLevel: CollectionAccessLevel.readOnly,
        signedEncryptionKey: Uint8List.fromList([23, 44, 1]),
        fromPubKey: Uint8List.fromList([21, 124]),
      );

      await sut.reject(testInvitation);

      verify(mockOnline.reject(testInvitation));
    });

    test(
      'fetchUserProfile invokes fetchUserProfile on online manager',
      () async {
        const testUserName = 'test-user-name';
        final testProfile = UserProfile(pubkey: Uint8List(12));

        provideDummy(testProfile);

        when(mockOnline.fetchUserProfile(any)).thenReturnAsync(testProfile);

        final result = await sut.fetchUserProfile(testUserName);

        expect(result, same(testProfile));

        verify(mockOnline.fetchUserProfile(testUserName)).called(1);
      },
    );

    test('invite creates invitation from collection and '
        'calls invite on online manager with it', () async {
      const testUserName = 'test-user-name';
      final testPubKey = Uint8List.fromList([45, 1, 44, 3]);
      final testInvitation = SignedInvitationWrite(
        uid: 'test-uid',
        version: 14,
        username: 'test-username',
        collection: 'test-collection',
        accessLevel: CollectionAccessLevel.admin,
        signedEncryptionKey: Uint8List.fromList([9, 99]),
      );

      when(
        mockEncryptedCollection.createInvitation(any, any, any, any, any, any),
      ).thenReturnAsync(testInvitation);

      await sut.invite(
        mockCollection,
        testUserName,
        testPubKey,
        CollectionAccessLevel.admin,
      );

      verifyInOrder([
        mockCollection.encrypted,
        mockEncryptedCollection.createInvitation(
          mockClient,
          mockAccountCM,
          mockBoxCM,
          testUserName,
          testPubKey,
          CollectionAccessLevel.admin,
        ),
        mockOnline.invite(testInvitation),
      ]);
    });

    test('disinvite calls disinvite on online manager', () async {
      final testInvitation = SignedInvitationRead(
        uid: 'test-uid',
        version: 13,
        username: 'test-username',
        collection: 'test-collection',
        accessLevel: CollectionAccessLevel.readOnly,
        signedEncryptionKey: Uint8List.fromList([23, 44, 1]),
        fromPubKey: Uint8List.fromList([21, 124]),
      );

      await sut.disinvite(testInvitation);

      verify(mockOnline.disinvite(testInvitation));
    });
  });
}
