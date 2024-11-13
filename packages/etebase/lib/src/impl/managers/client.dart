import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../../api/managers/etebase_client.dart';
import '../codec/message_pack_converter.dart';
import '../crypto/crypto_service.dart';
import '../crypto/sync/crypto_service_sync.dart';
import '../rest/etebase_api_client.dart';

@internal
class Client implements EtebaseClient {
  final EtebaseApiClient api;
  final CryptoService crypto;
  final MessagePackConverter coder;

  Client(
    this.api,
    this.crypto,
    this.coder,
  );

  factory Client.create(
    SodiumSumo sodium, [
    Uri? serverUrl,
  ]) =>
      Client(
        EtebaseApiClient(baseUrl: serverUrl),
        CryptoServiceSync(sodium), // TODO allow async
        MessagePackConverter(),
      );

  @override
  Future<void> dispose() async {
    api.dispose();
    await crypto.dispose();
  }

  @override
  Future<bool> checkEtebaseServer() async {
    final response = await api.authentication.isEtebase();
    return response.isSuccessful;
  }
}
