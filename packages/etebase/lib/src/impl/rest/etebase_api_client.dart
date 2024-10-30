import 'package:chopper/chopper.dart';
import 'package:meta/meta.dart';

import 'interceptors/msg_pack_converter.dart';
import 'services/authentication_service.dart';

@internal
final class EtebaseApiClient extends ChopperClient {
  static final defaultUrl = Uri.https('api.etebase.com');

  factory EtebaseApiClient({Uri? baseUrl}) =>
      EtebaseApiClient._(baseUrl, MsgPackConverter());

  EtebaseApiClient._(Uri? baseUrl, MsgPackConverter converter)
      : super(
          baseUrl: baseUrl ?? defaultUrl,
          converter: converter,
          errorConverter: converter,
          services: [
            AuthenticationService.create(),
          ],
        );

  AuthenticationService get authentication =>
      getService<AuthenticationService>();
}
