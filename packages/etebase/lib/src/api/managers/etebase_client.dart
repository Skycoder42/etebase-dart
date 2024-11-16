import 'package:sodium/sodium_sumo.dart';

import '../../impl/managers/client.dart';
import '../models/etebase_item_metadata.dart';

/// A callback that takes a [json] map and returns an instance of a type that
/// implements [EtebaseItemMetadata].
typedef MetaFromJson<TMeta extends EtebaseItemMetadata> = TMeta Function(
  Map<String, dynamic> json,
);

/// The network client to use to interact with the Etebase server.
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

  /// Checks whether the client is pointing to a valid Etebase server.
  Future<bool> checkEtebaseServer();

  /// Disposes of the instance and clear all cryptographic keys from memory.
  Future<void> dispose();

  /// Registers a new item metadata type [TMeta] for this client.
  ///
  /// The [fromJson] factory must be able to convert a JSON map to a metadata
  /// object that implements [EtebaseItemMetadata].
  void registerCustomMetadata<TMeta extends EtebaseItemMetadata>(
    MetaFromJson<TMeta> fromJson,
  );
}
