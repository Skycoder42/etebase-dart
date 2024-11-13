import 'package:meta/meta.dart';

/// @nodoc
@internal
typedef FromJson<T> = T Function(Map<String, dynamic> json);

/// @nodoc
@internal
typedef ContainerFromJson<TContainer, TData> = TContainer Function(
  Map<String, dynamic> json,
  TData Function(Object?) fromJson,
);

@internal
sealed class TypeConverter<T> {
  const factory TypeConverter(FromJson<T> fromJson) = _DefaultTypeConverter<T>;

  const factory TypeConverter.raw() = _RawTypeConverter<T>;

  static TypeConverter<List<T>> list<T>(FromJson<T> fromJson) =>
      _ListTypeConverter<T>(fromJson);

  static TypeConverter<Map<String, T>> map<T>(FromJson<T> fromJson) =>
      _MapTypeConverter<T>(fromJson);

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

class _RawTypeConverter<T> implements TypeConverter<T> {
  const _RawTypeConverter();

  @override
  T call(dynamic data) => data as T;
}

class _ListTypeConverter<T> implements TypeConverter<List<T>> {
  final FromJson<T> _fromJson;

  const _ListTypeConverter(this._fromJson);

  @override
  List<T> call(dynamic data) => [
        for (final value in data as List) _fromJson((value as Map).cast()),
      ];
}

class _MapTypeConverter<T> implements TypeConverter<Map<String, T>> {
  final FromJson<T> _fromJson;

  const _MapTypeConverter(this._fromJson);

  @override
  Map<String, T> call(dynamic data) => {
        for (final MapEntry(:key, :value) in (data as Map).entries)
          key as String: _fromJson((value as Map).cast()),
      };
}

class _GenericTypeConverter<TContainer, TData>
    implements TypeConverter<TContainer> {
  final ContainerFromJson<TContainer, TData> _containerFromJson;
  final FromJson<TData> _fromJson;

  const _GenericTypeConverter(this._containerFromJson, this._fromJson);

  @override
  TContainer call(dynamic data) => _containerFromJson(
        (data as Map).cast(),
        (data) => _fromJson(data! as Map<String, dynamic>),
      );
}
