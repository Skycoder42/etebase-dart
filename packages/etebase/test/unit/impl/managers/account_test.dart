// ignore_for_file: discarded_futures

import 'dart:typed_data';

import 'package:etebase/src/api/models/etebase_user.dart';
import 'package:etebase/src/impl/codec/message_pack_converter.dart';
import 'package:etebase/src/impl/crypto/account_crypto_manager.dart';
import 'package:etebase/src/impl/crypto/box_crypto_manager.dart';
import 'package:etebase/src/impl/crypto/crypto_service.dart';
import 'package:etebase/src/impl/crypto/crypto_utils.dart';
import 'package:etebase/src/impl/crypto/key_derivator.dart';
import 'package:etebase/src/impl/crypto/login_crypto_manager.dart';
import 'package:etebase/src/impl/crypto/main_crypto_manager.dart';
import 'package:etebase/src/impl/managers/account.dart';
import 'package:etebase/src/impl/managers/client.dart';
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

// ignore: directives_ordering
import '../../test_helpers.dart';
import '../crypto/crypto_mocks.dart';
@GenerateNiceMocks([
  MockSpec<Client>(),
  MockSpec<MainCryptoManager>(),
  MockSpec<AccountCryptoManager>(),
  MockSpec<BoxCryptoManager>(),
  MockSpec<LoginCryptoManager>(),
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
    });
  });
}
