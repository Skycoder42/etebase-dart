import 'package:meta/meta.dart';

import '../../api/managers/etebase_client.dart';
import '../rest/etebase_api_client.dart';

@internal
class Client implements EtebaseClient {
  final String clientName; // TODO remove?

  final EtebaseApiClient _apiClient;

  Client(this.clientName, this._apiClient);

  factory Client.create(
    String clientName, [
    Uri? serverUrl,
  ]) =>
      Client(clientName, EtebaseApiClient(baseUrl: serverUrl));

  void dispose() {
    _apiClient.dispose();
  }

  @override
  Future<bool> checkEtebaseServer() async {
    final response = await _apiClient.accounts.isEtebase();
    return response.isSuccessful;
  }
}
