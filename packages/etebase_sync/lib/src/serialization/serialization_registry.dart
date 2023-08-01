import 'serializer.dart';

abstract interface class SerializationRegistry {
  String? findItemType(Type type);

  Serializer getSerializer(String? itemType);
}
