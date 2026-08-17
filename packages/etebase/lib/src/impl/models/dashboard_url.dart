// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_url.freezed.dart';
part 'dashboard_url.g.dart';

@internal
@freezed
sealed class DashboardUrl with _$DashboardUrl {
  const factory(Uri url) = _DashboardUrl;

  factory fromJson(Map<String, dynamic> json) => _$DashboardUrlFromJson(json);
}
