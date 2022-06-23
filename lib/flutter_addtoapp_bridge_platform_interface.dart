import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_addtoapp_bridge_method_channel.dart';

abstract class FlutterAddtoappBridgePlatform extends PlatformInterface {
  /// Constructs a FlutterAddtoappBridgePlatform.
  FlutterAddtoappBridgePlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterAddtoappBridgePlatform _instance = MethodChannelFlutterAddtoappBridge();

  /// The default instance of [FlutterAddtoappBridgePlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterAddtoappBridge].
  static FlutterAddtoappBridgePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterAddtoappBridgePlatform] when
  /// they register themselves.
  static set instance(FlutterAddtoappBridgePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<dynamic> callPlatform(String key, [dynamic arguments]) {
    throw UnimplementedError('callPlatform() has not been implemented.');
  }

  void setMethodCallHandler(Future<dynamic> Function(MethodCall call)? handler) {
    throw UnimplementedError('setMethodCallHandler() has not been implemented.');
  }

  Future<String> getPlatformVersion() {
    throw UnimplementedError('callPlatform() has not been implemented.');
  }

  Future<bool> isAddToApp() {
    throw UnimplementedError('callPlatform() has not been implemented.');
  }

  Future<String> putString(String key, String value) {
    throw UnimplementedError('callPlatform() has not been implemented.');
  }

  Future<String> getString(String key, [defaultValue = ""]) {
    throw UnimplementedError('callPlatform() has not been implemented.');
  }

  Future<String> putLong(String key, String value) {
    throw UnimplementedError('callPlatform() has not been implemented.');
  }

  Future<int> getLong(String key, [defaultValue = 0]) {
    throw UnimplementedError('callPlatform() has not been implemented.');
  }

  Future<String> putFloat(String key, String value) {
    throw UnimplementedError('callPlatform() has not been implemented.');
  }

  Future<double> getFloat(String key, [defaultValue = 0.0]) {
    throw UnimplementedError('callPlatform() has not been implemented.');
  }
}
