import 'package:freezed_annotation/freezed_annotation.dart';

part 'http_field_error.freezed.dart';
part 'http_field_error.g.dart';

/// An error for a specific field in case a field failed server validation.
@Freezed(toStringOverride: false)
sealed class HttpFieldError with _$HttpFieldError {
  /// Default constructor.
  const factory HttpFieldError({
    /// The error code of the error.
    required String code,

    /// Potential human readable error details.
    required String detail,

    /// The name of the field this error occurred on.
    String? field,
  }) = _HttpFieldError;

  /// @nodoc
  @internal
  factory HttpFieldError.fromJson(Map<String, dynamic> json) =>
      _$HttpFieldErrorFromJson(json);

  const HttpFieldError._();

  @override
  String toString() =>
      field != null ? '$field => $code: $detail' : '$code: $detail';
}
