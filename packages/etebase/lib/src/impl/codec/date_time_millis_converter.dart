import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

/// @nodoc
@internal
const dateTimeMillis = DateTimeMillisConverter();

@internal
class DateTimeMillisConverter implements JsonConverter<DateTime, int> {
  const DateTimeMillisConverter();

  @override
  DateTime fromJson(int json) => DateTime.fromMillisecondsSinceEpoch(json);

  @override
  int toJson(DateTime object) => object.millisecondsSinceEpoch;
}
