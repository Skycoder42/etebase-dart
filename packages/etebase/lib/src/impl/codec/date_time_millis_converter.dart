import 'package:json_annotation/json_annotation.dart';

/// A custom converter for converter [DateTime] objects from and to JSON as
/// milliseconds. They are counted from the start of the epoch in UTC.
const dateTimeMillis = DateTimeMillisConverter();

/// A custom converter for converter [DateTime] objects from and to JSON as
/// milliseconds. They are counted from the start of the epoch in UTC.
class DateTimeMillisConverter implements JsonConverter<DateTime, int> {
  /// Default constructor.
  const new();

  @override
  DateTime fromJson(int json) =>
      DateTime.fromMillisecondsSinceEpoch(json, isUtc: true);

  @override
  int toJson(DateTime object) => object.millisecondsSinceEpoch;
}
