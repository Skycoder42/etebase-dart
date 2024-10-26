import 'package:chopper/chopper.dart';
import 'package:meta/meta.dart';

part 'account_service.chopper.dart';

@internal
@ChopperApi(baseUrl: '/api/v1/authentication')
abstract class AccountService extends ChopperService {
  AccountService();

  factory AccountService.create([ChopperClient? client]) = _$AccountService;

  @Get(path: 'is_etebase/')
  Future<Response<void>> isEtebase();
}
