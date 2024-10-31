import 'package:sodium/sodium.dart';

import '../../impl/managers/account.dart';
import '../../impl/managers/client.dart';
import '../models/etebase_user.dart';
import 'etebase_client.dart';
import 'etebase_collection_invitation_manager.dart';
import 'etebase_collection_manager.dart';

/// The dart binding of the EtebaseAccount rust class
abstract interface class EtebaseAccount {
  /// Login a user and return a handle to an `EtebaseAccount` object
  ///
  /// @param client the already setup `EtebaseClient` object
  /// @param username the user's username. This is not the same as the user's email.
  /// @param password the user's password
  static Future<EtebaseAccount> login(
    EtebaseClient client,
    String username,
    String password,
  ) async =>
      await Account.login(client as Client, username, password);

  /// Signup a new user account and return a handle to it
  ///
  /// @param client the already setup `EtebaseClient` object
  /// @param user the already setup `EtebaseUser` object
  /// @param password the password to signup with
  static Future<EtebaseAccount> signup(
    EtebaseClient client,
    EtebaseUser user,
    String password,
  ) async =>
      await Account.signup(client as Client, user, password);

  /// Disposes of the instance and clear all cryptographic keys from memory.
  Future<void> dispose();

  /// Fetch a new auth token for the account and update the `EtebaseAccount` object with it
  ///
  /// @param this_ the object handle
  Future<void> fetchToken();

  /// Fetch the link to the user dashboard of the account
  ///
  /// @param this_ the object handle
  Future<Uri> fetchDashboardUrl();

  /// Change the user's login password
  ///
  /// @param this_ the object handle
  /// @param password the new password to be set
  Future<void> changePassword(String password);

  /// Logout the user from the current session and invalidate the authentication token
  ///
  /// @param this_ the object handle
  Future<void> logout();

  /// Return a `EtebaseCollectionManager` for creating, fetching and uploading collections
  ///
  /// @param this_ the object handle
  EtebaseCollectionManager get collectionManager;

  /// Return a `EtebaseCollectionInvitationManager` for managing collection invitations
  ///
  /// @param this_ the object handle
  EtebaseCollectionInvitationManager get invitationManager;

  /// Save the account object to a string for restoring it later using `etebase_account_restore`
  ///
  /// @param this_ the object handle
  /// @param encryption_key used to encrypt the returned account string to enhance security
  /// @param encryption_key_size size of the encryption_key
  String save([SecureKey? encryptionKey]);

  /// Restore and return the account object from the string obtained using `etebase_account_save`
  ///
  /// @param client the already setup `EtebaseClient` object
  /// @param account_data_stored the stored account string
  /// @param encryption_key the same encryption key passed to `etebase_account_save` while saving the account
  /// @param encryption_key_size size of the encryption_key
  static EtebaseAccount restore(
    EtebaseClient client,
    String accountDataStored, [
    SecureKey? encryptionKey,
  ]) =>
      throw UnimplementedError();
}
