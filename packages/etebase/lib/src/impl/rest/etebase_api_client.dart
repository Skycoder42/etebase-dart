import 'package:chopper/chopper.dart';
import 'package:meta/meta.dart';

import 'interceptors/msg_pack_interceptor.dart';
import 'msg_pack_converter.dart';
import 'services/authentication_service.dart';

@internal
final class EtebaseApiClient extends ChopperClient {
  static final defaultUrl = Uri.https('api.etebase.com');

  EtebaseApiClient({Uri? baseUrl})
      : super(
          baseUrl: baseUrl ?? defaultUrl,
          converter: MsgPackConverter(),
          interceptors: [
            const MessagePackInterceptor(),
          ],
          services: [
            AuthenticationService.create(),
          ],
        );

  AuthenticationService get authentication =>
      getService<AuthenticationService>();
}
