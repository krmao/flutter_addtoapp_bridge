import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_addtoapp_bridge_platform_interface.dart';

/// An implementation of [FlutterAddtoappBridgePlatform] that uses method channels.
class MethodChannelFlutterAddtoappBridge extends FlutterAddtoappBridgePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const OptionalMethodChannel('flutter_addtoapp_bridge');

  @override
  Future<String?> getPlatformVersion() async {
    return Future.value(await callPlatform("getPlatformVersion"));
  }

  /**
   * objc should be return @(YES) not @(true), or it's runtimeType will be int
   */
  @override
  Future<bool> isAddToApp() async {
    var returnValue = await callPlatform("isAddToApp");
    if (returnValue is int) {
      print("isAddToApp=$returnValue type=${returnValue.runtimeType} objc should be return @(YES) not @(true)");
      return Future.value(returnValue == 1);
    } else if (returnValue is bool) {
      return Future.value(returnValue);
    } else {
      print("isAddToApp=$returnValue type=${returnValue.runtimeType} objc should be return @(YES) not @(true)");
      return Future.value(false);
    }
  }

  @override
  Future<String?> putString(String key, String value) async {
    return Future.value(await callPlatform("putString", [key, value]));
  }

  @override
  Future<String?> getString(String key, {defaultValue = ""}) async {
    return Future.value(await callPlatform("getString", [key, defaultValue]));
  }

  @override
  Future<String?> putLong(String key, int value) async {
    return Future.value(await callPlatform("putLong", [key, value]));
  }

  @override
  Future<int?> getLong(String key, {defaultValue = 0}) async {
    return Future.value(await callPlatform("getLong", [key, defaultValue]));
  }

  @override
  Future<String?> putFloat(String key, double value) async {
    return Future.value(await callPlatform("putFloat", [key, value]));
  }

  @override
  Future<double?> getFloat(String key, {defaultValue = 0.0}) async {
    return Future.value(await callPlatform("getFloat", [key, defaultValue]));
  }

  /**
   * [ERROR:flutter/lib/ui/ui_dart_state.cc(209)] Unhandled Exception: MissingPluginException(No implementation found for method callPlatform on channel flutter_addtoapp_bridge)
   *
   * return null if MissingPluginException
   */
  @override
  Future<dynamic> callPlatform(String key, [dynamic arguments]) async {
    return await methodChannel.invokeMethod<dynamic>("callPlatform", [key, arguments]);
  }

  @override
  void setMethodCallHandler(Future<dynamic> Function(MethodCall call)? handler) {
    return methodChannel.setMethodCallHandler(handler);
  }
}
