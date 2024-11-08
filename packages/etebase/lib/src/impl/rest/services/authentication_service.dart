import 'package:chopper/chopper.dart';
import 'package:meta/meta.dart';

import '../../models/challenge_request.dart';
import '../../models/dashboard_url.dart';
import '../../models/login_challenge.dart';
import '../../models/login_request.dart';
import '../../models/login_response.dart';
import '../../models/signup_request.dart';
import '../interceptors/auth_interceptor.dart';

part 'authentication_service.chopper.dart';

@internal
@ChopperApi(baseUrl: '/api/v1/authentication/')
abstract class AuthenticationService extends ChopperService {
  AuthenticationService();

  factory AuthenticationService.create([ChopperClient? client]) =
      _$AuthenticationService;

  @Get(path: 'is_etebase/')
  Future<Response<void>> isEtebase();

  @Post(path: 'signup/')
  Future<LoginResponse> signup(@Body() SignupRequest body);

  @Post(path: 'login_challenge/')
  Future<LoginChallenge> loginChallenge(@Body() ChallengeRequest body);

  @Post(path: 'login/')
  Future<LoginResponse> login(@Body() LoginRequest body);

  @Post(path: 'logout/', optionalBody: true)
  Future<void> logout(@Tag() AuthToken authToken);

  @Post(path: 'change_password/')
  Future<void> changePassword(
    @Tag() AuthToken authToken,
    @Body() LoginRequest body,
  );

  @Post(path: 'dashboard_url/', optionalBody: true)
  Future<DashboardUrl> getDashboardUrl(@Tag() AuthToken authToken);
}
