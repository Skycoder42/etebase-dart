import 'package:freezed_annotation/freezed_annotation.dart';

import 'sync_mode.dart';

part 'sync_config.freezed.dart';

@freezed
sealed class SyncConfig with _$SyncConfig {
  const factory SyncConfig({
    /// When saving or deleting, wait for the change to be uploaded if online
    @Default(true) bool waitForUpload,

    /// How to synchronize changes from the server
    @Default(SyncMode.live()) SyncMode syncMode,
  }) = _SyncConfig;
}
