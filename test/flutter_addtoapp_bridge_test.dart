import 'package:flutter/src/services/message_codec.dart';
import 'package:flutter_addtoapp_bridge/flutter_addtoapp_bridge.dart';
import 'package:flutter_addtoapp_bridge/flutter_addtoapp_bridge_method_channel.dart';
import 'package:flutter_addtoapp_bridge/flutter_addtoapp_bridge_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterAddtoappBridgePlatform with MockPlatformInterfaceMixin implements FlutterAddtoappBridgePlatform {
  @override
  Future callPlatform(String key, [arguments]) => Future.value('42');

  @override
  void setMethodCallHandler(Future Function(MethodCall call)? handler) {}
}

void main() {
  final FlutterAddtoappBridgePlatform initialPlatform = FlutterAddtoappBridgePlatform.instance;

  test('$MethodChannelFlutterAddtoappBridge is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterAddtoappBridge>());
  });

  test('getPlatformVersion', () async {
    FlutterAddtoappBridge flutterAddtoappBridgePlugin = FlutterAddtoappBridge();
    MockFlutterAddtoappBridgePlatform fakePlatform = MockFlutterAddtoappBridgePlatform();
    FlutterAddtoappBridgePlatform.instance = fakePlatform;

    expect(await flutterAddtoappBridgePlugin.getPlatformVersion(), '42');
  });
}
