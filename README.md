# [flutter_addtoapp_bridge](https://pub.flutter-io.cn/packages/flutter_addtoapp_bridge)

flutter addtoapp bridge for flutter call android/ios.

## both android and ios functions
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


## Usage(flutter call android/ios)

> [flutter_addtoapp_bridge/versions](https://pub.flutter-io.cn/packages/flutter_addtoapp_bridge/versions)

- dart

```dart
class _MyAppState extends State<MyApp> {
  final _flutterAddtoappBridgePlugin = FlutterAddtoappBridge();

  Future<void> initPlatformState() async {
    try {
      dynamic result = await _flutterAddtoappBridgePlugin.open("toast", "Hi, I am from flutter!");
      if (kDebugMode) {
        print("putPlatformValue result=$result");
      }
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
  }
}
```

- ios(objectivec)

> pod install

```objectivec
#import <flutter_addtoapp_bridge/FlutterAddtoappBridgePlugin.h>

// write code in application AppDelegate
[FlutterAddtoappBridgePlugin setOnGlobalMethodCall:^(UIViewController *topmostViewController, FlutterMethodCall *call, FlutterResult result) {
  NSLog(@"onCall topViewController=%@, method=%@, arguments=%@", topmostViewController, call.method, call.arguments);
  
  if([@"callPlatform" isEqualToString:call.method]){
      NSLog(@"onCall %@" ,[call.arguments class]);
      NSMutableArray *argumentsWithFunctionNameArray = (NSMutableArray *)call.arguments;
      NSString *functionName = [argumentsWithFunctionNameArray firstObject];
      if([@"getPlatformVersion" isEqualToString:functionName]){
          result([[UIDevice currentDevice] systemVersion]);
      }else if([@"open" isEqualToString:functionName]){
          NSMutableArray *argumentsArray = (NSMutableArray *)[argumentsWithFunctionNameArray objectAtIndex:1];
          NSString *url = [argumentsArray firstObject];
          NSLog(@"onCall open-> url==%@, arguments=%@", url, [argumentsArray objectAtIndex:1]);
          if([@"toast" isEqualToString:url]){
              [FlutterAddtoappBridgePlugin showToast:topmostViewController message:(NSString *)[argumentsArray objectAtIndex:1]];
              result(@"0");
          }else{
               result(FlutterMethodNotImplemented);
          }
      }else{
          result(FlutterMethodNotImplemented);
      }
  }else{
      result(FlutterMethodNotImplemented);
  }
}];
```

- android(kotlin)

```kotlin
import com.codesdancing.flutter.addtoapp.bridge.FlutterAddtoappBridgePlugin;

// write code in application
FlutterAddtoappBridgePlugin.setOnGlobalMethodCall(object : FlutterAddtoappBridgePlugin.OnGlobalMethodCall {
    override fun onCall(activity: Activity?, call: MethodCall, result: MethodChannel.Result) {
        Log.d("onCall", "activity=${activity?.hashCode()}, method=${call.method}, arguments=${call.arguments}")
        if (call.method == "callPlatform") {
            val argumentsWithFunctionNameArray = call.arguments as? ArrayList<*>
            when (val functionName = argumentsWithFunctionNameArray?.first()) {
                "getPlatformVersion" ->{
                    result.success(android.os.Build.VERSION.RELEASE)
                }
                "open" -> {
                    val argumentsArray = argumentsWithFunctionNameArray.getOrNull(1) as? ArrayList<*>
                    Log.d("onCall", "open-> url=${argumentsArray?.getOrNull(0)}, arguments=${argumentsArray?.getOrNull(1) as? String ?: ""}}")
                    when (val url = argumentsArray?.getOrNull(0)) {
                        "toast" -> {
                            FlutterAddtoappBridgePlugin.showToast(activity, argumentsArray.getOrNull(1) as? String ?: "")
                            result.success("0")
                        }
                        else -> {
                            result.notImplemented()
                        }
                    }
                }
                else ->{
                    result.notImplemented()
                }
            }
        } else {
            result.notImplemented()
        }
    }
})
```