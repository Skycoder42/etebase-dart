// ignore_for_file: discarded_futures

import 'dart:typed_data';

import 'package:etebase/src/api/exceptions/api_missuse.dart';
import 'package:etebase/src/api/models/etebase_user.dart';
import 'package:etebase/src/impl/codec/message_pack_converter.dart';
import 'package:etebase/src/impl/crypto/account_crypto_manager.dart';
import 'package:etebase/src/impl/crypto/box_crypto_manager.dart';
import 'package:etebase/src/impl/crypto/crypto_service.dart';
import 'package:etebase/src/impl/crypto/crypto_utils.dart';
import 'package:etebase/src/impl/crypto/key_derivator.dart';
import 'package:etebase/src/impl/crypto/login_crypto_manager.dart';
import 'package:etebase/src/impl/crypto/main_crypto_manager.dart';
import 'package:etebase/src/impl/crypto/storage_crypto_manager.dart';
import 'package:etebase/src/impl/managers/account.dart';
import 'package:etebase/src/impl/managers/client.dart';
import 'package:etebase/src/impl/managers/collection_invitation_manager.dart';
import 'package:etebase/src/impl/managers/collection_manager.dart';
import 'package:etebase/src/impl/models/account_data.dart';
import 'package:etebase/src/impl/models/account_data_stored.dart';
import 'package:etebase/src/impl/models/auth_token.dart';
import 'package:etebase/src/impl/models/challenge_request.dart';
import 'package:etebase/src/impl/models/challenge_response.dart';
import 'package:etebase/src/impl/models/login_challenge.dart';
import 'package:etebase/src/impl/models/login_request.dart';
import 'package:etebase/src/impl/models/login_response.dart';
import 'package:etebase/src/impl/models/signup_request.dart';
import 'package:etebase/src/impl/models/user.dart';
import 'package:etebase/src/impl/online_managers/authenticator.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../test_helpers.dart';
import '../crypto/crypto_mocks.dart';

// ignore: directives_ordering
@GenerateNiceMocks([
  MockSpec<Client>(),
  MockSpec<MainCryptoManager>(),
  MockSpec<AccountCryptoManager>(),
  MockSpec<BoxCryptoManager>(),
  MockSpec<LoginCryptoManager>(),
  MockSpec<StorageCryptoManager>(),
  MockSpec<CryptoService>(),
  MockSpec<KeyDerivator>(),
  MockSpec<Authenticator>(),
  MockSpec<MessagePackConverter>(),
])
import 'account_test.mocks.dart';

void main() {
  group('$Account', () {
    final testBaseUrl = Uri.https('example.com', '/test');
    const testUserName = 'test-user';
    const testEmail = 'user@test.con';
    const testPassword = 'test-password';
    final testEncryptedContent = Uint8List.fromList([4, 121, 33]);
    final testUser = User(
      username: testUserName,
      email: testEmail,
      pubkey: Uint8List.fromList([4, 12, 56]),
      encryptedContent: testEncryptedContent,
    );
    const testToken = 'test-auth-token-value';

    final mockClient = MockClient();
    final mockMainCM = MockMainCryptoManager();
    final mockAccountCM = MockAccountCryptoManager();
    final mockIdCM = MockBoxCryptoManager();
    final mockLoginCM = MockLoginCryptoManager();
    final mockStorageCM = MockStorageCryptoManager();
    final mockCryptoService = MockCryptoService();
    final mockKeyDerivator = MockKeyDerivator();
    final mockAuthenticator = MockAuthenticator();
    final mockConverter = MockMessagePackConverter();

    setUp(() {
      reset(mockClient);
      reset(mockMainCM);
      reset(mockAccountCM);
      reset(mockIdCM);
      reset(mockLoginCM);
      reset(mockStorageCM);
      reset(mockCryptoService);
      reset(mockKeyDerivator);
      reset(mockAuthenticator);
      reset(mockConverter);

      when(mockClient.crypto).thenReturn(mockCryptoService);
      when(mockClient.authenticator).thenReturn(mockAuthenticator);
      when(mockClient.converter).thenReturn(mockConverter);
      when(mockClient.baseUrl).thenReturn(testBaseUrl);

      when(mockCryptoService.keyDerivator).thenReturn(mockKeyDerivator);
      when(
        mockCryptoService.createMainCryptoManager(
          any,
          version: anyNamed('version'),
        ),
      ).thenReturn(mockMainCM);
      when(
        mockCryptoService.createIdentityCryptoManager(any),
      ).thenReturn(mockIdCM);
      when(
        mockCryptoService.createStorageCryptoManager(
          any,
          version: anyNamed('version'),
        ),
      ).thenReturn(mockStorageCM);

      when(mockMainCM.createLoginCryptoManager()).thenReturn(mockLoginCM);
      when(
        mockMainCM.createAccountCryptoManager(any),
      ).thenReturn(mockAccountCM);
      when(mockMainCM.createIdentityCryptoManager(any)).thenReturn(mockIdCM);
    });

    group('authentication', () {
      final testSalt = Uint8List.fromList([4, 5, 12, 44]);
      final testMainKey = FakeSecureKey(11);
      final testAccKey = FakeSecureKey(22);
      final testIdPrivKey = FakeSecureKey(33);
      final testIdPubKey = Uint8List.fromList([23, 1, 1, 9]);
      final testLoginPubKey = Uint8List.fromList([32, 77, 1]);
      final testDecryptedKeyData1 = Uint8List.fromList(
        List.generate(32, (i) => i),
      );
      final testDecryptedKeyData2 = Uint8List.fromList(
        List.generate(32, (i) => 32 + i),
      );
      final testDecryptedKey = FakeSecureKey(44)
        ..writeBuffer = Uint8List.fromList(
          testDecryptedKeyData1 + testDecryptedKeyData2,
        );

      final testLoginResponse = LoginResponse(token: testToken, user: testUser);

      setUp(() {
        testMainKey.disposed = false;
        testAccKey.disposed = false;
        testIdPrivKey.disposed = false;

        provideDummy(testLoginResponse);

        when(
          mockCryptoService.secureCopy(any),
        ).thenReturnInOrder([testAccKey, testIdPrivKey]);

        when(mockMainCM.encryptKey(any)).thenReturn(testEncryptedContent);
        when(mockMainCM.decryptKey(any)).thenReturn(testDecryptedKey);

        when(mockIdCM.pubkey).thenReturn(testIdPubKey);
        when(mockIdCM.privkey).thenReturn(testIdPrivKey);

        when(mockLoginCM.pubkey).thenReturn(testLoginPubKey);

        when(mockKeyDerivator.randomSalt()).thenReturn(testSalt);
        when(
          mockKeyDerivator.call(
            salt: anyNamed('salt'),
            password: anyNamed('password'),
          ),
        ).thenReturnAsync(testMainKey);
      });

      group('signup', () {
        final testCombinedKey = FakeSecureKey(55)
          ..writeBuffer = Uint8List(testAccKey.length + testIdPrivKey.length);
        const testSignupUser = EtebaseUser(
          username: testUserName,
          email: testEmail,
        );

        setUp(() {
          testCombinedKey.disposed = false;

          when(mockCryptoService.secureRandom(any)).thenReturn(testAccKey);
          when(mockCryptoService.secureAlloc(any)).thenReturn(testCombinedKey);

          when(
            mockAuthenticator.signup(any),
          ).thenReturnAsync(testLoginResponse);
        });

        test('signs up with server and creates account', () async {
          final result = await Account.signup(
            mockClient,
            testSignupUser,
            testPassword,
          );

          expect(result.accountCryptoManager, same(mockAccountCM));
          expect(result.identityCryptoManager, same(mockIdCM));
          expect(result.authToken, const AuthToken(testToken));

          verifyInOrder([
            // signup
            mockKeyDerivator.randomSalt(),
            mockKeyDerivator.call(salt: testSalt, password: testPassword),
            mockCryptoService.createMainCryptoManager(testMainKey),
            mockMainCM.createLoginCryptoManager(),
            mockCryptoService.createIdentityCryptoManager(),
            mockCryptoService.secureRandom(CryptoUtils.symmetricKeySize),
            mockIdCM.privkey,
            mockCryptoService.secureAlloc(
              testAccKey.length + testIdPrivKey.length,
            ),
            mockMainCM.encryptKey(testCombinedKey),
            mockAuthenticator.signup(
              SignupRequest(
                user: testSignupUser,
                salt: testSalt,
                loginPubkey: testLoginPubKey,
                pubkey: testIdPubKey,
                encryptedContent: testEncryptedContent,
              ),
            ),
            // create account
            mockMainCM.decryptKey(testEncryptedContent),
            mockCryptoService.secureCopy(testDecryptedKeyData1),
            mockCryptoService.secureCopy(testDecryptedKeyData2),
            mockMainCM.createAccountCryptoManager(testAccKey),
            mockMainCM.createIdentityCryptoManager(testIdPrivKey),
            // disposes
            mockLoginCM.dispose(),
            mockIdCM.dispose(),
          ]);
          verifyNever(mockMainCM.dispose());
          verifyNever(mockAccountCM.dispose());
          verifyNever(mockIdCM.dispose());

          expect(testCombinedKey.writeBuffer, concatenatedSecure(22, 33));
          expect(testCombinedKey.disposed, isTrue);
          expect(testDecryptedKey.disposed, isTrue);
          expect(testAccKey.disposed, isTrue);
          expect(testIdPrivKey.disposed, isFalse);
        });

        test('cleans up resources if login fails', () async {
          final testException = Exception('test-exception');

          when(mockAuthenticator.signup(any)).thenThrow(testException);

          await expectLater(
            () => Account.signup(mockClient, testSignupUser, testPassword),
            throwsA(testException),
          );

          verify(mockMainCM.dispose());
          verify(mockLoginCM.dispose());
          verify(mockIdCM.dispose());

          expect(testAccKey.disposed, isTrue);
          expect(testCombinedKey.disposed, isTrue);
        });
      });

      group('login', () {
        final testChallengeBytes = Uint8List.fromList([99, 45, 1]);
        const testVersion = 11;
        final testChallenge = LoginChallenge(
          challenge: testChallengeBytes,
          salt: testSalt,
          version: testVersion,
        );

        setUp(() {
          provideDummy(testChallenge);

          when(
            mockAuthenticator.loginChallenge(any),
          ).thenReturnAsync(testChallenge);

          when(mockAuthenticator.login(any)).thenReturnAsync(testLoginResponse);
        });

        test('logs in with server and creates account', () async {
          final testEncodedResponse = Uint8List.fromList([7, 54, 1]);
          final testSignature = Uint8List.fromList([12, 33, 1]);

          when(mockConverter.encode(any)).thenReturn(testEncodedResponse);
          when(mockLoginCM.signDetached(any)).thenReturn(testSignature);

          final result = await Account.login(
            mockClient,
            testUserName,
            testPassword,
          );

          expect(result.accountCryptoManager, same(mockAccountCM));
          expect(result.identityCryptoManager, same(mockIdCM));
          expect(result.authToken, const AuthToken(testToken));

          verifyInOrder([
            // challenge response
            mockAuthenticator.loginChallenge(
              const ChallengeRequest(username: testUserName),
            ),
            mockKeyDerivator.call(salt: testSalt, password: testPassword),
            mockCryptoService.createMainCryptoManager(
              testMainKey,
              version: testVersion,
            ),
            mockMainCM.createLoginCryptoManager(),
            mockConverter.encode(
              ChallengeResponse.login(
                username: testUserName,
                challenge: testChallengeBytes,
                host: 'example.com',
              ),
            ),
            mockLoginCM.signDetached(testEncodedResponse),
            mockLoginCM.dispose(),
            mockAuthenticator.login(
              LoginRequest(
                response: testEncodedResponse,
                signature: testSignature,
              ),
            ),
            // create account
            mockMainCM.decryptKey(testEncryptedContent),
            mockCryptoService.secureCopy(testDecryptedKeyData1),
            mockCryptoService.secureCopy(testDecryptedKeyData2),
            mockMainCM.createAccountCryptoManager(testAccKey),
            mockMainCM.createIdentityCryptoManager(testIdPrivKey),
          ]);

          verifyNever(mockMainCM.dispose());
          verifyNever(mockAccountCM.dispose());
          verifyNever(mockIdCM.dispose());

          expect(testDecryptedKey.disposed, isTrue);
          expect(testAccKey.disposed, isFalse);
          expect(testIdPrivKey.disposed, isFalse);
        });

        test('cleans up resources if login fails', () async {
          final testException = Exception('test-exception');

          when(mockAuthenticator.login(any)).thenThrow(testException);

          await expectLater(
            () => Account.login(mockClient, testUserName, testPassword),
            throwsA(testException),
          );

          verify(mockLoginCM.dispose());
          verify(mockMainCM.dispose());
        });
      });

      group('restore', () {
        final testAccountData = AccountData(
          user: testUser,
          authToken: testToken,
          serverUrl: testBaseUrl,
          version: 39,
          key: Uint8List.fromList([44, 123, 1]),
        );
        final testAccountDataBytes = Uint8List.fromList([4, 122, 1]);
        final testEncryptedData = Uint8List.fromList([9, 87, 213]);
        const testVersion = 93;
        final testAccountDataStored = AccountDataStored(
          version: testVersion,
          encryptedData: testEncryptedData,
        );
        const testAccountDataStoredData = 'test-account-data-stored';
        final testEncryptionKey = FakeSecureKey(123);
        final testAccountKey = FakeSecureKey(54);

        setUp(() {
          provideDummy(testAccountData);
          provideDummy(testAccountDataStored);

          when(
            mockConverter.decode64<AccountDataStored>(
              testAccountDataStoredData,
            ),
          ).thenReturn(testAccountDataStored);
          when(
            mockConverter.decode<AccountData>(testEncryptedData),
          ).thenReturn(testAccountData);

          when(
            mockStorageCM.decrypt(any, any),
          ).thenReturn(testAccountDataBytes);
          when(mockStorageCM.decryptKey(any)).thenReturn(testAccountKey);
        });

        test('restores account from raw data', () async {
          final result = await Account.restore(
            mockClient,
            testAccountDataStoredData,
            testEncryptionKey,
          );

          expect(result.accountCryptoManager, same(mockAccountCM));
          expect(result.identityCryptoManager, same(mockIdCM));
          expect(result.authToken, const AuthToken(testToken));

          verifyInOrder([
            mockConverter.decode64<AccountDataStored>(
              testAccountDataStoredData,
            ),
            mockCryptoService.createStorageCryptoManager(
              argThat(isKey(124)),
              version: testVersion,
            ),
            mockStorageCM.decrypt(
              testEncryptedData,
              CryptoUtils.uint32ToUint8List(testVersion),
            ),
            mockConverter.decode<AccountData>(testAccountDataBytes),
            mockStorageCM.decryptKey(testAccountData.key),
            mockCryptoService.createMainCryptoManager(
              testAccountKey,
              version: testAccountData.version,
            ),
            // create account
            mockMainCM.decryptKey(testEncryptedContent),
            mockCryptoService.secureCopy(testDecryptedKeyData1),
            mockCryptoService.secureCopy(testDecryptedKeyData2),
            mockMainCM.createAccountCryptoManager(testAccKey),
            mockMainCM.createIdentityCryptoManager(testIdPrivKey),
            // disposes
            mockStorageCM.dispose(),
          ]);
          verifyNever(mockMainCM.dispose());
          verifyNever(mockAccountCM.dispose());
          verifyNever(mockIdCM.dispose());
        });

        test('throws if base url does not match', () async {
          when(mockClient.baseUrl).thenReturn(Uri.http('localhost', '/other'));

          when(
            mockCryptoService.secureCopy(any),
          ).thenReturnInOrder([testEncryptionKey, testAccKey, testIdPrivKey]);

          await expectLater(
            () => Account.restore(mockClient, testAccountDataStoredData),
            throwsA(isA<ApiMissuse>()),
          );

          verifyInOrder([
            mockConverter.decode64<AccountDataStored>(
              testAccountDataStoredData,
            ),
            mockCryptoService.secureCopy(
              Uint8List.fromList(List.filled(CryptoUtils.symmetricKeySize, 0)),
            ),
            mockCryptoService.createStorageCryptoManager(
              testEncryptionKey,
              version: testVersion,
            ),
            mockStorageCM.decrypt(
              testEncryptedData,
              CryptoUtils.uint32ToUint8List(testVersion),
            ),
            mockConverter.decode<AccountData>(testAccountDataBytes),
            // disposes
            mockStorageCM.dispose(),
          ]);
          verifyNever(mockMainCM.dispose());
          verifyNever(mockAccountCM.dispose());
          verifyNever(mockIdCM.dispose());
        });
      });
    });

    group('members', () {
      // ignore: unused_local_variable
      late Account sut;

      setUp(() {
        sut = Account(
          mockClient,
          mockMainCM,
          testUser,
          testToken,
          mockAccountCM,
          mockIdCM,
        );
      });

      test('dispose disposes all attached managers and clears auth token', () {
        sut.dispose();

        verify(mockMainCM.dispose()).called(1);
        verify(mockAccountCM.dispose()).called(1);
        verify(mockIdCM.dispose()).called(1);

        expect(sut.authToken, AuthToken.empty);
      });

      test('collectionManager returns single CollectionManager', () {
        final result = sut.collectionManager;

        expect(result, isA<CollectionManager>());
        expect(sut.collectionManager, same(result));
      });

      test('invitationManager returns single CollectionInvitationManager', () {
        final result = sut.invitationManager;

        expect(result, isA<CollectionInvitationManager>());
        expect(sut.invitationManager, same(result));
      });

      test('fetchToken fetches and updates the auth token', () async {
        final testChallengeBytes = Uint8List.fromList([45, 4, 4]);
        final testEncodedResponse = Uint8List.fromList([44, 12, 3, 11]);
        final testSignature = Uint8List.fromList([32, 12, 22, 1]);
        const testNewTokenValue = 'test-new-auth-token-value';
        final testChallenge = LoginChallenge(
          challenge: testChallengeBytes,
          salt: Uint8List.fromList([2, 88]),
          version: 3,
        );
        final testLoginResponse = LoginResponse(
          token: testNewTokenValue,
          user: testUser,
        );

        provideDummy(testChallenge);
        provideDummy(testLoginResponse);

        when(mockConverter.encode(any)).thenReturn(testEncodedResponse);
        when(mockLoginCM.signDetached(any)).thenReturn(testSignature);
        when(
          mockAuthenticator.loginChallenge(any),
        ).thenReturnAsync(testChallenge);
        when(mockAuthenticator.login(any)).thenReturnAsync(testLoginResponse);

        await sut.fetchToken();

        expect(sut.authToken.value, testNewTokenValue);

        verifyInOrder([
          mockAuthenticator.loginChallenge(
            const ChallengeRequest(username: testUserName),
          ),
          mockMainCM.createLoginCryptoManager(),
          mockConverter.encode(
            ChallengeResponse.login(
              username: testUserName,
              challenge: testChallengeBytes,
              host: 'example.com',
            ),
          ),
          mockLoginCM.signDetached(testEncodedResponse),
          mockLoginCM.dispose(),
          mockAuthenticator.login(
            LoginRequest(
              response: testEncodedResponse,
              signature: testSignature,
            ),
          ),
        ]);
      });

      test('logout requests logout and disposes the account', () async {
        await sut.logout();

        verify(mockAuthenticator.logout(const AuthToken(testToken))).called(1);
        verify(mockMainCM.dispose()).called(1);
        verify(mockAccountCM.dispose()).called(1);
        verify(mockIdCM.dispose()).called(1);

        expect(sut.authToken, AuthToken.empty);
      });

      group('changePassword', () {
        const testNewPassword = 'new-password';
        final testNewKey = FakeSecureKey(56);
        final testEncodedResponse = Uint8List.fromList([44, 12, 3, 11]);
        final testSignature = Uint8List.fromList([32, 12, 22, 1]);
        final testEncodedAccountData = Uint8List.fromList([34, 44, 12]);
        final testNewEncryptedContent = Uint8List.fromList([123, 11, 2]);
        final testNewLoginPubKey = Uint8List.fromList([12, 1, 1, 9]);
        final testChallengeBytes = Uint8List.fromList([93, 123, 1]);
        final testSalt = Uint8List.fromList([45, 21, 11]);
        final testChallenge = LoginChallenge(
          challenge: testChallengeBytes,
          salt: testSalt,
          version: 3,
        );

        final mockMainCMNew = MockMainCryptoManager();
        final mockLoginCMNew = MockLoginCryptoManager();

        setUp(() {
          reset(mockMainCMNew);
          reset(mockLoginCMNew);

          provideDummy(testChallenge);

          when(mockConverter.encode(any)).thenReturn(testEncodedResponse);

          when(
            mockCryptoService.createMainCryptoManager(testNewKey),
          ).thenReturn(mockMainCMNew);

          when(
            mockKeyDerivator.call(
              salt: anyNamed('salt'),
              password: anyNamed('password'),
            ),
          ).thenReturnAsync(testNewKey);

          when(
            mockAuthenticator.loginChallenge(any),
          ).thenReturnAsync(testChallenge);

          when(mockMainCM.decrypt(any)).thenReturn(testEncodedAccountData);

          when(mockLoginCM.signDetached(any)).thenReturn(testSignature);

          when(
            mockMainCMNew.createLoginCryptoManager(),
          ).thenReturn(mockLoginCMNew);
          when(mockMainCMNew.encrypt(any)).thenReturn(testNewEncryptedContent);

          when(mockLoginCMNew.pubkey).thenReturn(testNewLoginPubKey);
        });

        test('updates password generated keys locally and on server', () async {
          await sut.changePassword(testNewPassword);

          verifyInOrder([
            mockAuthenticator.loginChallenge(
              const ChallengeRequest(username: testUserName),
            ),
            mockKeyDerivator.call(salt: testSalt, password: testNewPassword),
            mockCryptoService.createMainCryptoManager(testNewKey),
            mockMainCMNew.createLoginCryptoManager(),
            mockMainCM.decrypt(testEncryptedContent),
            mockMainCMNew.encrypt(testEncodedAccountData),
            mockMainCM.createLoginCryptoManager(),
            mockConverter.encode(
              ChallengeResponse.changePassword(
                username: testUserName,
                challenge: testChallengeBytes,
                host: 'example.com',
                loginPubkey: testNewLoginPubKey,
                encryptedContent: testNewEncryptedContent,
              ),
            ),
            mockLoginCM.signDetached(testEncodedResponse),
            mockLoginCM.dispose(),
            mockAuthenticator.changePassword(
              const AuthToken(testToken),
              LoginRequest(
                response: testEncodedResponse,
                signature: testSignature,
              ),
            ),
            mockLoginCMNew.dispose(),
            mockMainCM.dispose(),
          ]);
          verifyNever(mockMainCMNew.dispose());
        });

        test(
          'disposes newly created manager if authentication fails',
          () async {
            final testException = Exception('test-exception');

            when(
              mockAuthenticator.changePassword(any, any),
            ).thenThrow(testException);

            await expectLater(
              () => sut.changePassword(testNewPassword),
              throwsA(testException),
            );

            verify(mockLoginCMNew.dispose());
            verify(mockMainCMNew.dispose());
            verifyNever(mockMainCM.dispose());
          },
        );
      });

      test('fetchDashboardUrl requests the dashboard url', () async {
        final testUrl = Uri.http('example.com', '/dashboard');

        when(mockAuthenticator.getDashboardUrl(any)).thenReturnAsync(testUrl);

        final result = await sut.fetchDashboardUrl();

        verify(
          mockAuthenticator.getDashboardUrl(const AuthToken(testToken)),
        ).called(1);

        expect(result, testUrl);
      });

      group('save', () {
        test('return encrypted account data', () async {
          const testVersion = 121;
          final testEncryptionKey = FakeSecureKey(123);
          final testMainKey = FakeSecureKey(98);
          final testEncodedData = Uint8List.fromList([74, 23, 11]);
          final testEncryptedData = Uint8List.fromList([9, 87, 213]);
          final testEncryptedMainKey = Uint8List.fromList([99, 88, 12]);
          const testEncodedStoredData = 'test-data';

          when(mockConverter.encode(any)).thenReturn(testEncodedData);
          when(mockConverter.encode64(any)).thenReturn(testEncodedStoredData);

          when(mockMainCM.mainKey).thenReturn(testMainKey);
          when(mockMainCM.version).thenReturn(testVersion);
          when(mockStorageCM.encryptKey(any)).thenReturn(testEncryptedMainKey);
          when(mockStorageCM.encrypt(any, any)).thenReturn(testEncryptedData);

          final result = await sut.save(testEncryptionKey);

          expect(result, testEncodedStoredData);

          verifyInOrder([
            mockCryptoService.createStorageCryptoManager(argThat(isKey(124))),
            mockMainCM.mainKey,
            mockStorageCM.encryptKey(testMainKey),
            mockConverter.encode(
              AccountData(
                user: testUser,
                authToken: testToken,
                serverUrl: testBaseUrl,
                version: CryptoUtils.currentVersion,
                key: testEncryptedMainKey,
              ),
            ),
            mockMainCM.version,
            mockStorageCM.encrypt(
              testEncodedData,
              Uint8List.fromList([testVersion, 0, 0, 0]),
            ),
            mockConverter.encode64(
              AccountDataStored(
                version: CryptoUtils.currentVersion,
                encryptedData: testEncryptedData,
              ),
            ),
            mockStorageCM.dispose(),
          ]);
        });

        test('disposes storage cm on failure', () async {
          final testException = Exception('test');
          final testEmptyKey = FakeSecureKey(22);
          final testMainKey = FakeSecureKey(98);

          when(mockCryptoService.secureCopy(any)).thenReturn(testEmptyKey);

          when(mockMainCM.mainKey).thenReturn(testMainKey);
          when(mockStorageCM.encryptKey(any)).thenThrow(testException);

          await expectLater(() => sut.save(), throwsA(testException));

          verifyInOrder([
            mockCryptoService.secureCopy(
              Uint8List.fromList(List.filled(CryptoUtils.symmetricKeySize, 0)),
            ),
            mockCryptoService.createStorageCryptoManager(testEmptyKey),
            mockMainCM.mainKey,
            mockStorageCM.encryptKey(testMainKey),
            mockStorageCM.dispose(),
          ]);
        });
      });
    });
  });
}
