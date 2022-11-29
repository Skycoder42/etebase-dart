// coverage:ignore-file

class IsolateTerminated implements Exception {
  @override
  String toString() =>
      'Method invocation failed because the etebase isolate was terminated '
      'before it could process the invocation.';
}
