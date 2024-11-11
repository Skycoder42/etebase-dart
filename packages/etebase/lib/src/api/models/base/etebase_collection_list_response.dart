// ignore_for_file: invalid_annotation_target

import '../etebase_removed_collection.dart';
import 'etebase_collection_item_list_response.dart';

/// The dart binding of the EtebaseCollectionListResponse rust class
abstract interface class EtebaseCollectionListResponse<T>
    implements EtebaseCollectionItemListResponse<T> {
  /// The list of collections to which the user lost access
  List<EtebaseRemovedCollection>? get removedMemberships;
}
