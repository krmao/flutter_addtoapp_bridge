import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_addtoapp_bridge/flutter_addtoapp_bridge_method_channel.dart';

void main() {
  MethodChannelFlutterAddtoappBridge platform =
      MethodChannelFlutterAddtoappBridge();
  const MethodChannel channel = MethodChannel('flutter_addtoapp_bridge');

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
