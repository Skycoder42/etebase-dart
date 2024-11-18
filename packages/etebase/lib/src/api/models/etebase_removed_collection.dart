import 'package:freezed_annotation/freezed_annotation.dart';

import 'etebase_collection.dart';

part 'etebase_removed_collection.freezed.dart';
part 'etebase_removed_collection.g.dart';

/// A collection for which the user lost access.
///
/// Deleted collections are marked using [EtebaseCollection.isDeleted]. However,
/// when we just lose access to a collection and it hasn't been deleted, we get
/// this object.
@freezed
sealed class EtebaseRemovedCollection with _$EtebaseRemovedCollection {
  /// Default constructor
  const factory EtebaseRemovedCollection(
    /// The uid of the removed collection.
    String uid,
  ) = _EtebaseRemovedCollection;

  /// @nodoc
  @internal
  factory EtebaseRemovedCollection.fromJson(Map<String, dynamic> json) =>
      _$EtebaseRemovedCollectionFromJson(json);
}
