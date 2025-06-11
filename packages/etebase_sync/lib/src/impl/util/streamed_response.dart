import 'package:etebase/etebase.dart';
import 'package:meta/meta.dart';

@internal
Stream<T> streamedResponse<T extends Object>(
  Future<ListResponse<T>> Function(String? token) next, [
  String? initialToken,
  void Function(String? token)? setLastToken,
]) async* {
  var currentToken = initialToken;
  ListResponse<T> response;
  do {
    response = await next(currentToken);
    for (final item in response.data) {
      yield item;
    }

    currentToken = switch (response) {
      ItemListResponse(:final stoken) => stoken,
      CollectionListResponse(:final stoken) => stoken,
      IteratorListResponse(:final iterator) => iterator,
      _ => null,
    };
  } while (!response.isDone);

  setLastToken?.call(currentToken);
}
