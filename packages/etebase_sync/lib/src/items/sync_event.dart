import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_event.freezed.dart';

@freezed
sealed class SyncEvent with _$SyncEvent {
  const factory SyncEvent.uploaded(String uid, String etag) = SyncUploadedEvent;
  const factory SyncEvent.offline(String uid) = SyncOfflineEvent;
}
