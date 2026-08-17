import 'dart:io';

import 'package:etebase/etebase.dart';
import 'package:etebase_flutter/src/impl/flutter_client_impl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class FakeCryptoExecutor extends Fake implements CryptoExecutor;

class TestPathProviderPlatform extends PathProviderPlatform {
  final String testPath;

  new(this.testPath);

  @override
  Future<String?> getApplicationDocumentsPath() => Future.value(testPath);
}

void main() {
  group('$FlutterClientImpl', () {
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

      test(
        'hiveInit does not initialize if auto init is false',
        testOn: '!browser',
        () async {
          await FlutterClientImpl.hiveInit(false);

          expect(() => Hive.boxExists('testBox'), throwsArgumentError);
        },
      );

      test('hiveInit initialized hive with custom directory', () async {
        await FlutterClientImpl.hiveInit(true);

        expect(await Hive.boxExists('testBox'), isFalse);

        final testBox = await Hive.openBox<String>('testBox');
        addTearDown(testBox.close);

        expect(await Hive.boxExists('testBox'), isTrue);

        if (!kIsWeb) {
          expect(
            testBox.path,
            allOf(
              startsWith(Directory.systemTemp.path),
              endsWith(path.join('etebase', 'testbox.hive')),
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
