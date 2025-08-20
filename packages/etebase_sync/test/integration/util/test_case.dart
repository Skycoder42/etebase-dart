import 'dart:io';

import 'package:etebase/etebase.dart';
import 'package:etebase_sync/etebase_sync.dart';
import 'package:etebase_sync/src/online/online_status.dart';
import 'package:etebase_sync/src/sync/storage_mode.dart';
import 'package:hive_ce/hive.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:sodium/sodium_sumo.dart';
import 'package:test/test.dart';

import '../../../../../tool/libsodium_loader/library_loader.dart';
import 'in_memory_keystore.dart';
import 'mocks.dart';
import 'test_online_checker.dart';

abstract class TestCase {
  final mockConflictResolver = MockCollectionConflictResolver();
  final testOnlineChecker = TestOnlineChecker();

  late final Directory _hiveDir;

  late final EtebaseSync _main;
  late final EtebaseSync _tester;

  void run() {
    setUpAll(_setupAll);
    tearDownAll(_tearDownAll);

    setUp(_setup);
    tearDown(() {
      Future.delayed(const Duration(seconds: 2), () => exit(0)).ignore();
    });

    configure();
  }

  @visibleForOverriding
  @mustCallSuper
  void registerTypes(EtebaseSync sync) {}

  @visibleForOverriding
  void configure();

  Future<void> _setupAll() async {
    Logger.root
      ..level = Level.ALL
      // ignore: avoid_print ok for testing
      ..onRecord.listen(print);

    if (!kIsWeb) {
      _hiveDir = await Directory.systemTemp.createTemp();
      Hive.init(_hiveDir.path);
    } else {
      Hive.init(null);
    }

    final sodium = await SodiumSumoInit.init(getLibsodium);

    _main = EtebaseSync(
      client: Client.create(
        sodium,
        'etebase_sync_example',
        Uri.http('127.0.0.1:3735'),
      ),
      keystore: InMemoryKeystore(),
      onlineChecker: testOnlineChecker,
      conflictResolver: mockConflictResolver,
    );
    registerTypes(_main);

    _tester = EtebaseSync.prefixed(
      prefix: 'tester',
      client: Client.create(
        sodium,
        'etebase_sync_example',
        Uri.http('127.0.0.1:3735'),
      ),
      keystore: InMemoryKeystore(),
      onlineChecker: testOnlineChecker,
      conflictResolver: mockConflictResolver,
      storageMode: StorageMode.lazy,
    );
    registerTypes(_tester);

    await _main.init();
    await _tester.init();
  }

  void _setup() {
    reset(mockConflictResolver);

    testOnlineChecker.testStatus = OnlineStatus.online;
  }

  Future<void> _tearDownAll() async {
    await _tester.dispose();
    await _main.dispose();

    await Hive.close();
    if (!kIsWeb) {
      await _hiveDir.delete(recursive: true);
    }
  }
}
