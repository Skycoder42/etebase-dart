part of 'items.dart';

abstract interface class BackgroundSync {
  Future<void> syncOnce();

  void startSync();

  void stopSync();
}

abstract class ManualBackgroundSync implements BackgroundSync {}

abstract class PeriodicBackgroundSync implements BackgroundSync {}

abstract class LiveBackgroundSync implements BackgroundSync {}
