import 'package:etebase/etebase.dart';

abstract interface class RepositoryAdapter<T extends Object> {
  dynamic toMsgPack(T value);

  ItemMetadata? updateMeta(ItemMetadata? current, T value);
}
