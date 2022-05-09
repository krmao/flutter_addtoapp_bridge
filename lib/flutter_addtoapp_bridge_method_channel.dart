import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_addtoapp_bridge_platform_interface.dart';

/// An implementation of [FlutterAddtoappBridgePlatform] that uses method channels.
class MethodChannelFlutterAddtoappBridge extends FlutterAddtoappBridgePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_addtoapp_bridge');

  Future<dynamic> getPlatformVersion() {
    return callPlatform("getPlatformVersion");
  }

  Future<dynamic> putPlatformValue(String key, dynamic value) {
    return callPlatform("putPlatformValue", [key, value]);
  }

  Future<dynamic> getPlatformValue(String key) {
    return callPlatform("getPlatformValue", key);
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
