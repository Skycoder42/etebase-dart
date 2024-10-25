/// The URL of the main hosted server
Uri etebaseGetDefaultServerUrl() => throw UnimplementedError();

/// The dart binding of the EtebaseClient rust class
abstract class EtebaseClient {
  /// Creates a new etebase client.
  static Future<EtebaseClient> create(
    String clientName, [
    Uri? serverUrl,
  ]) =>
      throw UnimplementedError();

  /// Sets the server URL of the client.
  void setServerUrl(Uri serverUrl);

  /// Returns 0 if client is pointing an etebase server, 1 if not, -1 on error
  ///
  /// @param client the object handle
  Future<bool> checkEtebaseServer();
}
