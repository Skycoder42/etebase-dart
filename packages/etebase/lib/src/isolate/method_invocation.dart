import 'package:freezed_annotation/freezed_annotation.dart';

part 'method_invocation.freezed.dart';

@freezed
class MethodInvocation with _$MethodInvocation {
  const factory MethodInvocation(
    int id,
    Symbol method,
    List<Object?> arguments,
  ) = _MethodInvocation;
}
