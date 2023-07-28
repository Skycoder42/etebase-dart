import 'dart:convert';
import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'serializer.dart';

abstract base class JsonSerializer<TData, TJson> implements Serializer<TData> {
  final Encoding encoding;

  const JsonSerializer({
    this.encoding = utf8,
  });

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
