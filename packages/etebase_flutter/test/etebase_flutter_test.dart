import 'package:flutter_test/flutter_test.dart';
import 'package:etebase_flutter/etebase_flutter.dart';
import 'package:etebase_flutter/etebase_flutter_platform_interface.dart';
import 'package:etebase_flutter/etebase_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockEtebaseFlutterPlatform
    with MockPlatformInterfaceMixin
    implements EtebaseFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final EtebaseFlutterPlatform initialPlatform = EtebaseFlutterPlatform.instance;

  test('$MethodChannelEtebaseFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelEtebaseFlutter>());
  });

  test('getPlatformVersion', () async {
    EtebaseFlutter etebaseFlutterPlugin = EtebaseFlutter();
    MockEtebaseFlutterPlatform fakePlatform = MockEtebaseFlutterPlatform();
    EtebaseFlutterPlatform.instance = fakePlatform;

    expect(await etebaseFlutterPlugin.getPlatformVersion(), '42');
  });
}
