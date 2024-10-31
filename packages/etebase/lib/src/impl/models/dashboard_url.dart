import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_url.freezed.dart';
part 'dashboard_url.g.dart';

@internal
@freezed
sealed class DashboardUrl with _$DashboardUrl {
  const factory DashboardUrl(Uri url) = _DashboardUrl;

  factory DashboardUrl.fromJson(Map<String, dynamic> json) =>
      _$DashboardUrlFromJson(json);
}
