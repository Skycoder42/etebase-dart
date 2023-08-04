import 'package:etebase/etebase.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'dispose_ref.dart';

part 'sync_item.freezed.dart';

@freezed
class SyncItem with _$SyncItem {
  const factory SyncItem({
    required String uid,
    required String? itemType,
    required EtebaseItem item,
    required dynamic data,
    @internal DisposeRef? internalDisposeRef,
  }) = _SyncItem;

  const SyncItem._();

  Future<void> dispose() => internalDisposeRef?.dispose() ?? item.dispose();
}
