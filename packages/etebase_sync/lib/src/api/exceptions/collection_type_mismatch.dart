import 'etebase_sync_exception.dart';

class CollectionTypeMismatch extends EtebaseSyncException {
  final String colUid;
  final String expectedCollectionType;
  final String actualCollectionType;

  CollectionTypeMismatch({
    required this.colUid,
    required this.expectedCollectionType,
    required this.actualCollectionType,
  }) : super(
         'Expected collection with id "$colUid" to have type '
         '"$expectedCollectionType", but was "$actualCollectionType"',
       );

  @override
  String get name => 'CollectionTypeMismatch';
}
