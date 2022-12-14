import 'dart:developer' as dev;

import 'package:meta/meta.dart';

import '../gen/ffi/libetebase.ffi.dart';
import '../model/etebase_config.dart';
import 'etebase_isolate.dart';
import 'etebase_pool.dart';
import 'method_invocation.dart';
import 'method_result.dart';

/// @nodoc
@internal
class LoggingInvocationHandlerWrapper {
  final MethodInvocationHandler _methodInvocationHandler;

  /// @nodoc
  final int logLevel;

  /// @nodoc
  const LoggingInvocationHandlerWrapper(
    this._methodInvocationHandler, {
    this.logLevel = 500,
  });

  /// @nodoc
  MethodResult call(
    LibEtebaseFFI libEtebaseFFI,
    EtebasePool pool,
    EtebaseConfig etebaseConfig,
    MethodInvocation invocation,
  ) {
    _log('>> Handling $invocation with $etebaseConfig');
    try {
      return _methodInvocationHandler(
        libEtebaseFFI,
        pool,
        etebaseConfig,
        invocation,
      )..when(
          success: (id, dynamic result) =>
              _log('<< Completed successfully with result: $result'),
          failure: (id, code, message) =>
              _log('<< Failed with $code: $message'),
          exception: (id, error) => _log('<< Threw exception:', error),
        );
      // ignore: avoid_catches_without_on_clauses
    } catch (error, stackTrace) {
      _log('<< Threw exception:', error, stackTrace);
      rethrow;
    }
  }

  void _log(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) =>
      dev.log(
        level: logLevel,
        name: 'EtebaseIsolate',
        message,
        error: error,
        stackTrace: stackTrace,
      );
}
