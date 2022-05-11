# [flutter_addtoapp_bridge](https://pub.flutter-io.cn/packages/flutter_addtoapp_bridge)

flutter addtoapp bridge for flutter call android/ios.

## Usage(flutter call android/ios)

> [flutter_addtoapp_bridge/versions](https://pub.flutter-io.cn/packages/flutter_addtoapp_bridge/versions)

```yaml
flutter_addtoapp_bridge: ^x.x.x
```

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
import com.codesdancing.flutter.addtoapp.bridge.FlutterAddtoappBridgePlugin;

// write code in application
FlutterAddtoappBridgePlugin.setOnGlobalMethodCall(object : FlutterAddtoappBridgePlugin.OnGlobalMethodCall {
    override fun onCall(activity: Activity?, call: MethodCall, result: MethodChannel.Result) {
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

- Example About [Use FlutterFragment in Activity](https://flutter.cn/docs/development/add-to-app/android/add-flutter-fragment?tab=use-prewarmed-engine-java-tab#add-a-flutterfragment-to-an-activity-with-a-new-flutterengine)

> shouldAttachEngineToActivity(true) // must be true, or flutter plugin activiy is null
>
> the activity contains flutter fragment must special android:theme="@style/AppTheme", or render not completely
>
> flutter fragment shouldn't in viewpager, render not completely, or maybe the problem is not special android:theme in activity

```java
import io.flutter.embedding.android.FlutterFragment;

public class FlutterFragmentExampleActivity extends AppCompatActivity {
    @Nullable
    private FlutterFragment flutterFragment = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.flutter_fragment_example_activity);
        flutterFragment = FlutterFragment.withCachedEngine("my_engine_id")
                .shouldAttachEngineToActivity(true)
                .build();
        this.getSupportFragmentManager().beginTransaction()
                .add(R.id.flutterContainer, flutterFragment, "flutterFragment")
                .commitAllowingStateLoss();

//        new Handler().postDelayed(() -> {
//            this.getSupportFragmentManager().beginTransaction()
//                    .replace(android.R.id.content, new MineFragment(), "MineFragment")
//                    .commitAllowingStateLoss();
//            new Handler().postDelayed(() -> {
//                this.getSupportFragmentManager().beginTransaction()
//                        .add(android.R.id.content, flutterFragment, "flutterFragment")
//                        .commitAllowingStateLoss();
//            }, 3000);
//        }, 3000);
    }

    @Override
    public void onPostResume() {
        super.onPostResume();
        if (flutterFragment != null) flutterFragment.onPostResume();
    }

    @Override
    protected void onNewIntent(@NonNull Intent intent) {
        if (flutterFragment != null) flutterFragment.onNewIntent(intent);
    }

    @Override
    public void onBackPressed() {
        if (flutterFragment != null) flutterFragment.onBackPressed();
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        if (flutterFragment != null) flutterFragment.onRequestPermissionsResult(requestCode, permissions, grantResults);
    }

    @Override
    public void onUserLeaveHint() {
        if (flutterFragment != null) flutterFragment.onUserLeaveHint();
    }

    @Override
    public void onTrimMemory(int level) {
        super.onTrimMemory(level);
        if (flutterFragment != null) flutterFragment.onTrimMemory(level);
    }
}

```

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android" android:layout_width="match_parent" android:layout_height="match_parent" android:orientation="vertical">

    <FrameLayout android:id="@+id/flutterContainer" android:background="@color/yellow" android:layout_width="match_parent" android:layout_height="0dp" android:layout_weight="1" />

    <TextView android:background="@color/orange" android:textSize="30sp" android:gravity="center" android:layout_width="match_parent" android:layout_height="100dp" android:text="bottom bar" />
</LinearLayout>
```

```xml

<activity android:name="xx.FlutterFragmentExampleActivity" android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode" android:exported="true" android:hardwareAccelerated="true" android:launchMode="singleTop" android:theme="@style/AppTheme" android:windowSoftInputMode="adjustResize">
    <!-- This keeps the window background of the activity showing
         until Flutter renders its first frame. It can be removed if
         there is no splash screen (such as the default splash screen
         defined in @style/LaunchTheme). -->
    <meta-data android:name="io.flutter.app.android.SplashScreenUntilFirstFrame" android:value="true" />
    <intent-filter>
        <action android:name="android.intent.action.MAIN" />
        <category android:name="android.intent.category.LAUNCHER" />
    </intent-filter>
</activity>
```