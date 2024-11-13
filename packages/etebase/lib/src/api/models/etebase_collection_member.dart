import 'package:freezed_annotation/freezed_annotation.dart';

import 'etebase_collection_access_level.dart';

part 'etebase_collection_member.freezed.dart';
part 'etebase_collection_member.g.dart';

/// The dart binding of the EtebaseCollectionMember rust class
@freezed
class EtebaseCollectionMember with _$EtebaseCollectionMember {
  /// Default constructor
  const factory EtebaseCollectionMember({
    /// The username of a member
    required String username,

    /// The access_level of the member
    required EtebaseCollectionAccessLevel accessLevel,
  }) = _EtebaseCollectionMember;

  /// @nodoc
  @internal
  factory EtebaseCollectionMember.fromJson(Map<String, dynamic> json) =>
      _$EtebaseCollectionMemberFromJson(json);
}
