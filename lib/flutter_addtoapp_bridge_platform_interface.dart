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
}
