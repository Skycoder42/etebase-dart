import 'package:chopper/chopper.dart';
import 'package:meta/meta.dart';

import 'interceptors/msg_pack_interceptor.dart';
import 'services/account_service.dart';

@internal
final class EtebaseApiClient extends ChopperClient {
  static final defaultUrl = Uri.https('api.etebase.com');

  EtebaseApiClient({Uri? baseUrl})
      : super(
          baseUrl: baseUrl ?? defaultUrl,
          interceptors: [
            const MessagePackInterceptor(),
          ],
          services: [
            AccountService.create(),
          ],
        );

  AccountService get accounts => getService<AccountService>();
}
