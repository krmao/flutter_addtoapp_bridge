import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_addtoapp_bridge_platform_interface.dart';

/// An implementation of [FlutterAddtoappBridgePlatform] that uses method channels.
class MethodChannelFlutterAddtoappBridge extends FlutterAddtoappBridgePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_addtoapp_bridge');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
