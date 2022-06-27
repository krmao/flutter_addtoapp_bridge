import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_addtoapp_bridge_method_channel.dart';

abstract class FlutterAddtoappBridgePlatform extends PlatformInterface {
  FlutterAddtoappBridgePlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterAddtoappBridgePlatform _instance = MethodChannelFlutterAddtoappBridge();

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

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('getPlatformVersion() has not been implemented.');
  }

  Future<bool> isAddToApp() {
    throw UnimplementedError('isAddToApp() has not been implemented.');
  }

  Future<bool> exitApp() {
    throw UnimplementedError('exitApp() has not been implemented.');
  }

  Future<String?> putString(String key, String value) {
    throw UnimplementedError('putString() has not been implemented.');
  }

  Future<String?> getString(String key, {defaultValue = ""}) {
    throw UnimplementedError('getString() has not been implemented.');
  }

  Future<String?> putLong(String key, int value) {
    throw UnimplementedError('putLong() has not been implemented.');
  }

  Future<int?> getLong(String key, {defaultValue = 0}) {
    throw UnimplementedError('getLong() has not been implemented.');
  }

  Future<String?> putFloat(String key, double value) {
    throw UnimplementedError('putFloat() has not been implemented.');
  }

  Future<double?> getFloat(String key, {defaultValue = 0.0}) {
    throw UnimplementedError('getFloat() has not been implemented.');
  }
}
