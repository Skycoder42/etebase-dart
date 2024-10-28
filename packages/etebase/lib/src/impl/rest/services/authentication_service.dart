import 'package:chopper/chopper.dart';
import 'package:meta/meta.dart';

import '../models/login_response.dart';
import '../models/signup_request.dart';

part 'authentication_service.chopper.dart';

@internal
@ChopperApi(baseUrl: '/api/v1/authentication')
abstract class AuthenticationService extends ChopperService {
  AuthenticationService();

  factory AuthenticationService.create([ChopperClient? client]) =
      _$AuthenticationService;

  @Get(path: 'is_etebase/')
  Future<Response<void>> isEtebase();

  @Post(path: 'signup/')
  Future<LoginResponse> signup(@Body() SignupRequest body);
}
