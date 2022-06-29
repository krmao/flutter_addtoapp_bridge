import 'package:flutter/services.dart';

import 'flutter_addtoapp_bridge_platform_interface.dart';

class FlutterAddtoappBridge {
  static Future<String?> getPlatformVersion() {
    return FlutterAddtoappBridgePlatform.instance.getPlatformVersion();
  }

  static Future<bool> isAddToApp() {
    return FlutterAddtoappBridgePlatform.instance.isAddToApp();
  }

  static Future<bool> exitApp() {
    return FlutterAddtoappBridgePlatform.instance.exitApp();
  }

  static Future<String?> putString(String key, String value) {
    return FlutterAddtoappBridgePlatform.instance.putString(key, value);
  }

  static Future<String?> getString(String key, {defaultValue = ""}) {
    return FlutterAddtoappBridgePlatform.instance.getString(key, defaultValue: defaultValue);
  }

  static Future<String?> putLong(String key, int value) {
    return FlutterAddtoappBridgePlatform.instance.putLong(key, value);
  }

  static Future<int?> getLong(String key, {defaultValue = 0}) {
    return FlutterAddtoappBridgePlatform.instance.getLong(key, defaultValue: defaultValue);
  }

  static Future<String?> putFloat(String key, double value) {
    return FlutterAddtoappBridgePlatform.instance.putFloat(key, value);
  }

  static Future<double?> getFloat(String key, {defaultValue = 0.0}) {
    return FlutterAddtoappBridgePlatform.instance.getFloat(key, defaultValue: defaultValue);
  }

  static Future<dynamic> open(String key, [dynamic value]) {
    return callPlatform("open", [key, value]);
  }

  static Future<dynamic> callPlatform(String key, [dynamic arguments]) {
    return FlutterAddtoappBridgePlatform.instance.callPlatform(key, arguments);
  }

  static void setMethodCallHandler(Future<dynamic> Function(MethodCall call)? handler) {
    return FlutterAddtoappBridgePlatform.instance.setMethodCallHandler(handler);
  }
}
