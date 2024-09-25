// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';

part 'method_invocation.freezed.dart';

/// @nodoc
@freezed
@internal
sealed class MethodInvocation with _$MethodInvocation {
  /// @nodoc
  const factory MethodInvocation(
    int id,
    Symbol method,
    List<dynamic> arguments,
  ) = _MethodInvocation;
}
