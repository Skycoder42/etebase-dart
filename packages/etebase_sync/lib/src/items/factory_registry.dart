import '../exceptions/missing_type_registration_error.dart';
import 'item_record_factory.dart';
import 'items.dart';

typedef _Registration<TRecord extends ItemRecord> = ({
  String collectionType,
  ItemRecordFactory<TRecord> factory,
});

class FactoryRegistry {
  final _repositoryConfig = <Type, _Registration>{};

  void registerType<TRecord extends ItemRecord>(
    String collectionType,
    ItemRecordFactory<TRecord> factory,
  ) => _repositoryConfig[TRecord] = (
    collectionType: collectionType,
    factory: factory,
  );

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
