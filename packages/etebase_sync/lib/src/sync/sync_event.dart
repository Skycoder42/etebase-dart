import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_event.freezed.dart';

@freezed
sealed class SyncEvent with _$SyncEvent {
  const factory SyncEvent.uploaded(String uid, String etag) = SyncUploadedEvent;
  const factory SyncEvent.offline(String uid) = SyncOfflineEvent;
  const factory SyncEvent.downloadStarted([String? scope]) =
      SyncDownloadStartedEvent;
  const factory SyncEvent.downloaded(String uid, String etag) =
      SyncDownloadedEvent;
  const factory SyncEvent.downloadFinished([String? scope]) =
      SyncDownloadFinishedEvent;

  const SyncEvent._();

  String? get uid => switch (this) {
    SyncUploadedEvent(:final uid) => uid,
    SyncOfflineEvent(:final uid) => uid,
    SyncDownloadStartedEvent() => null,
    SyncDownloadedEvent(:final uid) => uid,
    SyncDownloadFinishedEvent() => null,
  };
}
