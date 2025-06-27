import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_config.freezed.dart';

enum SyncMode { explicit, implicit, automatic }

@freezed
sealed class SyncConfig with _$SyncConfig {
  const factory SyncConfig({@Default(SyncMode.automatic) SyncMode syncMode}) =
      _SyncConfig;
}
