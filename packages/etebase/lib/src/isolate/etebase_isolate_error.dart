// coverage:ignore-file

/// Error that indicates that there is a problem with the background isolate.
class EtebaseIsolateError extends StateError {
  /// Gets thrown if the isolate has not been initialized.
  EtebaseIsolateError.notInitialized()
      : super(
          'No active etebase isolate - '
          'call Etebase.ensureInitialized to create one',
        );

  /// Gets thrown if the isolate has been terminated.
  EtebaseIsolateError.isolateTerminated()
      : super(
          'Method invocation failed because the etebase isolate was '
          'terminated before it could process the invocation.',
        );
}
