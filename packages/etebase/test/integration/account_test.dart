// ignore_for_file: unnecessary_lambdas
@TestOn('!windows')
library account_test;

// ignore: test_library_import
import 'package:etebase/etebase.dart';
import 'package:test/test.dart';

import 'util/library_loader.dart';
import 'util/matchers.dart';
import 'util/server_controller.dart';

void main() {
  late final Uri serverUri;

  setUpAll(() async {
    await Etebase.ensureInitialized(loadLibEtebase);
    serverUri = await ServerController().start();
  });

  group('etebase client and account tests', () {
    late EtebaseClient client;

    setUp(() async {
      client = await EtebaseClient.create('account-test', serverUri);
      addTearDown(client.dispose);
    });

    test('client checkEtebaseServer can validate server', () async {
      final result = await client.checkEtebaseServer();
      expect(result, isTrue);
    });

    test('can change server URL', () async {
      await client.setServerUrl(await etebaseGetDefaultServerUrl());
      expect(await client.checkEtebaseServer(), isTrue);
    });

    group('account', () {
      const testUsername = 'test-user';
      const testEmail = 'test.user@example.com';
      const testPassword = 'hello-test-1';

      test('can create and update user', () async {
        final user = await EtebaseUser.create(testUsername, testEmail);
        addTearDown(user.dispose);

        expect(await user.getUsername(), testUsername);
        expect(await user.getEmail(), testEmail);

        const testUsername2 = 'test-user-2';
        const testEmail2 = 'test.user.2@example.com';
        await user.setUsername(testUsername2);
        await user.setEmail(testEmail2);

        expect(await user.getUsername(), testUsername2);
        expect(await user.getEmail(), testEmail2);
      });

      test('can create new account', () async {
        final user = await EtebaseUser.create(
          testUsername,
          testEmail,
        );
        addTearDown(user.dispose);

        final account = await EtebaseAccount.signup(client, user, testPassword);
        addTearDown(account.dispose);

        // local test server does not have a dashboard
        expect(
          () => account.fetchDashboardUrl(),
          throwsEtebaseException(EtebaseErrorCode.http),
        );

        await account.logout();

        // after logout this should be unauthorized
        expect(
          () => account.fetchDashboardUrl(),
          throwsEtebaseException(EtebaseErrorCode.unauthorized),
        );
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

        await restoredAccount
            .forceServerUrl(await etebaseGetDefaultServerUrl());

        expect(
          () async => account.save(await EtebaseUtils.randombytes(64)),
          throwsA(isA<ArgumentError>()),
        );

        final encryptionKey = await EtebaseUtils.randombytes(32);
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
    });
  });
}
