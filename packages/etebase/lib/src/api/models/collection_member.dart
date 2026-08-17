// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';

import 'collection_access_level.dart';

part 'collection_member.freezed.dart';
part 'collection_member.g.dart';

/// A member of a collection.
@freezed
sealed class CollectionMember with _$CollectionMember {
  /// Default constructor.
  const factory({
    /// The username of the member.
    required String username,

    /// The access level of the member.
    required CollectionAccessLevel accessLevel,
  }) = _CollectionMember;

  /// @nodoc
  @internal
  factory fromJson(Map<String, dynamic> json) =>
      _$CollectionMemberFromJson(json);
}
