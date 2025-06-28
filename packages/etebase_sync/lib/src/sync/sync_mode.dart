import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_mode.freezed.dart';

@freezed
sealed class SyncMode with _$SyncMode {
  static const defaultSyncPeriod = Duration(seconds: 30);

  const factory SyncMode.manual() = SyncModeManual;

  const factory SyncMode.periodic({
    @Default(defaultSyncPeriod) Duration period,
  }) = SyncModePeriodic;

  const factory SyncMode.live({
    @Default(true) bool allowFallbackToPeriodic,
    @Default(defaultSyncPeriod) Duration fallbackPeriod,
  }) = SyncModeLive;
}
