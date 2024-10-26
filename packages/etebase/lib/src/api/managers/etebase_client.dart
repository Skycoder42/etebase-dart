import '../../impl/managers/client.dart';
import '../../impl/rest/etebase_api_client.dart';

/// The dart binding of the EtebaseClient rust class
abstract interface class EtebaseClient {
  /// The URL of the main hosted server
  static Uri get defaultServerUrl => EtebaseApiClient.defaultUrl;

  /// Creates a new etebase client.
  factory EtebaseClient.create(
    String clientName, [
    Uri? serverUrl,
  ]) = Client.create;

  /// Returns true if client is pointing an etebase server, false if not
  Future<bool> checkEtebaseServer();
}
