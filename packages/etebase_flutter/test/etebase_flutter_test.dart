import 'package:etebase_flutter/etebase_flutter.dart';
import 'package:etebase_flutter/etebase_flutter_method_channel.dart';
import 'package:etebase_flutter/etebase_flutter_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockEtebaseFlutterPlatform
    with
        // ignore: prefer_mixin
        MockPlatformInterfaceMixin
    implements
        EtebaseFlutterPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final initialPlatform = EtebaseFlutterPlatform.instance;

  test('$MethodChannelEtebaseFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelEtebaseFlutter>());
  });

  test('getPlatformVersion', () async {
    final etebaseFlutterPlugin = EtebaseFlutter();
    final fakePlatform = MockEtebaseFlutterPlatform();
    EtebaseFlutterPlatform.instance = fakePlatform;

    expect(await etebaseFlutterPlugin.getPlatformVersion(), '42');
  });
}
