import 'package:meta/meta.dart';

import '../../api/exceptions/not_found.dart';
import '../models/auth_token.dart';
import '../models/challenge_request.dart';
import '../models/dashboard_url.dart';
import '../models/login_challenge.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/signup_request.dart';
import 'base_network.dart';

@internal
class Authenticator {
  final BaseNetwork _network;

  Authenticator(NetworkClient client)
    : _network = BaseNetwork(
        client: client,
        path: const ['api', 'v1', 'authentication'],
      );

  @visibleForTesting
  Authenticator.fromNetwork(this._network);

  @visibleForTesting
  Uri get apiUrl => _network.apiUrl;

  Future<bool> isEtebase() async {
    try {
      await _network.invoke<void>(path: ['is_etebase']);
      return true;
    } on NotFound {
      return false;
    }
  }

  Future<LoginResponse> signup(SignupRequest body) =>
      _network.invoke<LoginResponse>(
        method: HttpMethod.post,
        path: ['signup'],
        body: body,
      );

  Future<LoginChallenge> loginChallenge(ChallengeRequest body) =>
      _network.invoke<LoginChallenge>(
        method: HttpMethod.post,
        path: ['login_challenge'],
        body: body,
      );

  Future<LoginResponse> login(LoginRequest body) =>
      _network.invoke<LoginResponse>(
        method: HttpMethod.post,
        path: ['login'],
        body: body,
      );

  Future<void> logout(AuthToken authToken) => _network.invoke<void>(
    method: HttpMethod.post,
    authToken: authToken,
    path: ['logout'],
  );

  Future<void> changePassword(AuthToken authToken, LoginRequest body) =>
      _network.invoke<void>(
        method: HttpMethod.post,
        authToken: authToken,
        path: ['change_password'],
        body: body,
      );

  Future<Uri> getDashboardUrl(AuthToken authToken) => _network
      .invoke<DashboardUrl>(
        method: HttpMethod.post,
        authToken: authToken,
        path: ['dashboard_url'],
      )
      .then((r) => r.url);
}
