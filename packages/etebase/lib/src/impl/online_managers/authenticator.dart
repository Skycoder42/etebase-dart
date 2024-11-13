import 'package:meta/meta.dart';

import '../../api/exceptions/not_found.dart';
import '../models/challenge_request.dart';
import '../models/dashboard_url.dart';
import '../models/login_challenge.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/signup_request.dart';
import '../rest/interceptors/auth_interceptor.dart';
import 'base_network.dart';

@internal
final class Authenticator extends BaseNetwork {
  Authenticator({
    required super.client,
    required super.converter,
    required Uri baseUri,
  }) : super(baseUri: baseUri.resolve('api/v1/authentication/'));

  Future<bool> isEtebase() async {
    try {
      await invoke<void>(path: ['is_etebase']);
      return true;
    } on NotFound {
      return false;
    }
  }

  Future<LoginResponse> signup(SignupRequest body) => invoke<LoginResponse>(
        method: HttpMethod.post,
        path: ['signup'],
        body: body,
      );

  Future<LoginChallenge> loginChallenge(ChallengeRequest body) =>
      invoke<LoginChallenge>(
        method: HttpMethod.post,
        path: ['login_challenge'],
        body: body,
      );

  Future<LoginResponse> login(LoginRequest body) => invoke<LoginResponse>(
        method: HttpMethod.post,
        path: ['login'],
        body: body,
      );

  Future<void> logout(AuthToken authToken) => invoke<void>(
        method: HttpMethod.post,
        authToken: authToken,
        path: ['logout'],
      );

  Future<void> changePassword(AuthToken authToken, LoginRequest body) =>
      invoke<void>(
        method: HttpMethod.post,
        authToken: authToken,
        path: ['change_password'],
        body: body,
      );

  Future<DashboardUrl> getDashboardUrl(AuthToken authToken) =>
      invoke<DashboardUrl>(
        method: HttpMethod.post,
        authToken: authToken,
        path: ['dashboard_url'],
      );
}
