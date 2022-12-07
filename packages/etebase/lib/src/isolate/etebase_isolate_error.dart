// coverage:ignore-file

class EtebaseIsolateError extends StateError {
  EtebaseIsolateError.notInitialized()
      : super(
          'No active etebase isolate - '
          'call Etebase.ensureInitialized to create one',
        );

  EtebaseIsolateError.isolateTerminated()
      : super(
          'Method invocation failed because the etebase isolate was '
          'terminated before it could process the invocation.',
        );
}
