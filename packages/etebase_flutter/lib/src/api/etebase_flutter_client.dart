import 'package:etebase/etebase.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../impl/flutter_client.dart';

/// The network client to use to interact with the Etebase server.
///
/// This is in charge of actually connecting to the server and making network
/// requests. Uses the [package:http](https://pub.dev/packages/http).
///
/// Unlike the [Client], this client automatically initializes
/// libsodium and the client name from information gathered by flutter.
abstract interface class EtebaseFlutterClient implements Client {
  /// Creates a new client object for the server located at [serverUrl].
  ///
  /// {@template other_params}
  /// If no [serverUrl] is provided, the [Client.defaultServerUrl] is
  /// used. By default, [Hive] is initialized automatically when calling create
  /// to to `"etebase"` subdir. This is fine as long as you do not use hive
  /// anywhere else in your app. If you do, you might want to set [autoInitHive]
  /// to `false` and initialize hive yourself.
  ///
  /// *Note:* hive is used by the [Cache]. If you do not use this cache,
  /// it does not need to be initialized.
  /// {@endtemplate}
  static Future<Client> create({
    Uri? serverUrl,
    bool autoInitHive = true,
  }) async {
    await FlutterClient.hiveInit(autoInitHive);
    return FlutterClient.create(
      CryptoExecutor.sync(await FlutterClient.sodiumInstance),
      await FlutterClient.clientName,
      serverUrl,
    );
  }

  /// Creates a new client object for the server located at [serverUrl].
  ///
  /// This client differs from [EtebaseFlutterClient.create] in that it will
  /// execute all cryptographic operations on a separate worker isolate. For
  /// must usecases, this will be slower, as the data transfer between the
  /// isolates takes longer. Only use this if you are going to process items
  /// with large contents in a context where blocking the main thread for a few
  /// milliseconds would be a problem!
  ///
  /// {@macro other_params}
  static Future<Client> createAsync({
    Uri? serverUrl,
    bool autoInitHive = true,
  }) async {
    await FlutterClient.hiveInit(autoInitHive);
    return FlutterClient.create(
      await CryptoExecutor.async(await FlutterClient.sodiumInstance),
      await FlutterClient.clientName,
      serverUrl,
    );
  }

  /// Creates a new client object for the server located at [serverUrl] with a
  /// custom [cryptoExecutor].
  ///
  /// This constructor allows you to pass your own [CryptoExecutor]
  /// implementation, in case you need to further customize the threading
  /// behavior (for example, if you want to use an isolate pool instead of a
  /// single isolate or need more control over the background execution).
  ///
  /// {@macro other_params}
  static Future<Client> createCustom(
    CryptoExecutor cryptoExecutor, {
    Uri? serverUrl,
    bool autoInitHive = true,
  }) async {
    await FlutterClient.hiveInit(autoInitHive);
    return FlutterClient.create(
      cryptoExecutor,
      await FlutterClient.clientName,
      serverUrl,
    );
  }
}
