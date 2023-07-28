import 'dart:typed_data';

abstract interface class Serializer<TData> {
  TData deserialize(Uint8List data);

  Uint8List serialize(TData data);
}
