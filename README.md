# flutter_addtoapp_bridge

communications between flutter and native

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/), a specialized package that includes platform-specific implementation code for Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://flutter.dev/docs), which offers tutorials, samples, guidance on mobile development, and a full API reference.

## [Create Flutter Plugin Project](https://docs.flutter.dev/development/packages-and-plugins/developing-packages#step-1-create-the-package-1)

```
flutter create --org com.codesdancing.flutter.addtoapp.bridge --template=plugin --platforms=android,ios -a kotlin -i objc flutter_addtoapp_bridge=
```

## Open example/android or example/ios

> build example flutter before open example/ios, don't just open flutter_addtoapp_bridge/android or flutter_addtoapp_bridge/ios.

```
cd example
flutter build ios --no-codesign -v
```

## Waiting for another flutter command to release the startup lock..

```
killall -9 dart
```

## Flutter doc
```shell
~/fvm/versions/2.13.0-0.3.pre/bin/cache/dart-sdk/bin/resources/dartdoc
```
## Publish
```shell
flutter pub publish --dry-run
flutter pub publish
```

## Usage(flutter call android/ios)
- dart
```
try {
  dynamic result = await _flutterAddtoappBridgePlugin.open("toast", "Hi, I am from flutter!");
  if (kDebugMode) {
    print("putPlatformValue result=$result");
  }
} on PlatformException {
  platformVersion = 'Failed to get platform version.';
}
```

- ios(objectivec)
```objectivec
[FlutterAddtoappBridgePlugin setOnGlobalMethodCall:^(UIViewController *topmostViewController, FlutterMethodCall *call, FlutterResult result) {
  NSLog(@"onCall topViewController=%@, method=%@, arguments=%@", topmostViewController, call.method, call.arguments);
  
  if([@"callPlatform" isEqualToString:call.method]){
      NSLog(@"onCall %@" ,[call.arguments class]);
      NSArray *argumentsWithFunctionNameArray = (NSArray *)call.arguments;
      NSString *functionName = [argumentsWithFunctionNameArray firstObject];
      if([@"getPlatformVersion" isEqualToString:functionName]){
          result([[UIDevice currentDevice] systemVersion]);
      }else if([@"open" isEqualToString:functionName]){
          NSArray *argumentsArray = (NSArray *)[argumentsWithFunctionNameArray objectAtIndex:1];
          NSString *url = [argumentsArray firstObject];
          NSLog(@"onCall open-> url==%@, arguments=%@", url, [argumentsArray objectAtIndex:1]);
          if([@"toast" isEqualToString:url]){
              [FlutterAddtoappBridgePlugin showToast:topmostViewController message:(NSString *)[argumentsArray objectAtIndex:1]];
              result(@"0");
          }else{
              result([NSString stringWithFormat:@"-2 %@ is not support", url]);
          }
      }else{
          result([NSString stringWithFormat:@"-1 %@ is not support", functionName]);
      }
      NSLog(@"onCall %lu" ,(unsigned long)[argumentsWithFunctionNameArray count]);
  }else{
      result(FlutterMethodNotImplemented);
  }
}];
```

- android(kotlin)
```kotlin
FlutterAddtoappBridgePlugin.setOnGlobalMethodCall(object : FlutterAddtoappBridgePlugin.OnGlobalMethodCall {
    override fun onCall(activity: Activity?, call: MethodCall, result: MethodChannel.Result ) {
        Log.d("onCall", "activity=${activity?.hashCode()}, method=${call.method}, arguments=${call.arguments}")
        if (call.method == "callPlatform") {
            val argumentsWithFunctionNameArray = call.arguments as? ArrayList<*>
            when (val functionName = argumentsWithFunctionNameArray?.first()) {
                "getPlatformVersion" -> result.success(android.os.Build.VERSION.RELEASE)
                "open" -> {
                    val argumentsArray = argumentsWithFunctionNameArray.getOrNull(1) as? ArrayList<*>
                    Log.d("onCall", "open-> url=${argumentsArray?.getOrNull(0)}, arguments=${argumentsArray?.getOrNull(1) as? String ?: ""}}")
                    when (val url = argumentsArray?.getOrNull(0)) {
                        "toast" -> {
                            FlutterAddtoappBridgePlugin.showToast(activity, argumentsArray.getOrNull(1) as? String ?: "")
                            result.success("0")
                        }
                        else -> {
                            result.error("-2", "$url is not support", null)
                        }
                    }
                }
                else -> result.error("-1", "$functionName is not support", null)
            }
        } else {
            result.notImplemented()
        }
    }
})
```