// ignore_for_file: unnecessary_lambdas
@TestOn('!windows')
library;

// ignore: no_self_package_imports
import 'package:etebase/etebase.dart';
import 'package:test/test.dart';

import 'util/js_client_wrapper.dart';
import 'util/library_loader.dart';

void main() {
  late final EtebaseClient client;

  setUpAll(() async {
    client = await createClient();
  });

  tearDownAll(() async {
    await client.dispose();
  });

  group('etebase account tests', () {
    final testUsername = generateUsername('test-user-1');
    final testEmail = '$testUsername@example.com';
    const testPassword = 'hello-test-1';

    test('can create new account', () async {
      final account = await EtebaseAccount.signup(
        client,
        User(username: testUsername, email: testEmail),
        testPassword,
      );
      addTearDown(account.dispose);

      // local test server does not have a dashboard
      expect(() => account.fetchDashboardUrl(), throwsA(isA<HttpFailure>()));

      // validate js client can login
      await JsClientWrapper.execute<void>(
        Action.signIn(testUsername, testPassword),
      );

      await account.logout();

      // after logout this should be unauthorized
      expect(() => account.fetchDashboardUrl(), throwsA(isA<Unauthorized>()));
    });

    test('can login with existing account', () async {
      final account = await EtebaseAccount.login(
        client,
        testUsername,
        testPassword,
      );
      addTearDown(account.dispose);

      // update password
      const testUpdatePassword = 'updated-password';
      await account.changePassword(testUpdatePassword);

      // update token
      await account.fetchToken();

      // change password again
      await account.changePassword(testPassword);

      await account.logout();
    });

    test('can login with account created from different client', () async {
      final testOtherUsername = generateUsername('test-user-2');
      final testOtherEmail = '$testUsername@example.com';
      const testOtherPassword = 'hello-test-2';

      // create account via js
      await JsClientWrapper.execute<void>(
        Action.signUp(testOtherUsername, testOtherEmail, testOtherPassword),
      );

      final account = await EtebaseAccount.login(
        client,
        testOtherUsername,
        testOtherPassword,
      );
      addTearDown(account.dispose);

      // update token
      await account.fetchToken();

      await account.logout();
    });

    test('can save and restore account', () async {
      final account = await EtebaseAccount.login(
        client,
        testUsername,
        testPassword,
      );
      addTearDown(account.dispose);

      final savedAccount = await account.save();
      final restoredAccount = await EtebaseAccount.restore(
        client,
        savedAccount,
      );
      addTearDown(restoredAccount.dispose);
      await restoredAccount.fetchToken();

      expect(
        () => account.save(client.randomKey(64)),
        throwsA(isA<ArgumentError>()),
      );

      final encryptionKey = client.randomKey(32);
      final savedAccountEnc = await account.save(encryptionKey);
      final restoredAccountEnc = await EtebaseAccount.restore(
        client,
        savedAccountEnc,
        encryptionKey,
      );
      addTearDown(restoredAccountEnc.dispose);
      await restoredAccountEnc.fetchToken();

      await restoredAccountEnc.logout();
    });

    test('can save and restore account from different client', () async {
      final encryptionKey1 = client.randomKey(32);
      final jsSaved = await JsClientWrapper.execute<String>(
        Action.saveAccount(
          testUsername,
          testPassword,
          encryptionKey1.extractBytes(),
        ),
      );

      expect(jsSaved, isNotEmpty);

      final restoredAccount = await EtebaseAccount.restore(
        client,
        jsSaved,
        encryptionKey1,
      );
      addTearDown(restoredAccount.dispose);
      await restoredAccount.fetchToken();

      final dartAccount = await EtebaseAccount.login(
        client,
        testUsername,
        testPassword,
      );
      final encryptionKey2 = client.randomKey(32);
      final dartSaved = await dartAccount.save(encryptionKey2);

      await JsClientWrapper.execute<void>(
        Action.restoreAccount(dartSaved, encryptionKey2.extractBytes()),
      );
    });
  });
}
