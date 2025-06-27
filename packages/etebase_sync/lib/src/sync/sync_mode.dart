import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_mode.freezed.dart';

enum RefreshStrategy { fetchAll, fetchSingle }

@freezed
sealed class SyncMode with _$SyncMode {
  static const defaultSyncPeriod = Duration(seconds: 30);

  const factory SyncMode.manual() = SyncModeManual;

  const factory SyncMode.onDemand({
    @Default(RefreshStrategy.fetchAll) RefreshStrategy refreshStrategy,
  }) = SyncModeOnDemand;

  const factory SyncMode.periodic({
    @Default(defaultSyncPeriod) Duration period,
    @Default(false) bool uploadOnSave,
  }) = SyncModePeriodic;

  const factory SyncMode.live({
    @Default(true) bool allowFallbackToPeriodic,
    @Default(defaultSyncPeriod) Duration fallbackPeriod,
  }) = SyncModeLive;
}
