// ignore_for_file: discarded_futures

import 'dart:typed_data';

import 'package:etebase/src/api/models/etebase_user.dart';
import 'package:etebase/src/impl/crypto/account_crypto_manager.dart';
import 'package:etebase/src/impl/crypto/box_crypto_manager.dart';
import 'package:etebase/src/impl/crypto/crypto_service.dart';
import 'package:etebase/src/impl/crypto/crypto_utils.dart';
import 'package:etebase/src/impl/crypto/key_derivator.dart';
import 'package:etebase/src/impl/crypto/login_crypto_manager.dart';
import 'package:etebase/src/impl/crypto/main_crypto_manager.dart';
import 'package:etebase/src/impl/managers/account.dart';
import 'package:etebase/src/impl/managers/client.dart';
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
])
import 'account_test.mocks.dart';

void main() {
  group('$Account', () {
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
    final testLoginResponse = LoginResponse(token: testToken, user: testUser);

    final mockClient = MockClient();
    final mockMainCM = MockMainCryptoManager();
    final mockAccountCM = MockAccountCryptoManager();
    final mockBoxCM = MockBoxCryptoManager();
    final mockLoginCM = MockLoginCryptoManager();
    final mockCryptoService = MockCryptoService();
    final mockKeyDerivator = MockKeyDerivator();
    final mockAuthenticator = MockAuthenticator();

    setUpAll(() {
      provideDummy(testLoginResponse);
    });

    setUp(() {
      reset(mockClient);
      reset(mockMainCM);
      reset(mockAccountCM);
      reset(mockBoxCM);
      reset(mockLoginCM);
      reset(mockCryptoService);
      reset(mockKeyDerivator);
      reset(mockAuthenticator);

      when(mockClient.crypto).thenReturn(mockCryptoService);
      when(mockClient.authenticator).thenReturn(mockAuthenticator);

      when(mockCryptoService.keyDerivator).thenReturn(mockKeyDerivator);
      when(
        mockCryptoService.createMainCryptoManager(any),
      ).thenReturn(mockMainCM);
      when(
        mockCryptoService.createIdentityCryptoManager(any),
      ).thenReturn(mockBoxCM);

      when(mockMainCM.createLoginCryptoManager()).thenReturn(mockLoginCM);
      when(
        mockMainCM.createAccountCryptoManager(any),
      ).thenReturn(mockAccountCM);
      when(mockMainCM.createIdentityCryptoManager(any)).thenReturn(mockBoxCM);
    });

    group('signup', () {
      final testSalt = Uint8List.fromList([4, 5, 12, 44]);
      final testMainKey = FakeSecureKey(11);
      final testAccKey = FakeSecureKey(22);
      final testIdPrivKey = FakeSecureKey(33);
      final testIdPubKey = Uint8List.fromList([23, 1, 1, 9]);
      final testLoginPubKey = Uint8List.fromList([32, 77, 1]);

      setUp(() {
        when(mockKeyDerivator.randomSalt()).thenReturn(testSalt);
        when(
          mockKeyDerivator.call(
            salt: anyNamed('salt'),
            password: anyNamed('password'),
          ),
        ).thenReturnAsync(testMainKey);

        when(mockCryptoService.secureRandom(any)).thenReturn(testAccKey);

        when(mockBoxCM.pubkey).thenReturn(testIdPubKey);
        when(mockBoxCM.privkey).thenReturn(testIdPrivKey);

        when(mockLoginCM.pubkey).thenReturn(testLoginPubKey);

        when(mockAuthenticator.signup(any)).thenReturnAsync(testLoginResponse);
      });

      test('signs up with server and creates account', () async {
        const testSignupUser = EtebaseUser(
          username: testUserName,
          email: testEmail,
        );
        final testCombinedKey = FakeSecureKey(44)
          ..writeBuffer = Uint8List(testAccKey.length + testIdPrivKey.length);
        final testDecryptedKeyData1 = Uint8List.fromList(
          List.generate(32, (i) => i),
        );
        final testDecryptedKeyData2 = Uint8List.fromList(
          List.generate(32, (i) => 32 + i),
        );
        final testDecryptedKey = FakeSecureKey(55)
          ..writeBuffer = Uint8List.fromList(
            testDecryptedKeyData1 + testDecryptedKeyData2,
          );

        when(mockCryptoService.secureAlloc(any)).thenReturn(testCombinedKey);
        when(
          mockCryptoService.secureCopy(any),
        ).thenReturnInOrder([testAccKey, testIdPrivKey]);

        when(mockMainCM.encryptKey(any)).thenReturn(testEncryptedContent);
        when(mockMainCM.decryptKey(any)).thenReturn(testDecryptedKey);

        final result = await Account.signup(
          mockClient,
          testSignupUser,
          testPassword,
        );

        verifyInOrder([
          // signup
          mockKeyDerivator.randomSalt(),
          mockKeyDerivator.call(salt: testSalt, password: testPassword),
          mockCryptoService.createMainCryptoManager(testMainKey),
          mockMainCM.createLoginCryptoManager(),
          mockCryptoService.createIdentityCryptoManager(),
          mockCryptoService.secureRandom(CryptoUtils.symmetricKeySize),
          mockBoxCM.privkey,
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
          mockBoxCM.dispose(),
        ]);
        verifyNever(mockMainCM.dispose());
        verifyNever(mockAccountCM.dispose());
        verifyNever(mockBoxCM.dispose());

        expect(testCombinedKey.writeBuffer, concatenatedSecure(22, 33));
        expect(testCombinedKey.disposed, isTrue);
        expect(testDecryptedKey.disposed, isTrue);
        expect(testAccKey.disposed, isTrue);
        expect(testIdPrivKey.disposed, isFalse);
      });
    });

    group('members', () {
      late Account sut;

      setUp(() {
        sut = Account(
          mockClient,
          mockMainCM,
          testUser,
          testToken,
          mockAccountCM,
          mockBoxCM,
        );
      });
    });
  });
}
