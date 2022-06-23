import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_addtoapp_bridge_platform_interface.dart';

/// An implementation of [FlutterAddtoappBridgePlatform] that uses method channels.
class MethodChannelFlutterAddtoappBridge extends FlutterAddtoappBridgePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_addtoapp_bridge');

  @override
  Future<String> getPlatformVersion() {
    return callPlatform("getPlatformVersion") as Future<String>;
  }

  @override
  Future<bool> isAddToApp() {
    return callPlatform("isAddToApp") as Future<bool>;
  }

  @override
  Future<String> putString(String key, String value) {
    return callPlatform("putString", [key, value]) as Future<String>;
  }

  @override
  Future<String> getString(String key, [defaultValue = ""]) {
    return callPlatform("getString", [key, defaultValue]) as Future<String>;
  }

  @override
  Future<String> putLong(String key, String value) {
    return callPlatform("putLong", [key, value]) as Future<String>;
  }

  @override
  Future<int> getLong(String key, [defaultValue = 0]) {
    return callPlatform("getLong", [key, defaultValue]) as Future<int>;
  }

  @override
  Future<String> putFloat(String key, String value) {
    return callPlatform("putFloat", [key, value]) as Future<String>;
  }

  @override
  Future<double> getFloat(String key, [defaultValue = 0.0]) {
    return callPlatform("getFloat", [key, defaultValue]) as Future<double>;
  }

  @override
  Future<dynamic> callPlatform(String key, [dynamic arguments]) async {
    return await methodChannel.invokeMethod<dynamic>("callPlatform", [key, arguments]);
  }

  @override
  void setMethodCallHandler(Future<dynamic> Function(MethodCall call)? handler) {
    return methodChannel.setMethodCallHandler(handler);
  }
}
