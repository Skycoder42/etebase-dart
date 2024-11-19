import 'package:etebase/etebase.dart';

import '../impl/flutter_client.dart';

abstract interface class EtebaseFlutterClient implements EtebaseClient {
  static Future<EtebaseClient> create([
    Uri? serverUrl,
  ]) async =>
      FlutterClient.create(
        CryptoExecutor.sync(await FlutterClient.sodiumInstance),
        await FlutterClient.clientName,
        serverUrl,
      );

  static Future<EtebaseClient> createAsync([
    Uri? serverUrl,
  ]) async =>
      FlutterClient.create(
        await CryptoExecutor.async(await FlutterClient.sodiumInstance),
        await FlutterClient.clientName,
        serverUrl,
      );

  static Future<EtebaseClient> createCustom(
    CryptoExecutor cryptoExecutor, [
    Uri? serverUrl,
  ]) async =>
      FlutterClient.create(
        cryptoExecutor,
        await FlutterClient.clientName,
        serverUrl,
      );
}
