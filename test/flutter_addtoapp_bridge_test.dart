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

  @override
  Future<double> getFloat(String key, {defaultValue = 0.0}) {
    return Future.value(0.0);
  }

  @override
  Future<int> getLong(String key, {defaultValue = 0}) {
    return Future.value(0);
  }

  @override
  Future<String> getPlatformVersion() {
    return Future.value('0');
  }

  @override
  Future<String> getString(String key, {defaultValue = ""}) {
    return Future.value('0');
  }

  @override
  Future<bool> isAddToApp() {
    return Future.value(false);
  }

  @override
  Future<String> putFloat(String key, double value) {
    return Future.value('0');
  }

  @override
  Future<String> putLong(String key, int value) {
    return Future.value('0');
  }

  @override
  Future<String> putString(String key, String value) {
    return Future.value('0');
  }

  @override
  Future<bool> exitApp() {
    return Future.value(false);
  }

  @override
  void back({count = 1}) {}

  @override
  void showToast(String? message) {}

  @override
  void openContainer(
    String? entrypoint, {
    initialRoute = "/",
    newEngine = false,
    destroyEngine = false,
    transparent = false,
  }) {}
}

void main() {
  final FlutterAddtoappBridgePlatform initialPlatform = FlutterAddtoappBridgePlatform.instance;

  test('$MethodChannelFlutterAddtoappBridge is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterAddtoappBridge>());
  });

  test('getPlatformVersion', () async {
    MockFlutterAddtoappBridgePlatform fakePlatform = MockFlutterAddtoappBridgePlatform();
    FlutterAddtoappBridgePlatform.instance = fakePlatform;

    expect(await FlutterAddtoappBridge.getPlatformVersion(), '42');
  });
}
