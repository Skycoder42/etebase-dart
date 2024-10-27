import 'package:meta/meta.dart';
import 'package:sodium/sodium_sumo.dart';

import '../../api/managers/etebase_account.dart';
import '../../api/managers/etebase_client.dart';
import '../../api/models/etebase_user.dart';
import '../crypto/key_derivator.dart';
import '../rest/etebase_api_client.dart';

@internal
class Client implements EtebaseClient {
  final EtebaseApiClient _apiClient;
  final SodiumSumo _sodium;
  final KeyDerivator _keyDerivator;

  Client(
    this._apiClient,
    this._sodium,
    this._keyDerivator,
  );

  factory Client.create(
    SodiumSumo sodium, [
    Uri? serverUrl,
  ]) =>
      Client(
        EtebaseApiClient(baseUrl: serverUrl),
        sodium,
        KeyDerivator(sodium),
      );

  void dispose() {
    _apiClient.dispose();
  }

  @override
  Future<bool> checkEtebaseServer() async {
    final response = await _apiClient.accounts.isEtebase();
    return response.isSuccessful;
  }

  Future<EtebaseAccount> signup(
    EtebaseClient client,
    EtebaseUser user,
    String password,
  ) async {
    final salt = _sodium.randombytes.buf(_sodium.crypto.pwhash.saltBytes);
    final mainKey = await _keyDerivator(
      password: password,
      salt: salt,
    );
    throw UnimplementedError();
  }
}
