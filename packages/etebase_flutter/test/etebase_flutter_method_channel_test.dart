import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:etebase_flutter/etebase_flutter_method_channel.dart';

void main() {
  MethodChannelEtebaseFlutter platform = MethodChannelEtebaseFlutter();
  const MethodChannel channel = MethodChannel('etebase_flutter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
