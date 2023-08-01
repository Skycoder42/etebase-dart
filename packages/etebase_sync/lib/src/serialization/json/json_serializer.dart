import 'dart:convert';
import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../serializer.dart';

typedef FromJsonFactory<TData, TJson> = TData Function(TJson json);
typedef ToJsonFactory<TData, TJson> = TJson Function(TData data);

abstract base class JsonSerializer<TData, TJson> implements Serializer<TData> {
  static const untyped = _UntypedJsonSerializer();

  final Encoding encoding;

  const JsonSerializer({
    this.encoding = utf8,
  });

  const factory JsonSerializer.factory(
    FromJsonFactory<TData, TJson> fromJson, [
    ToJsonFactory<TData, TJson>? toJson,
  ]) = _FactoryJsonSerializer<TData, TJson>;

  @override
  @nonVirtual
  TData deserialize(Uint8List data) => fromJson(
        json.decode(
          encoding.decode(data),
        ) as TJson,
      );

  @override
  @nonVirtual
  Uint8List serialize(TData data) => Uint8List.fromList(
        encoding.encode(
          json.encode(
            toJson(data),
          ),
        ),
      );

  @visibleForOverriding
  TData fromJson(TJson json);

  @visibleForOverriding
  dynamic toJson(TData data) => data;
}

final class _UntypedJsonSerializer extends JsonSerializer<dynamic, dynamic> {
  const _UntypedJsonSerializer();

  @override
  dynamic fromJson(dynamic json) => json;
}

final class _FactoryJsonSerializer<TData, TJson>
    extends JsonSerializer<TData, TJson> {
  final FromJsonFactory<TData, TJson> _fromJson;
  final ToJsonFactory<TData, TJson>? _toJson;

  const _FactoryJsonSerializer(
    this._fromJson, [
    ToJsonFactory<TData, TJson>? toJson,
  ]) : _toJson = toJson;

  @override
  TData fromJson(TJson json) => _fromJson(json);

  @override
  dynamic toJson(TData data) => _toJson?.call(data) ?? data;
}
