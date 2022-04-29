
import 'flutter_addtoapp_bridge_platform_interface.dart';

class FlutterAddtoappBridge {
  Future<String?> getPlatformVersion() {
    return FlutterAddtoappBridgePlatform.instance.getPlatformVersion();
  }
}
