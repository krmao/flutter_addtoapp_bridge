# [flutter_addtoapp_bridge](https://pub.flutter-io.cn/packages/flutter_addtoapp_bridge)

flutter addtoapp bridge and support multi flutter engines.

## features

### dart

* getPlatformVersion
* isAddToApp -> check env is default or addtoapp
* putString
* getString
* putLong
* getLong
* putFloat
* getFloat
* showToast
* exitApp
* back -1 to home, if count==1 and all page size == 1, will exit app
* open
* callPlatform -> return null if MissingPluginException
* setMethodCallHandler

### android

* setOnGlobalMethodCall
* back
* exitApp
* callFlutter
* showToast
* openContainer
* getPlugin
* getIntentWithEntrypoint
* getFragmentWithEntrypoint
* getEngineWithEntrypoint

### ios

* setOnGlobalMethodCall
* topmostViewController
* showToast
* getPlugin
* callFlutter
* runBlockInMainThread
* back
* exitApp
* openContainer
* getEngineWithEntrypoint
* registerEnginePlugins
* getViewControllerWithEntrypoint

## usage

- dart

```dart
Future<dynamic> methodCallHandler(MethodCall methodCall) async {}

void main() async {
  FlutterAddtoappBridge.setMethodCallHandler(methodCallHandler);
  FlutterAddtoappBridge.showToast("hello world!");
}
```

- ios(objectivec)

```objectivec
#import <flutter_addtoapp_bridge/FlutterAddtoappBridgePlugin.h>

@implementation AppDelegate

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions {

    [FlutterAddtoappBridgePlugin setOnGlobalMethodCall:^(UIViewController *topmostViewController, FlutterMethodCall *call, FlutterResult result) {}];
    
    // pre warm engine about 'home' page
    FlutterViewController *homeFlutterViewController =  [FlutterAddtoappBridgePlugin getViewControllerWithEntrypoint:@"home" registerPlugins:true];
    
}

@end
```

- android(kotlin)

```kotlin
import com.codesdancing.flutter.addtoapp.bridge.FlutterAddtoappBridgePlugin;

class FinalApplication : Application() {

    override fun onCreate() {
        super.onCreate()

        FlutterAddtoappBridgePlugin.setOnGlobalMethodCall(this, object : FlutterAddtoappBridgePlugin.OnGlobalMethodCall {
            override fun onCall(activity: Activity?, call: MethodCall, result: MethodChannel.Result) {
            }
        })

        // pre warm engine about 'home' page
        FlutterAddtoappBridgePlugin.getEngineWithEntrypoint(this, "home")

    }

}

```