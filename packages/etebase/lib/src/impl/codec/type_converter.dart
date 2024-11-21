import 'package:meta/meta.dart';

/// @nodoc
@internal
typedef FromJson<T> = T Function(Map<String, dynamic> json);

/// @nodoc
@internal
typedef FromJsonList<T> = T Function(List<dynamic> json);

/// @nodoc
@internal
typedef ContainerFromJson<TContainer, TData> = TContainer Function(
  Map<String, dynamic> json,
  TData Function(Object?) fromJson,
);

@internal
sealed class TypeConverter<T> {
  const factory TypeConverter(FromJson<T> fromJson) = _DefaultTypeConverter<T>;

  const factory TypeConverter.list(FromJsonList<T> fromJson) =
      _ListTypeConverter<T>;

  static TypeConverter<TContainer> generic<TContainer, TData>(
    ContainerFromJson<TContainer, TData> containerFromJson,
    FromJson<TData> fromJson,
  ) =>
      _GenericTypeConverter<TContainer, TData>(containerFromJson, fromJson);

  T call(dynamic data);
}

class _DefaultTypeConverter<T> implements TypeConverter<T> {
  final FromJson<T> _fromJson;

  const _DefaultTypeConverter(this._fromJson);

  @override
  T call(dynamic data) => _fromJson((data as Map).cast());
}

class _ListTypeConverter<T> implements TypeConverter<T> {
  final FromJsonList<T> _fromJson;

  const _ListTypeConverter(this._fromJson);

  @override
  T call(dynamic data) => _fromJson(data as List);
}

class _GenericTypeConverter<TContainer, TData>
    implements TypeConverter<TContainer> {
  final ContainerFromJson<TContainer, TData> _containerFromJson;
  final FromJson<TData> _fromJson;

  const _GenericTypeConverter(this._containerFromJson, this._fromJson);

  @override
  TContainer call(dynamic data) => _containerFromJson(
        (data as Map).cast(),
        (data) => _fromJson((data! as Map).cast()),
      );
}
