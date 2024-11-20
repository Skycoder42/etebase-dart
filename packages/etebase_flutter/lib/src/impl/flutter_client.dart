// ignore: implementation_imports
import 'package:etebase/src/impl/managers/client.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sodium_libs/sodium_libs_sumo.dart';

import '../api/etebase_flutter_client.dart';

@internal
// ignore: invalid_use_of_internal_member
class FlutterClient extends Client implements EtebaseFlutterClient {
  static Future<SodiumSumo> get sodiumInstance => SodiumSumoInit.init();

  static Future<String> get clientName async {
    final packageInfo = await PackageInfo.fromPlatform();
    return '${packageInfo.packageName}/${packageInfo.version}/${packageInfo.buildNumber}';
  }

  static var _didHiveInit = false;
  // ignore: avoid_positional_boolean_parameters
  static Future<void> hiveInit(bool autoInit) async {
    if (!autoInit || _didHiveInit) {
      return;
    }

    _didHiveInit = true;
    return Hive.initFlutter('etebase');
  }

  FlutterClient.create(
    super.cryptoExecutor,
    super.clientName,
    super.serverUrl,
  ) : super.create();
}
