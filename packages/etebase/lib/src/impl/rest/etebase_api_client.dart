import 'package:chopper/chopper.dart';
import 'package:meta/meta.dart';

import '../codec/message_pack_converter.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/msg_pack_converter.dart';
import 'services/authentication_service.dart';
import 'services/collection_item_service.dart';
import 'services/collection_service.dart';

@internal
final class EtebaseApiClient extends ChopperClient {
  static final defaultUrl = Uri.https('api.etebase.com');

  factory EtebaseApiClient({
    Uri? baseUrl,
  }) =>
      EtebaseApiClient._(baseUrl, MsgPackConverter(MessagePackConverter()));

  EtebaseApiClient._(
    Uri? baseUrl,
    MsgPackConverter converter,
  ) : super(
          baseUrl: baseUrl ?? defaultUrl,
          converter: converter,
          errorConverter: converter,
          interceptors: const [
            AuthInterceptor(),
          ],
          services: [
            AuthenticationService.create(),
            CollectionService.create(),
            RawCollectionItemService.create(),
          ],
        );

  AuthenticationService get authentication =>
      getService<AuthenticationService>();

  CollectionService get collection => getService<CollectionService>();

  CollectionItemService collectionItem(String colUid) =>
      CollectionItemService(getService<RawCollectionItemService>(), colUid);
}
