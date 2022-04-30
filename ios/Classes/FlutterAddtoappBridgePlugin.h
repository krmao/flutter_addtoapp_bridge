#import <Flutter/Flutter.h>

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"

typedef void (^OnGlobalMethodCall)(UIViewController *topViewController, FlutterMethodCall *call, FlutterResult result);

@interface FlutterAddtoappBridgePlugin : NSObject <FlutterPlugin>
+ (void)setOnGlobalMethodCall:(OnGlobalMethodCall)onGlobalMethodCall;

+ (UIViewController *)topmostViewController;

+ (void)showToast:(UIViewController *)viewController message:(NSString *)message;
@end

#pragma clang diagnostic pop
