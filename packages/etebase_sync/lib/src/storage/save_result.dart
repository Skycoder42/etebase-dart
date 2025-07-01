import 'package:etebase/etebase.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'save_result.freezed.dart';

@freezed
sealed class SaveResult with _$SaveResult {
  const factory SaveResult.ok(String etag) = SaveOk;
  const factory SaveResult.deleted() = SaveDeleted;
  const factory SaveResult.conflict(Item cacheItem) = SaveConflict;
}
