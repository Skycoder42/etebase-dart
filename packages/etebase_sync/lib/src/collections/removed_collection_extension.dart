import 'package:etebase/etebase.dart';

extension RemovedCollectionX on Collection {
  static final _expando = Expando<bool>();

  bool get isRemoved => _expando[this] ?? false;

  set isRemoved(bool isRemoved) => _expando[this] = isRemoved;
}
