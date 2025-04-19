import 'package:meta/meta.dart';

import '../../api/models/etebase_fetch_options.dart';
import '../../api/models/etebase_prefetch_option.dart';
import '../models/auth_token.dart';
import '../models/fetch_options.dart';
import 'base_network.dart';

@internal
abstract interface class AuthTokenSource {
  AuthToken get authToken;
}

@internal
class BaseManager {
  static const apiBasePath = ['api', 'v1'];

  final BaseNetwork _network;

  final AuthTokenSource authTokenSource;

  BaseManager({
    required NetworkClient client,
    required this.authTokenSource,
    List<String> path = const [],
  }) : _network = BaseNetwork(
         client: client,
         path: apiBasePath.followedBy(path),
       );

  @visibleForTesting
  BaseManager.fromNetwork(this._network, this.authTokenSource);

  @protected
  @visibleForTesting
  NetworkClient get client => _network.client;

  @visibleForTesting
  Uri get apiUrl => _network.apiUrl;

  Future<T> invoke<T>({
    HttpMethod method = HttpMethod.get,
    List<String> path = const [],
    Map<String, String> headers = const {},
    EtebaseFetchOptionsBase? options,
    Map<String, String>? query,
    dynamic body,
  }) => _network.invoke<T>(
    method: method,
    path: path,
    headers: headers,
    query: queryFromOptions(options, query),
    body: body,
    authToken: authTokenSource.authToken,
  );

  @protected
  Map<String, String> queryFromOptions(
    EtebaseFetchOptionsBase? options, [
    Map<String, String>? query,
  ]) {
    if (options == null) {
      return query ?? const {};
    }

    final fetchOptions = options.asFetchOptions();
    return {
      ...?query,
      if (fetchOptions.limit case final int limit when limit > 0)
        'limit': limit.toString(),
      if (fetchOptions.iterator case final String iterator)
        'iterator': iterator,
      if (fetchOptions.stoken case final String stoken) 'stoken': stoken,
      if (fetchOptions.withCollection case final bool withCollection)
        'withCollection': withCollection.toString(),
      if (fetchOptions.prefetch case final EtebasePrefetchOption prefetch)
        'prefetch': prefetch.name,
    };
  }
}
