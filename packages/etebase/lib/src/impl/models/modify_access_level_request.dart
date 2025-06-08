// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../api/models/collection_access_level.dart';

part 'modify_access_level_request.freezed.dart';
part 'modify_access_level_request.g.dart';

@freezed
@internal
sealed class ModifyAccessLevelRequest with _$ModifyAccessLevelRequest {
  const factory ModifyAccessLevelRequest(CollectionAccessLevel accessLevel) =
      _ModifyAccessLevelRequest;

  factory ModifyAccessLevelRequest.fromJson(Map<String, dynamic> json) =>
      _$ModifyAccessLevelRequestFromJson(json);
}
