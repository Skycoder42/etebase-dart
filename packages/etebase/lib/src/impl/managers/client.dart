import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../../api/managers/crypto_executor.dart';
import '../../api/managers/etebase_client.dart';
import '../../api/models/etebase_item_metadata.dart';
import '../codec/message_pack_converter.dart';
import '../crypto/crypto_service.dart';
import '../online_managers/authenticator.dart';
import '../online_managers/base_network.dart';

@internal
class Client implements EtebaseClient, NetworkClient {
  static final defaultUrl = Uri.https('api.etebase.com');

  final bool _ownedClient;

  @override
  final http.Client httpClient;
  @override
  final String clientName;
  @override
  final MessagePackConverter converter;
  @override
  final Uri baseUri;
  final CryptoService crypto;

  Client(
    this.httpClient,
    this.clientName,
    this.baseUri,
    this.converter,
    this.crypto, {
    bool ownedClient = false,
  }) : _ownedClient = ownedClient;

  factory Client.create(
    CryptoExecutor cryptoExecutor,
    String clientName, [
    Uri? serverUrl,
  ]) =>
      Client(
        http.Client(),
        clientName,
        serverUrl ?? defaultUrl,
        MessagePackConverter(),
        CryptoService(cryptoExecutor),
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

  @override
  void registerCustomMetadata<TMeta extends EtebaseItemMetadata>(
    MetaFromJson<TMeta> fromJson,
  ) =>
      converter.addCustom<TMeta>(fromJson);
}
