import 'package:freezed_annotation/freezed_annotation.dart';

part 'value_or_deleted.freezed.dart';

@freezed
class ValueOrDeleted<TValue extends Object> with _$ValueOrDeleted<TValue> {
  const factory ValueOrDeleted(TValue value) = Value;
  const factory ValueOrDeleted.deleted() = Deleted;
}
