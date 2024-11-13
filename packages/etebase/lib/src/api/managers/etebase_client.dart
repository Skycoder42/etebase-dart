import 'package:sodium/sodium_sumo.dart';

import '../../impl/managers/client.dart';

/// The dart binding of the EtebaseClient rust class
abstract interface class EtebaseClient {
  /// The URL of the main hosted server
  static Uri get defaultServerUrl => Client.defaultUrl;

  /// Creates a new etebase client.
  factory EtebaseClient.create(
    SodiumSumo sodium, [
    Uri? serverUrl,
  ]) = Client.create;

  /// Returns true if client is pointing an etebase server, false if not
  Future<bool> checkEtebaseServer();

  /// Disposes of the instance and clear all cryptographic keys from memory.
  Future<void> dispose();
}
