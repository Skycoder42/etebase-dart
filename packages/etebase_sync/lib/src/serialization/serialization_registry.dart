import 'serializer.dart';

abstract class SerializationRegistry {
  Serializer getSerializer(String itemType);
}
