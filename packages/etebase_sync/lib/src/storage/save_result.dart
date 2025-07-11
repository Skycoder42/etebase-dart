import 'package:etebase/etebase.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'save_result.freezed.dart';

enum SaveAction { saved, deleted, unchanged }

@freezed
sealed class SaveResult<TItem extends Item> with _$SaveResult<TItem> {
  const factory SaveResult.ok(
    String etag, [
    @Default(SaveAction.saved) SaveAction action,
  ]) = SaveOk<TItem>;
  const factory SaveResult.conflict(TItem cacheItem) = SaveConflict<TItem>;
}
