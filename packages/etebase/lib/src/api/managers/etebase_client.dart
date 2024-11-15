import 'package:sodium/sodium_sumo.dart';

import '../../impl/managers/client.dart';
import '../models/etebase_item_metadata.dart';

typedef MetaFromJson<TMeta extends EtebaseItemMetadata> = TMeta Function(
  Map<String, dynamic> json,
);

/// The network client to use to interact with the Etebase server
///
/// This is in charge of actually connecting to the server and making network
/// requests. Uses the [package:http](https://pub.dev/packages/http).
abstract interface class EtebaseClient {
  /// The URL of the main hosted server.
  static Uri get defaultServerUrl => Client.defaultUrl;

  /// Creates a new client object for the server located at [serverUrl].
  ///
  /// The [sodium] instance is required to perform cryptographic operations.
  /// See [package:sodium](https://pub.dev/packages/sodium) for how to get such
  /// an instance. The [clientName] will be used to populate the `User-Agent`
  /// header in all requests to the server.
  ///
  /// If no [serverUrl] is provided, the [defaultServerUrl] is used.
  factory EtebaseClient.create(
    SodiumSumo sodium,
    String clientName, [
    Uri? serverUrl,
  ]) = Client.create;

  /// Returns true if client is pointing an etebase server, false if not
  Future<bool> checkEtebaseServer();

  /// Disposes of the instance and clear all cryptographic keys from memory.
  Future<void> dispose();

  /// registers a new item metadata type for this client.
  void registerCustomMetadata<TMeta extends EtebaseItemMetadata>(
    MetaFromJson<TMeta> fromJson,
  );
}
