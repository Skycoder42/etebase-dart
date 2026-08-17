// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';

part 'removed_collection.freezed.dart';
part 'removed_collection.g.dart';

@freezed
@internal
sealed class RemovedCollection with _$RemovedCollection {
  const factory(String uid) = _RemovedCollection;

  factory fromJson(Map<String, dynamic> json) =>
      _$RemovedCollectionFromJson(json);
}
