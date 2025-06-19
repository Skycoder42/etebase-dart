import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'conflict_resolution.freezed.dart';

@freezed
sealed class ConflictResolution<TValue extends Object>
    with _$ConflictResolution<TValue> {
  const factory ConflictResolution.local([TValue? value]) =
      ConflictResolutionLocal;

  const factory ConflictResolution.remote([TValue? value]) =
      ConflictResolutionRemote;

  const ConflictResolution._();

  Future<ConflictResolution<TOther>> map<TOther extends Object>({
    required FutureOr<TOther> Function(TValue value) local,
    required FutureOr<TOther> Function(TValue value) remote,
  }) async => switch (this) {
    ConflictResolutionLocal(value: null) => const ConflictResolution.local(),
    ConflictResolutionLocal(:final TValue value) => ConflictResolution.local(
      await local(value),
    ),
    ConflictResolutionRemote(value: null) => const ConflictResolution.remote(),
    ConflictResolutionRemote(:final TValue value) => ConflictResolution.remote(
      await remote(value),
    ),
  };
}
