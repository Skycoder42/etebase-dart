import 'package:etebase/etebase.dart';

import 'etebase_sync_exception.dart';

class ReadOnlyCollection extends EtebaseSyncException {
  final String uid;
  final CollectionAccessLevel collectionAccessLevel;

  ReadOnlyCollection(this.uid, this.collectionAccessLevel)
    : super('Cannot modify items in a read only collection (uid: "$uid")');

  @override
  String get name => 'ReadOnlyCollection';
}
