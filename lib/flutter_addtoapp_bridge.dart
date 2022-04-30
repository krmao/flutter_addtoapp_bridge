import 'flutter_addtoapp_bridge_platform_interface.dart';

class FlutterAddtoappBridge {
  Future<dynamic> getPlatformVersion() {
    return callPlatform("getPlatformVersion");
  }

  Future<dynamic> open(String key, [dynamic value]) {
    return callPlatform("open", [key, value]);
  }

  Future<dynamic> callPlatform(String key, [dynamic arguments]) {
    return FlutterAddtoappBridgePlatform.instance.callPlatform(key, arguments);
  }
}
