import 'package:freezed_annotation/freezed_annotation.dart';

import 'http_field_error.dart';

part 'http_error_content.freezed.dart';
part 'http_error_content.g.dart';

@Freezed(toStringOverride: false)
sealed class HttpErrorContent with _$HttpErrorContent {
  const factory HttpErrorContent({
    String? code,
    String? detail,
    @Default([]) List<HttpFieldError> errors,
  }) = _HttpErrorContent;

  factory HttpErrorContent.fromJson(Map<String, dynamic> json) =>
      _$HttpErrorContentFromJson(json);

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

    if (withErrors && errors.isNotEmpty) {
      var withNewline = buffer.isNotEmpty;
      for (final error in errors) {
        if (withNewline) {
          buffer.writeln();
        }
        buffer
          ..write(' | ')
          ..write(error);
        withNewline = true;
      }
    }

    if (buffer.isEmpty) {
      return 'Unknown error';
    } else {
      return buffer.toString();
    }
  }
}
