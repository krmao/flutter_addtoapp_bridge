#import <Flutter/Flutter.h>

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"

typedef void (^OnGlobalMethodCall)(UIViewController *_Nullable topViewController, FlutterMethodCall *_Nonnull call, FlutterResult _Nonnull result);

@interface FlutterAddtoappBridgePlugin : NSObject <FlutterPlugin>

@property(nonatomic, readonly) FlutterMethodChannel *_Nonnull channel;

- (instancetype _Nullable)init NS_UNAVAILABLE;

+ (void)setOnGlobalMethodCall:(OnGlobalMethodCall _Nullable)onGlobalMethodCall;

+ (UIViewController *_Nullable)topmostViewController;

+ (void)showToast:(UIViewController *_Nullable)viewController message:(NSString *_Nonnull)message;

+ (FlutterAddtoappBridgePlugin *_Nullable)getPlugin:(FlutterEngine *_Nullable)engine;

+ (Boolean)callFlutter:(FlutterEngine *_Nullable)engine method:(NSString *_Nonnull)method arguments:(id _Nullable)arguments callback:(FlutterResult _Nullable)callback;

+ (void)runBlockInMainThread:(dispatch_block_t _Nonnull)block;

+ (void)back:(UIViewController *_Nullable)currentViewController count:(NSInteger)count;

+ (void)openContainer:(UIViewController *_Nullable)viewController entryPoint:(NSString *_Nullable)entryPoint;

+ (void)openContainer:(UIViewController *_Nullable)viewController entryPoint:(NSString *_Nullable)entryPoint registerPlugins:(BOOL)registerPlugins;

+ (void)openContainer:(UIViewController *_Nullable)viewController entryPoint:(NSString *_Nullable)entryPoint initialRoute:(NSString *_Nullable)initialRoute registerPlugins:(BOOL)registerPlugins transparent:(BOOL)transparent;

+ (FlutterEngine *_Nonnull)getEngineWithEntrypoint:(NSString *_Nonnull)entrypoint;

+ (FlutterEngine *_Nonnull)getEngineWithEntrypoint:(NSString *_Nonnull)entrypoint registerPlugins:(BOOL)registerPlugins;

+ (FlutterEngine *_Nonnull)getEngineWithEntrypoint:(NSString *_Nonnull)entrypoint initialRoute:(NSString *_Nonnull)initialRoute;

+ (FlutterEngine *_Nonnull)getEngineWithEntrypoint:(NSString *_Nonnull)entrypoint initialRoute:(NSString *_Nonnull)initialRoute registerPlugins:(BOOL)registerPlugins;

+ (void)registerEnginePlugins:(FlutterEngine * _Nullable)flutterEngine;

+ (FlutterViewController *_Nonnull)getViewControllerWithEntrypoint:(NSString *_Nonnull)entrypoint;

+ (FlutterViewController *_Nonnull)getViewControllerWithEntrypoint:(NSString *_Nonnull)entrypoint registerPlugins:(BOOL)registerPlugins;

+ (FlutterViewController *_Nonnull)getViewControllerWithEntrypoint:(NSString *_Nonnull)entrypoint initialRoute:(NSString *_Nonnull)initialRoute registerPlugins:(BOOL)registerPlugins transparent:(BOOL)transparent;
@end

#pragma clang diagnostic pop
