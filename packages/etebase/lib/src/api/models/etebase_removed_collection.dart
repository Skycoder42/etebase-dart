import 'package:freezed_annotation/freezed_annotation.dart';

part 'etebase_removed_collection.freezed.dart';
part 'etebase_removed_collection.g.dart';

/// The dart binding of the EtebaseRemovedCollection rust class
@freezed
class EtebaseRemovedCollection with _$EtebaseRemovedCollection {
  /// Default constructor
  const factory EtebaseRemovedCollection(
    /// The uid of the removed collection
    String uid,
  ) = _EtebaseRemovedCollection;

  /// @nodoc
  @internal
  factory EtebaseRemovedCollection.fromJson(Map<String, dynamic> json) =>
      _$EtebaseRemovedCollectionFromJson(json);
}
