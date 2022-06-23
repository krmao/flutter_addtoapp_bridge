import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_addtoapp_bridge_platform_interface.dart';

/// An implementation of [FlutterAddtoappBridgePlatform] that uses method channels.
class MethodChannelFlutterAddtoappBridge extends FlutterAddtoappBridgePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_addtoapp_bridge');

  @override
  Future<String> getPlatformVersion() async {
    return Future.value(await callPlatform("getPlatformVersion"));
  }

  @override
  Future<bool> isAddToApp() async {
    return Future.value(await callPlatform("isAddToApp"));
  }

  @override
  Future<String> putString(String key, String value) async {
    return Future.value(await callPlatform("putString", [key, value]));
  }

  @override
  Future<String> getString(String key, [defaultValue = ""]) async {
    return Future.value(await callPlatform("getString", [key, defaultValue]));
  }

  @override
  Future<String> putLong(String key, String value) async {
    return Future.value(await callPlatform("putLong", [key, value]));
  }

  @override
  Future<int> getLong(String key, [defaultValue = 0]) async {
    return Future.value(await callPlatform("getLong", [key, defaultValue]));
  }

  @override
  Future<String> putFloat(String key, String value) async {
    return Future.value(await callPlatform("putFloat", [key, value]));
  }

  @override
  Future<double> getFloat(String key, [defaultValue = 0.0]) async {
    return Future.value(await callPlatform("getFloat", [key, defaultValue]));
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
