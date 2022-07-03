#import <Flutter/Flutter.h>

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"

typedef void (^OnGlobalMethodCall)(UIViewController *_Nullable topViewController, FlutterMethodCall *_Nonnull call, FlutterResult _Nonnull result);

@interface FlutterAddtoappBridgePlugin : NSObject <FlutterPlugin>
+ (void)setOnGlobalMethodCall:(OnGlobalMethodCall _Nullable)onGlobalMethodCall;

+ (UIViewController *_Nullable)topmostViewController;

+ (void)showToast:(UIViewController *_Nullable)viewController message:(NSString *_Nonnull)message;

+ (Boolean)callFlutter:(NSString *_Nonnull)method arguments:(id _Nullable)arguments callback:(FlutterResult _Nullable)callback;

+ (void)runBlockInMainThread:(dispatch_block_t _Nonnull)block;

+ (void)back:(UIViewController * _Nullable)currentViewController count:(NSInteger)count;
+ (void)openContainer:(UIViewController *_Nullable)viewController entryPoint:(NSString *_Nullable)entryPoint initialRoute:(NSString *_Nullable)initialRoute destroyEngine:(Boolean)destroyEngine transparent:(Boolean)transparent;
+ (FlutterViewController *_Nullable)getViewControllerWithEntrypoint:(NSString *_Nullable)entryPoint initialRoute:(NSString *_Nullable)initialRoute destroyEngine:(Boolean)destroyEngine transparent:(Boolean)transparent;
@end

#pragma clang diagnostic pop
