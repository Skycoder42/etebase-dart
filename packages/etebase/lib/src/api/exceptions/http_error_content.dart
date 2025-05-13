import 'package:freezed_annotation/freezed_annotation.dart';

import 'http_field_error.dart';

part 'http_error_content.freezed.dart';
part 'http_error_content.g.dart';

/// An error message as received from the server.
@Freezed(toStringOverride: false)
sealed class HttpErrorContent with _$HttpErrorContent {
  /// Default constructor.
  const factory HttpErrorContent({
    /// The error code of the error.
    String? code,

    /// Potential human readable error details.
    String? detail,

    /// A list of specific field errors in case of validation errors.
    @Default([]) List<HttpFieldError> errors,
  }) = _HttpErrorContent;

  /// @nodoc
  // coverage:ignore-start
  @internal
  factory HttpErrorContent.fromJson(Map<String, dynamic> json) =>
      _$HttpErrorContentFromJson(json);
  // coverage:ignore-end

  const HttpErrorContent._();

  @override
  String toString({bool withErrors = true}) {
    final buffer = StringBuffer();
    if (code case final String code) {
      buffer.write(code);
    }

    if (detail case final String detail) {
      if (buffer.isNotEmpty) {
        buffer.write(': ');
      }
      buffer.write(detail);
    }

    if (buffer.isEmpty) {
      buffer.write('Unknown error');
    }

    if (withErrors && errors.isNotEmpty) {
      for (final error in errors) {
        buffer
          ..writeln()
          ..write(' | ')
          ..write(error);
      }
    }

    return buffer.toString();
  }
}
