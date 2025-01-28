// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';

import 'etebase_collection_access_level.dart';

part 'etebase_collection_member.freezed.dart';
part 'etebase_collection_member.g.dart';

/// A member of a collection.
@freezed
sealed class EtebaseCollectionMember with _$EtebaseCollectionMember {
  /// Default constructor.
  const factory EtebaseCollectionMember({
    /// The username of the member.
    required String username,

    /// The access level of the member.
    required EtebaseCollectionAccessLevel accessLevel,
  }) = _EtebaseCollectionMember;

  /// @nodoc
  @internal
  factory EtebaseCollectionMember.fromJson(Map<String, dynamic> json) =>
      _$EtebaseCollectionMemberFromJson(json);
}
