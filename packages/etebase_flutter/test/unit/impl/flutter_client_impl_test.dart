import 'dart:io';

import 'package:etebase/etebase.dart';
import 'package:etebase_flutter/src/impl/flutter_client_impl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:sodium_libs/sodium_libs_sumo.dart';

class FakeSodiumSumo extends Fake implements SodiumSumo {
  @override
  SodiumVersion get version => const SodiumVersion(26, 2, '1.0.20');
}

class FakeCryptoExecutor extends Fake implements CryptoExecutor {}

class TestPathProviderPlatform extends PathProviderPlatform {
  final String testPath;

  TestPathProviderPlatform(this.testPath);

  @override
  Future<String?> getApplicationDocumentsPath() => Future.value(testPath);
}

class TestSodiumPlatform extends SodiumPlatform {
  final SodiumSumo sodium;

  TestSodiumPlatform(this.sodium);

  @override
  Future<Sodium> loadSodium() => Future.value(sodium);

  @override
  Future<SodiumSumo> loadSodiumSumo() => Future.value(sodium);
}

void main() {
  group('$FlutterClientImpl', () {
    test('sodiumInstance initializes flutter sodium', () async {
      final testSodium = FakeSodiumSumo();
      SodiumPlatform.instance = TestSodiumPlatform(testSodium);

      final result = await FlutterClientImpl.sodiumInstance;

      expect(result, same(testSodium));
    });

    test('clientName creates name from package info', () async {
      const packageName = 'test_package_name';
      const version = '1.2.3';
      const buildNumber = '47-dev';
      PackageInfo.setMockInitialValues(
        appName: 'appName',
        packageName: packageName,
        version: version,
        buildNumber: buildNumber,
        buildSignature: 'buildSignature',
      );

      final clientName = await FlutterClientImpl.clientName;

      expect(clientName, '$packageName/$version/$buildNumber');
    });

    group('hiveInit', () {
      setUpAll(() async {
        if (!kIsWeb) {
          final testDir = await Directory.systemTemp.createTemp();
          addTearDown(() async => await testDir.delete(recursive: true));

          PathProviderPlatform.instance = TestPathProviderPlatform(
            testDir.path,
          );
        }
      });

      test('hiveInit does not initialize if auto init is false', () async {
        await FlutterClientImpl.hiveInit(false);

        expect(() => Hive.boxExists('testBox'), throwsArgumentError);
      });

      test('hiveInit initialized hive with custom directory', () async {
        await FlutterClientImpl.hiveInit(true);

        expect(await Hive.boxExists('testBox'), isFalse);

        final testBox = await Hive.openBox<String>('testBox');

        expect(await Hive.boxExists('testBox'), isTrue);

        if (!kIsWeb) {
          expect(
            testBox.path,
            allOf(
              startsWith(Directory.systemTemp.path),
              endsWith('/etebase/testbox.hive'),
            ),
          );
        }
      });

      test('hiveInit does nothing if already initialized', () async {
        await FlutterClientImpl.hiveInit(true);

        expect(await Hive.boxExists('testBox'), isTrue);
      });
    });

    test('create creates client', () {
      final sut = FlutterClientImpl.create(
        FakeCryptoExecutor(),
        'clientName',
        null,
      );

      expect(sut.baseUrl, Client.defaultServerUrl);
    });
  });
}
