import 'package:freezed_annotation/freezed_annotation.dart';

part 'http_field_error.freezed.dart';
part 'http_field_error.g.dart';

@Freezed(toStringOverride: false)
sealed class HttpFieldError with _$HttpFieldError {
  const factory HttpFieldError({
    required String code,
    required String detail,
    String? field,
  }) = _HttpFieldError;

  factory HttpFieldError.fromJson(Map<String, dynamic> json) =>
      _$HttpFieldErrorFromJson(json);

  const HttpFieldError._();

  @override
  String toString() =>
      field != null ? '$field => $code: $detail' : '$code: $detail';
}
