#import <Flutter/Flutter.h>

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"

typedef void (^OnGlobalMethodCall)(UIViewController *topViewController, FlutterMethodCall *call, FlutterResult result);

@interface FlutterAddtoappBridgePlugin : NSObject <FlutterPlugin>
+ (void)setOnGlobalMethodCall:(OnGlobalMethodCall)onGlobalMethodCall;

+ (UIViewController * _Nullable)topmostViewController;

+ (void)showToast:(UIViewController * _Nullable)viewController message:(NSString *_Nonnull)message;

+ (Boolean)callFlutter:(NSString * _Nonnull)method arguments:(id _Nullable)arguments callback:(FlutterResult _Nullable)callback;
@end

#pragma clang diagnostic pop
