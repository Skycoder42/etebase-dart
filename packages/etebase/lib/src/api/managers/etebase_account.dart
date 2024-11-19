import 'dart:typed_data';

import 'package:sodium/sodium.dart';

import '../../impl/managers/account.dart';
import '../../impl/managers/client.dart';
import '../models/etebase_user.dart';
import 'etebase_client.dart';
import 'etebase_collection_invitation_manager.dart';
import 'etebase_collection_manager.dart';

/// The main object for all user interactions and data manipulation,
/// representing an authenticated user account.
abstract interface class EtebaseAccount {
  /// Authenticates a user using their [username] and [password] and returns an
  /// [EtebaseAccount] on success.
  static Future<EtebaseAccount> login(
    EtebaseClient client,
    String username,
    String password,
  ) async =>
      await Account.login(client as Client, username, password);

  /// Creates a new user on the server and returns a handle to it.
  ///
  /// The [user] is authenticated using the given [password].
  static Future<EtebaseAccount> signup(
    EtebaseClient client,
    EtebaseUser user,
    String password,
  ) async =>
      await Account.signup(client as Client, user, password);

  /// Deserialize and return the [EtebaseAccount] object from the
  /// [accountDataStored] obtained using [save].
  ///
  /// The [encryptionKey] must be the same as used for [save].
  static Future<EtebaseAccount> restore(
    EtebaseClient client,
    Uint8List accountDataStored, [
    SecureKey? encryptionKey,
  ]) =>
      Account.restore(client as Client, accountDataStored, encryptionKey);

  /// Return a [EtebaseCollectionManager] for creating, fetching and uploading
  /// collections.
  EtebaseCollectionManager get collectionManager;

  /// Return a [EtebaseCollectionInvitationManager] for managing collection
  /// invitations.
  EtebaseCollectionInvitationManager get invitationManager;

  /// Disposes of the instance and clears all cryptographic keys from memory.
  void dispose();

  /// Fetch a new auth token for the account and update the [EtebaseAccount]
  /// object with it.
  Future<void> fetchToken();

  /// Fetch the link to the user dashboard of the account.
  Future<Uri> fetchDashboardUrl();

  /// Change the user's login password.
  ///
  /// The [password] is the new password that should be used from now on.
  Future<void> changePassword(String password);

  /// Logout the user from the current session and invalidate the
  /// authentication token.
  Future<void> logout();

  /// Serializes the account object to a string for restoring it later using
  /// [restore].
  ///
  /// {@template encryption_key}
  /// You can optionally pass an [encryptionKey] to encrypt the account data
  /// with. It is recommended you always provide such a key to protect the users
  /// data.
  /// {@endtemplate}
  Future<Uint8List> save([SecureKey? encryptionKey]);
}
