import 'dart:typed_data';

import 'package:sodium/sodium_sumo.dart';

import '../../impl/crypto/crypto_service.dart';
import '../../impl/crypto/crypto_utils.dart';
import '../../impl/managers/client_impl.dart';
import '../models/item_metadata.dart';
import 'crypto_executor.dart';

/// A callback that takes a [json] map and returns an instance of a type that
/// implements [ItemMetadata].
typedef MetaFromJson<TMeta extends ItemMetadata> =
    TMeta Function(Map<String, dynamic> json);

/// The network client to use to interact with the Etebase server.
///
/// This is in charge of actually connecting to the server and making network
/// requests. Uses the [package:http](https://pub.dev/packages/http).
abstract interface class Client {
  /// The URL of the main hosted server.
  static Uri get defaultServerUrl => ClientImpl.defaultUrl;

  /// The current version of the internal data model.
  static const currentVersion = CryptoUtils.currentVersion;

  /// The default delimiter used for separating segments of a fingerprint
  static const defaultFingerprintDelimiter =
      CryptoService.defaultFingerprintDelimiter;

  /// Creates a new client object for the server located at [serverUrl].
  ///
  /// {@template client_create_sodium}
  /// The [sodium] instance is required to perform cryptographic operations.
  /// See [package:sodium](https://pub.dev/packages/sodium) for how to get such
  /// an instance.
  /// {@endtemplate}
  ///
  /// {@template client_create_others}
  /// The [clientName] will be used to populate the `User-Agent` header in all
  /// requests to the server. If no [serverUrl] is provided, the
  /// [defaultServerUrl] is used.
  /// {@endtemplate}
  factory Client.create(
    SodiumSumo sodium,
    String clientName, [
    Uri? serverUrl,
  ]) => ClientImpl.create(CryptoExecutor.sync(sodium), clientName, serverUrl);

  /// Creates a new client object for the server located at [serverUrl].
  ///
  /// This client differs from [Client.create] in that it will execute
  /// all cryptographic operations on a separate worker isolate. For must
  /// usecases, this will be slower, as the data transfer between the isolates
  /// takes longer. Only use this if you are going to process items with large
  /// contents in a context where blocking the main thread for a few
  /// milliseconds would be a problem!
  ///
  /// {@macro client_create_sodium}
  ///
  /// {@macro client_create_others}
  static Future<Client> createAsync(
    SodiumSumo sodium,
    String clientName, [
    Uri? serverUrl,
  ]) async => ClientImpl.create(
    await CryptoExecutor.async(sodium),
    clientName,
    serverUrl,
  );

  /// Creates a new client object for the server located at [serverUrl] with a
  /// custom [cryptoExecutor].
  ///
  /// This constructor allows you to pass your own [CryptoExecutor]
  /// implementation, in case you need to further customize the threading
  /// behavior (for example, if you want to use an isolate pool instead of a
  /// single isolate or need more control over the background execution).
  ///
  /// {@macro client_create_others}
  factory Client.createCustom(
    CryptoExecutor cryptoExecutor,
    String clientName, [
    Uri? serverUrl,
  ]) = ClientImpl.create;

  /// Disposes of the instance and clears all cryptographic keys from memory.
  Future<void> dispose();

  /// Checks whether the client is pointing to a valid Etebase server.
  Future<bool> checkEtebaseServer();

  /// Return a buffer of [size] (in bytes) filled with cryptographically random
  /// bytes.
  Uint8List randombytes(int size);

  /// Return a buffer of [size] (in bytes) filled with cryptographically random
  /// bytes as a [SecureKey].
  SecureKey randomKey(int size);

  /// Return a pretty formatted fingerprint of the [content].
  ///
  /// For example:
  /// ```plain
  /// 45680   71497   88570   93128
  /// 19189   84243   25687   20837
  /// 47924   46071   54113   18789
  /// ```
  String prettyFingerprint(
    Uint8List content, [
    String delimiter = defaultFingerprintDelimiter,
  ]);

  /// Registers a new item metadata type [TMeta] for this client.
  ///
  /// The [fromJson] factory must be able to convert a JSON map to a metadata
  /// object that implements [ItemMetadata].
  void registerCustomMetadata<TMeta extends ItemMetadata>(
    MetaFromJson<TMeta> fromJson,
  );
}
