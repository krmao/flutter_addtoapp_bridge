import 'package:flutter/services.dart';

import 'flutter_addtoapp_bridge_platform_interface.dart';

class FlutterAddtoappBridge {
  Future<String?> getPlatformVersion() {
    return FlutterAddtoappBridgePlatform.instance.getPlatformVersion();
  }

  Future<bool?> isAddToApp() {
    return FlutterAddtoappBridgePlatform.instance.isAddToApp();
  }

  Future<String?> putString(String key, String value) {
    return FlutterAddtoappBridgePlatform.instance.putString(key, value);
  }

  Future<String?> getString(String key, {defaultValue = ""}) {
    return FlutterAddtoappBridgePlatform.instance.getString(key, [defaultValue]);
  }

  Future<String?> putLong(String key, String value) {
    return FlutterAddtoappBridgePlatform.instance.putLong(key, value);
  }

  Future<int?> getLong(String key, [defaultValue = 0]) {
    return FlutterAddtoappBridgePlatform.instance.getLong(key, [defaultValue]);
  }

  Future<String?> putFloat(String key, String value) {
    return FlutterAddtoappBridgePlatform.instance.putFloat(key, value);
  }

  Future<double?> getFloat(String key, [defaultValue = 0.0]) {
    return FlutterAddtoappBridgePlatform.instance.getFloat(key, [defaultValue]);
  }

  Future<dynamic> open(String key, [dynamic value]) {
    return callPlatform("open", [key, value]);
  }

  Future<dynamic> callPlatform(String key, [dynamic arguments]) {
    return FlutterAddtoappBridgePlatform.instance.callPlatform(key, arguments);
  }

  void setMethodCallHandler(Future<dynamic> Function(MethodCall call)? handler) {
    return FlutterAddtoappBridgePlatform.instance.setMethodCallHandler(handler);
  }
}
