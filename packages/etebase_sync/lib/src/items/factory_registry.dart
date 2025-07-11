import 'package:etebase/etebase.dart';

import '../exceptions/missing_type_registration_error.dart';
import 'items.dart';

typedef ItemRecordFactory<TRecord extends ItemRecord> =
    TRecord Function(Repository<TRecord> repository, Item item);

typedef _Registration<TRecord extends ItemRecord> = ({
  String collectionType,
  ItemRecordFactory<TRecord> factory,
});

class FactoryRegistry {
  final _repositoryConfig = <Type, _Registration>{};

  void registerType<TRecord extends ItemRecord>(
    String collectionType,
    ItemRecordFactory<TRecord> factory,
  ) => _repositoryConfig[TRecord] =
      (collectionType: collectionType, factory: factory) as _Registration;

  String typeFor<TRecord extends ItemRecord>() =>
      _registration<TRecord>().collectionType;

  ItemRecordFactory<TRecord> itemFactoryFor<TRecord extends ItemRecord>() =>
      _registration<TRecord>().factory;

  _Registration<TRecord> _registration<TRecord extends ItemRecord>() {
    final registration = _repositoryConfig[TRecord];
    if (registration == null) {
      throw MissingTypeRegistrationError(TRecord);
    }
    return registration as _Registration<TRecord>;
  }
}
