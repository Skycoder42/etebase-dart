// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';

import 'etebase_collection.dart';

part 'removed_collection.freezed.dart';
part 'removed_collection.g.dart';

/// A collection for which the user lost access.
///
/// Deleted collections are marked using [EtebaseCollection.isDeleted]. However,
/// when we just lose access to a collection and it hasn't been deleted, we get
/// this object.
@freezed
sealed class RemovedCollection with _$RemovedCollection {
  /// Default constructor
  const factory RemovedCollection(
    /// The uid of the removed collection.
    String uid,
  ) = _RemovedCollection;

  /// @nodoc
  @internal
  factory RemovedCollection.fromJson(Map<String, dynamic> json) =>
      _$RemovedCollectionFromJson(json);
}
