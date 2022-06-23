#import <Flutter/Flutter.h>

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"

typedef Boolean (^OnGlobalMethodCall)(UIViewController *_Nullable topViewController, FlutterMethodCall * _Nonnull call, FlutterResult _Nonnull result);

@interface FlutterAddtoappBridgePlugin : NSObject <FlutterPlugin>
+ (void)setOnGlobalMethodCall:(OnGlobalMethodCall _Nullable)onGlobalMethodCall;

+ (UIViewController * _Nullable)topmostViewController;

+ (void)showToast:(UIViewController * _Nullable)viewController message:(NSString *_Nonnull)message;

+ (Boolean)callFlutter:(NSString * _Nonnull)method arguments:(id _Nullable)arguments callback:(FlutterResult _Nullable)callback;
@end

#pragma clang diagnostic pop
