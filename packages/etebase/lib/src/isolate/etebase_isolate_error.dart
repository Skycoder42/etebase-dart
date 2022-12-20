// coverage:ignore-file

/// Error that indicates that there is a problem with the background isolate.
class EtebaseIsolateError extends StateError {
  /// Gets thrown if the isolate has not been initialized.
  EtebaseIsolateError.notInitialized()
      : super(
          'Etebase has not been initialized - '
          'call Etebase.ensureInitialized to do so.',
        );

  /// Gets thrown if the isolate has been terminated.
  EtebaseIsolateError.isolateTerminated()
      : super(
          'Method invocation failed because the etebase isolate was '
          'terminated before it could process the invocation.',
        );

  /// Gets thrown if the EtebaseClient has already been disposed
  EtebaseIsolateError.clientDisposed()
      : super(
          'Tried to invoke a method after EtebaseClient has '
          'already been disposed.',
        );
}
