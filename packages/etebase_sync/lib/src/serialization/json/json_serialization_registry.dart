import '../serialization_registry.dart';
import 'json_serializer.dart';

final class JsonSerializationRegistry implements SerializationRegistry {
  final JsonSerializer _fallbackSerializer;

  final _serializers = <String, JsonSerializer>{};
  final _knownItemTypes = <Type, String>{};

  JsonSerializationRegistry({
    JsonSerializer fallbackSerializer = JsonSerializer.untyped,
  }) : _fallbackSerializer = fallbackSerializer;

  void register<TData, TJson>(
    String itemType,
    FromJsonFactory<TData, TJson> fromJson, [
    ToJsonFactory<TData, TJson>? toJson,
  ]) =>
      registerInstance<TData, TJson>(
        itemType,
        JsonSerializer.factory(fromJson, toJson),
      );

  void registerInstance<TData, TJson>(
    String itemType,
    JsonSerializer<TData, TJson> serializer,
  ) {
    _knownItemTypes[TData] = itemType;
    _serializers[itemType] = serializer;
  }

  void reset() {
    _knownItemTypes.clear();
    _serializers.clear();
  }

  @override
  String? findItemType(Type type) => _knownItemTypes[type];

  @override
  JsonSerializer getSerializer(String? itemType) =>
      _serializers[itemType] ?? _fallbackSerializer;
}
