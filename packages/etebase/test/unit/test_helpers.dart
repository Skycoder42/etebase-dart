import 'package:mockito/mockito.dart';

extension FuturePostExpectationX<T> on PostExpectation<Future<T>> {
  void thenReturnAsync(T result) => thenAnswer((_) => Future.value(result));
}

extension StreamPostExpectationX<T extends Stream<dynamic>>
    on PostExpectation<T> {
  void thenStream(T result) => thenAnswer((_) => result);
}
