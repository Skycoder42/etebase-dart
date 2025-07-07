import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_mode.freezed.dart';
part 'sync_mode.g.dart';

@freezed
sealed class SyncMode with _$SyncMode {
  static const defaultSyncPeriod = Duration(seconds: 30);

  const factory SyncMode.manual() = SyncModeManual;

  const factory SyncMode.periodic({
    @Default(SyncMode.defaultSyncPeriod) Duration period,
    @Default(true) bool fireImmediately,
  }) = SyncModePeriodic;

  const factory SyncMode.live() = SyncModeLive;

  factory SyncMode.fromJson(Map<String, dynamic> json) =>
      _$SyncModeFromJson(json);
}
