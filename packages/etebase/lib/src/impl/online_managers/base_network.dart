import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:meta/meta.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../api/exceptions/conflict.dart';
import '../../api/exceptions/connection_problem.dart';
import '../../api/exceptions/http_error_content.dart';
import '../../api/exceptions/http_failure.dart';
import '../../api/exceptions/invalid_message_pack_data.dart';
import '../../api/exceptions/not_found.dart';
import '../../api/exceptions/permission_denied.dart';
import '../../api/exceptions/server_problem.dart';
import '../../api/exceptions/temporary_server_problem.dart';
import '../../api/exceptions/unauthorized.dart';
import '../codec/message_pack_converter.dart';
import '../models/auth_token.dart';

@internal
enum HttpMethod {
  get('GET'),
  post('POST'),
  put('PUT'),
  delete('DELETE'),
  patch('PATCH');

  final String verb;

  new(this.verb);
}

@internal
abstract interface class NetworkClient {
  http.Client get httpClient;
  String get userAgent;
  MessagePackConverter get converter;
  Uri get baseUrl;

  WebSocketChannel connectWebSocket(Uri uri);
}

@internal
class BaseNetwork {
  static const _userAgentHeader = 'user-agent';
  static const _acceptHeader = 'accept';
  static const _contentTypeHeader = 'content-type';
  static const _authorizationHeader = 'authorization';

  static const _msgPackMimeType = 'application/msgpack';
  static const _binaryMimeType = 'application/octet-stream';
  static const _plainTextMimeType = 'text/plain';

  final NetworkClient client;

  final Uri apiUrl;

  new({required this.client, Iterable<String> path = const []})
    : apiUrl = client.baseUrl.replace(
        pathSegments: client.baseUrl.pathSegments.followedBy(path),
      ),
      assert(
        !client.baseUrl.path.endsWith('/'),
        'client.baseUrl must not end with /',
      );

  @nonVirtual
  Future<T> invoke<T>({
    HttpMethod method = HttpMethod.get,
    List<String> path = const [],
    Map<String, String> headers = const {},
    Map<String, String> query = const {},
    dynamic body,
    AuthToken? authToken,
  }) async {
    try {
      final request = _createRequest(
        method: method,
        path: path,
        query: query,
        headers: headers,
        body: body,
        authToken: authToken,
      );

      http.Response response;
      final streamResponse = await client.httpClient.send(request);
      response = await http.Response.fromStream(streamResponse);

      if (response.statusCode case >= 200 && < 300) {
        return _convertResponse<T>(response);
      } else {
        _convertError(response);
      }
    } on http.ClientException catch (e, s) {
      Error.throwWithStackTrace(ConnectionProblem(e), s);
    }
  }

  http.Request _createRequest({
    required HttpMethod method,
    required List<String> path,
    required Map<String, String> query,
    required Map<String, String> headers,
    required dynamic body,
    required AuthToken? authToken,
  }) {
    final requestUri = apiUrl.replace(
      pathSegments: [
        ...apiUrl.pathSegments,
        ...path,
        '', // ensures the path has a trailing /
      ],
      queryParameters: query.isNotEmpty
          ? {...apiUrl.queryParametersAll, ...query}
          : null,
    );

    final request = http.Request(method.verb, requestUri)
      ..headers[_userAgentHeader] = client.userAgent
      ..headers[_acceptHeader] = _msgPackMimeType
      ..headers.addAll(headers);
    if (authToken != null) {
      request.headers[_authorizationHeader] = authToken.header;
    }

    switch (body) {
      case null:
        break;
      case String():
        request.body = body;
      case Map<String, String>():
        request.bodyFields = body;
      case Uint8List():
        request
          ..headers[_contentTypeHeader] = _binaryMimeType
          ..bodyBytes = body;
      default:
        request
          ..headers[_contentTypeHeader] = _msgPackMimeType
          ..bodyBytes = client.converter.encode(body);
    }
    return request;
  }

  MediaType? _getContentType(http.Response response) {
    final contentType = response.headers[_contentTypeHeader];
    return contentType != null ? MediaType.parse(contentType) : null;
  }

  T _convertResponse<T>(http.Response response) {
    if (_isVoid<T>()) {
      return null as T;
    }

    return switch (_getContentType(response)?.mimeType) {
      _msgPackMimeType => client.converter.decode<T>(response.bodyBytes),
      _binaryMimeType => response.bodyBytes as T,
      _plainTextMimeType => response.body as T,
      final contentType => throw InvalidMessagePackData(
        'Content type $contentType is not supported',
      ),
    };
  }

  Never _convertError(http.Response response) {
    final (message, error) = _extractErrorData(response);
    throw switch (response.statusCode) {
      Unauthorized.statusCode => Unauthorized(message, error),
      PermissionDenied.statusCode => PermissionDenied(message, error),
      NotFound.statusCode => NotFound(message, error),
      Conflict.statusCode => Conflict(message, error),
      502 ||
      503 ||
      504 => TemporaryServerProblem(response.statusCode, message, error),
      >= 500 && < 600 => ServerProblem(response.statusCode, message, error),
      _ => HttpFailure(response.statusCode, message, error),
    };
  }

  (String, HttpErrorContent?) _extractErrorData(http.Response response) {
    final fallbackMessage = 'HTTP Error ${response.statusCode}';

    switch (_getContentType(response)) {
      case MediaType(mimeType: _msgPackMimeType)
          when response.bodyBytes.isNotEmpty:
        break;
      case MediaType(type: 'text') when response.body.isNotEmpty:
        return (response.body, null);
      default:
        return (fallbackMessage, null);
    }

    try {
      final error = client.converter.decode<HttpErrorContent>(
        response.bodyBytes,
      );
      final message = error.toString(withErrors: false);
      return (message, error);
      // ignore: avoid_catches_without_on_clauses
    } catch (_) {
      // ignore
    }

    return (fallbackMessage, null);
  }

  static bool _isVoid<T>() => _compareType<T, void>();

  static bool _compareType<T1, T2>() => T1 == T2;
}
