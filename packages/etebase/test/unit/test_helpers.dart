import 'package:mockito/mockito.dart';

extension PostExpectationX<T> on PostExpectation<Future<T>> {
  void thenReturnAsync(T result) => thenAnswer((_) => Future.value(result));
}
