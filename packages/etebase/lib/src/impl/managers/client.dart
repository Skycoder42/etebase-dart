import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../../api/managers/etebase_client.dart';
import '../codec/message_pack_converter.dart';
import '../crypto/crypto_service.dart';
import '../crypto/sync/crypto_service_sync.dart';
import '../online_managers/authenticator.dart';
import '../online_managers/base_network.dart';

@internal
class Client implements EtebaseClient, NetworkClient {
  static final defaultUrl = Uri.https('api.etebase.com');

  final bool _ownedClient;

  @override
  final http.Client httpClient;
  @override
  final MessagePackConverter converter;
  @override
  final Uri baseUri;
  final CryptoService crypto;

  Client(
    this.httpClient,
    this.baseUri,
    this.converter,
    this.crypto, {
    bool ownedClient = false,
  }) : _ownedClient = ownedClient;

  factory Client.create(
    SodiumSumo sodium, [
    Uri? serverUrl,
  ]) =>
      Client(
        http.Client(), serverUrl ?? defaultUrl,
        MessagePackConverter(),
        CryptoServiceSync(sodium), // TODO allow async
        ownedClient: true,
      );

  Authenticator get authenticator => Authenticator(client: this);

  @override
  Future<void> dispose() async {
    if (_ownedClient) {
      httpClient.close();
    }
    await crypto.dispose();
  }

  @override
  Future<bool> checkEtebaseServer() => authenticator.isEtebase();
}
