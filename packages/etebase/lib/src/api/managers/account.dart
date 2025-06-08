import 'package:sodium/sodium.dart';

import '../../impl/crypto/crypto_utils.dart';
import '../../impl/managers/account_impl.dart';
import '../../impl/managers/client_impl.dart';
import '../models/user.dart';
import 'client.dart';
import 'collection_invitation_manager.dart';
import 'collection_manager.dart';

/// The main object for all user interactions and data manipulation,
/// representing an authenticated user account.
abstract interface class Account {
  /// The length that the `encryptionKey` for [save] and [restore] must have.
  static const cacheKeyLength = CryptoUtils.symmetricKeySize;

  /// Authenticates a user using their [username] and [password] and returns an
  /// [Account] on success.
  static Future<Account> login(
    Client client,
    String username,
    String password,
  ) async => await AccountImpl.login(client as ClientImpl, username, password);

  /// Creates a new user on the server and returns a handle to it.
  ///
  /// The [user] is authenticated using the given [password].
  static Future<Account> signup(
    Client client,
    User user,
    String password,
  ) async => await AccountImpl.signup(client as ClientImpl, user, password);

  /// Deserialize and return the [Account] object from the
  /// [accountDataStored] obtained using [save].
  ///
  /// The [encryptionKey] must be the same as used for [save].
  static Future<Account> restore(
    Client client,
    String accountDataStored, [
    SecureKey? encryptionKey,
  ]) => (client as ClientImpl).restoreAccount(accountDataStored, encryptionKey);

  /// Return a [CollectionManager] for creating, fetching and uploading
  /// collections.
  CollectionManager get collectionManager;

  /// Return a [CollectionInvitationManager] for managing collection
  /// invitations.
  CollectionInvitationManager get invitationManager;

  /// Disposes of the instance and clears all cryptographic keys from memory.
  void dispose();

  /// Fetch a new auth token for the account and update the [Account]
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
  /// data. The key should have [cacheKeyLength] bytes.
  /// {@endtemplate}
  Future<String> save([SecureKey? encryptionKey]);
}
