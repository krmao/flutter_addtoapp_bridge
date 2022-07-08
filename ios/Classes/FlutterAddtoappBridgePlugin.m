#import "FlutterAddtoappBridgePlugin.h"
#import "FlutterAddtoappBridgePluginToast.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma ide diagnostic ignored "OCUnusedMethodInspection"
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

static FlutterEngineGroup *flutterEngineGroup = nil;
static OnGlobalMethodCall onGlobalMethodCall = nil;
static OnGlobalMethodCall onDefaultGlobalMethodCall = ^(UIViewController *_Nullable topViewController, FlutterMethodCall *_Nonnull call, FlutterResult _Nonnull result) {
    NSLog(@"[FlutterAddtoappBridgePlugin] onDefaultGlobalMethodCall (ios) topViewController=%@, method=%@, arguments=%@", topViewController, call.method, call.arguments);
    if ([@"callPlatform" isEqualToString:call.method]) {
        NSMutableArray *argumentsWithFunctionNameArray = (NSMutableArray *) call.arguments;
        NSString *functionName = [argumentsWithFunctionNameArray firstObject];
        if ([@"getPlatformVersion" isEqualToString:functionName]) {
            result([[UIDevice currentDevice] systemVersion]);
        } else if ([@"isAddToApp" isEqualToString:functionName]) {
            result(onGlobalMethodCall ? @(YES) : @(NO));
        } else if ([@"putString" isEqualToString:functionName]) {
            NSMutableArray *argumentsArray = (NSMutableArray *) argumentsWithFunctionNameArray[1];
            NSString *key = argumentsArray[0];
            NSString *value = argumentsArray[1];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:value forKey:key];
            [defaults synchronize];
            result(@"0");
        } else if ([@"getString" isEqualToString:functionName]) {
            NSMutableArray *argumentsArray = (NSMutableArray *) argumentsWithFunctionNameArray[1];
            NSString *key = argumentsArray[0];
            NSString *defaultValue = argumentsArray[1];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *returnValue = [defaults stringForKey:key];
            if (returnValue == nil) {
                returnValue = defaultValue;
            }
            result(returnValue);
        } else if ([@"putLong" isEqualToString:functionName]) {
            NSMutableArray *argumentsArray = (NSMutableArray *) argumentsWithFunctionNameArray[1];
            NSString *key = argumentsArray[0];
            NSInteger value = [argumentsArray[1] integerValue];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@(value) forKey:key]; // object can check if contains
            [defaults synchronize];
            result(@"0");
        } else if ([@"getLong" isEqualToString:functionName]) {
            NSMutableArray *argumentsArray = (NSMutableArray *) argumentsWithFunctionNameArray[1];
            NSString *key = argumentsArray[0];
            long long defaultValue = [argumentsArray[1] longLongValue];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if ([defaults objectForKey:key] == nil) {
                result(@(defaultValue));
            } else {
                result(@([defaults integerForKey:key]));
            }
        } else if ([@"putFloat" isEqualToString:functionName]) {
            NSMutableArray *argumentsArray = (NSMutableArray *) argumentsWithFunctionNameArray[1];
            NSString *key = argumentsArray[0];
            double value = [argumentsArray[1] doubleValue];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@(value) forKey:key]; // object can check if contains
            [defaults synchronize];
            result(@"0");
        } else if ([@"getFloat" isEqualToString:functionName]) {
            NSMutableArray *argumentsArray = (NSMutableArray *) argumentsWithFunctionNameArray[1];
            NSString *key = argumentsArray[0];
            double defaultValue = [argumentsArray[1] doubleValue];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if ([defaults objectForKey:key] == nil) {
                result(@(defaultValue));
            } else {
                result(@([defaults doubleForKey:key]));
            }
        } else if ([@"exitApp" isEqualToString:functionName]) {
            exit(0);
        } else if ([@"back" isEqualToString:functionName]) {
            NSMutableArray *argumentsArray = (NSMutableArray *) argumentsWithFunctionNameArray[1];
            [FlutterAddtoappBridgePlugin back:topViewController count:[argumentsArray[0] intValue]];
            result(@(YES));
        } else if ([@"showToast" isEqualToString:functionName]) {
            NSMutableArray *argumentsArray = (NSMutableArray *) argumentsWithFunctionNameArray[1];
            NSString *message = argumentsArray[0];
            [FlutterAddtoappBridgePlugin showToast:message];
            result(@(YES));
        } else if ([@"openContainer" isEqualToString:functionName]) {
            NSMutableArray *argumentsArray = (NSMutableArray *) argumentsWithFunctionNameArray[1];
            NSString *entrypoint = argumentsArray[0];
            NSDictionary *argumentsMap = (NSDictionary *) argumentsArray[1];
            NSString *initialRoute = (NSString *) [argumentsMap valueForKey:@"initialRoute"];
            // BOOL destroyEngine = [[argumentsMap valueForKey:@"destroyEngine"] boolValue];
            BOOL transparent = [[argumentsMap valueForKey:@"transparent"] boolValue];
            [FlutterAddtoappBridgePlugin openContainer:topViewController entryPoint:entrypoint initialRoute:initialRoute registerPlugins:true transparent:transparent];
            result(@(YES));
        } else {
            result(FlutterMethodNotImplemented);
        }
    } else {
        result(FlutterMethodNotImplemented);
    }
};

@implementation FlutterAddtoappBridgePlugin

- (instancetype)initWithChannel:(FlutterMethodChannel *_Nonnull)channel {
    NSLog(@"[FlutterAddtoappBridgePlugin] initWithChannel");
    if (self = [super init]) {
        _channel = channel;
    }
    return self;
}

+ (void)runBlockInMainThread:(dispatch_block_t _Nonnull)block {
    NSLog(@"[FlutterAddtoappBridgePlugin] runBlockInMainThread");
    if (block == nil) {
        return;
    }
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

+ (void)back:(UIViewController *_Nullable)currentViewController count:(NSInteger)count {
    NSLog(@"[FlutterAddtoappBridgePlugin] back start currentViewController=%@ count=%ld", currentViewController, count);
    if (!currentViewController || (count <= 0 && count != -1)) {
        return;
    }
    BOOL animated = YES;
    [FlutterAddtoappBridgePlugin runBlockInMainThread:^{
        NSUInteger finalCount = (NSUInteger) count;
        UINavigationController *navigationController = currentViewController.navigationController;
        if (navigationController) {
            if (count == -1) {
                NSLog(@"back popToRootViewControllerAnimated viewController=%@ navigationController=%@",currentViewController,navigationController);
                [navigationController popToRootViewControllerAnimated:animated];
            } else {
                NSUInteger allCount = navigationController.viewControllers.count;
                if (allCount == 1) {
                    if(navigationController.presentingViewController != nil){
                        NSLog(@"back isBeingPresented=true dismissViewControllerAnimated viewController=%@ navigationController=%@",currentViewController,navigationController);
                        
                        // [navigationController dismissViewControllerAnimated:YES completion:nil]; // not work
                        [currentViewController dismissViewControllerAnimated:YES completion:nil];
                    }else{
                        NSLog(@"back exit currentViewController=%@",currentViewController);
                        exit(0);
                    }
                } else {
                    if (finalCount > allCount) {
                        finalCount = 1;
                    }
                    NSLog(@"back popToViewController currentViewController=%@",currentViewController);
                    UIViewController *toVC = navigationController.viewControllers[(allCount - finalCount - 1)];
                    [navigationController popToViewController:toVC animated:animated];
                }
            }
        } else {
            UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
            if (rootViewController == currentViewController) {
                NSLog(@"back rootViewController != currentViewController exit currentViewController=%@",currentViewController);
                exit(0);
            } else {
                if (count == -1) {
                    NSLog(@"back rootViewController != currentViewController count == -1 currentViewController=%@",currentViewController);
                    if (rootViewController.navigationController) {
                        [rootViewController.navigationController popToRootViewControllerAnimated:true];
                    } else {
                        [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:true completion:nil];
                    };
                } else {
                    NSLog(@"back rootViewController != currentViewController count != -1 currentViewController=%@",currentViewController);
                    NSLog(@"back rootViewController != currentViewController count != -1 if UIAlertController check is call showToast");
                    
                    if ([currentViewController isKindOfClass:[UIAlertController class]]){
                        NSInteger tag = currentViewController.view.tag;
                        NSLog(@"back rootViewController != currentViewController count != -1 if UIAlertController check is call showToast tag=%ld",tag);
                        UIAlertController *alertController = ((UIAlertController *) currentViewController);
                        UIViewController *presentingViewController=alertController.presentingViewController;
        
                        if([presentingViewController isKindOfClass:[UINavigationController class]]){
                            UIViewController *lastViewController = ((UINavigationController *)presentingViewController).viewControllers.lastObject;
                            NSLog(@"back UIAlertController UINavigationController lastViewController=%@",lastViewController);
                            [FlutterAddtoappBridgePlugin back:lastViewController count:count];
                        }else{
                            NSLog(@"back UIAlertController UIViewController presentingViewController=%@", presentingViewController);
                            [FlutterAddtoappBridgePlugin back:presentingViewController count:count];
                        }
                        return;
                    }
                    [currentViewController dismissViewControllerAnimated:YES completion:nil];
                }
            }
        }
    }];
}

+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    if(flutterEngineGroup==nil){
        flutterEngineGroup = [[FlutterEngineGroup alloc] initWithName:@"" project:nil];
    }
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"flutter_addtoapp_bridge" binaryMessenger:[registrar messenger]];
    FlutterAddtoappBridgePlugin *bridgePlugin = [[FlutterAddtoappBridgePlugin alloc] initWithChannel:channel];
    [registrar addMethodCallDelegate:bridgePlugin channel:channel];
    [registrar publish:bridgePlugin];
    
    NSLog(@"[FlutterAddtoappBridgePlugin] registerWithRegistrar bridgePlugin=%@ plugin.channel=%@ registrar=%@",bridgePlugin,channel,registrar);
}

+ (void)setOnGlobalMethodCall:(OnGlobalMethodCall _Nullable)onCall {
    NSLog(@"[FlutterAddtoappBridgePlugin] setOnGlobalMethodCall");
    onGlobalMethodCall = onCall;
    
    
    if(flutterEngineGroup==nil) flutterEngineGroup = [[FlutterEngineGroup alloc] initWithName:@"" project:nil];
}

+ (UIViewController *_Nullable)topmostViewController {
    NSLog(@"[FlutterAddtoappBridgePlugin] topmostViewController start");
    // NOTE: Adapted from various stray answers here:
    // https://stackoverflow.com/questions/6131205/iphone-how-to-find-topmost-view-controller/20515681
    UIViewController *viewController = nil;
    for (UIWindow *window in UIApplication.sharedApplication.windows.reverseObjectEnumerator.allObjects) {
        if (window.windowLevel == UIWindowLevelNormal) {
            viewController = window.rootViewController;
            break;
        }
    }
    NSLog(@"[FlutterAddtoappBridgePlugin] topmostViewController viewController=%@",viewController);
    while (viewController != nil) {
        if ([viewController isKindOfClass:[UITabBarController class]]) {
            viewController = ((UITabBarController *) viewController).selectedViewController;
            NSLog(@"[FlutterAddtoappBridgePlugin] topmostViewController UITabBarController viewController=%@",viewController);
        } else if ([viewController isKindOfClass:[UINavigationController class]]) {
            viewController = ((UINavigationController *) viewController).visibleViewController;
        } else if ([viewController isKindOfClass:[UIAlertController class]]){
            UIAlertController *alertController = ((UIAlertController *) viewController);
            UIViewController *presentingViewController=alertController.presentingViewController;
            if([presentingViewController isKindOfClass:[UINavigationController class]]){
                viewController = ((UINavigationController *)presentingViewController).viewControllers.lastObject;
                NSLog(@"[FlutterAddtoappBridgePlugin] topmostViewController UIAlertController UINavigationController viewController=%@",viewController);
            }else{
                viewController =presentingViewController;
                NSLog(@"[FlutterAddtoappBridgePlugin] topmostViewController UIAlertController viewController=%@",viewController);
            }
        } else if (viewController.presentedViewController != nil && !viewController.presentedViewController.isBeingDismissed && ![viewController.presentedViewController isKindOfClass:[UIAlertController class]]) {
            viewController = viewController.presentedViewController;
            NSLog(@"[FlutterAddtoappBridgePlugin] topmostViewController presentedViewController viewController=%@",viewController);
        } else if (viewController.childViewControllers.count > 0) {
            viewController = viewController.childViewControllers.lastObject;
            NSLog(@"[FlutterAddtoappBridgePlugin] topmostViewController childViewControllers viewController=%@",viewController);
        } else {
            BOOL repeat = NO;
            for (UIView *view in viewController.view.subviews.reverseObjectEnumerator.allObjects) {
                if ([view.nextResponder isKindOfClass:[UIViewController class]]) {
                    viewController = (UIViewController *) view.nextResponder;
                    repeat = YES;
                    NSLog(@"[FlutterAddtoappBridgePlugin] topmostViewController repeat=YES");
                    break;
                }
            }
            if (!repeat) {
                NSLog(@"[FlutterAddtoappBridgePlugin] topmostViewController repeat=NO break");
                break;
            }
        }
    }
    NSLog(@"[FlutterAddtoappBridgePlugin] topmostViewController end viewController=%@",viewController);
    return viewController;
}

+ (FlutterAddtoappBridgePlugin *_Nullable)getPlugin:(FlutterEngine *_Nullable)engine {
    NSLog(@"[FlutterAddtoappBridgePlugin] getPlugin");
    if (engine != nil) {
        BOOL hasPlugin = [engine hasPlugin:@"FlutterAddtoappBridgePlugin"];
        NSObject *published = [engine valuePublishedByPlugin:@"FlutterAddtoappBridgePlugin"];
        NSLog(@"[FlutterAddtoappBridgePlugin] getPlugin hasPlugin=%d, engine=%@, published=%@", hasPlugin, engine, published);
        if ([published isKindOfClass:[FlutterAddtoappBridgePlugin class]]) {
            FlutterAddtoappBridgePlugin *plugin = (FlutterAddtoappBridgePlugin *) published;
            NSLog(@"[FlutterAddtoappBridgePlugin] getPlugin return plugin=%@", plugin);
            return plugin;
        }
        NSLog(@"[FlutterAddtoappBridgePlugin] getPlugin return plugin nil !");
    }
    return nil;
}

+ (Boolean)callFlutter:(FlutterEngine *_Nullable)engine method:(NSString *_Nonnull)method arguments:(id _Nullable)arguments callback:(FlutterResult _Nullable)callback {
    FlutterAddtoappBridgePlugin *plugin = [FlutterAddtoappBridgePlugin getPlugin:engine];
    NSLog(@"[FlutterAddtoappBridgePlugin] callFlutter plugin=%@",plugin);
    
    if (plugin != nil && plugin.channel != nil) {
        NSLog(@"[FlutterAddtoappBridgePlugin] callFlutter invokeMethod plugin.channel=%@ method=%@ arguments=%@ callback=%@",plugin.channel,method,arguments,callback);
        [plugin.channel invokeMethod:method arguments:arguments result:callback];
        return true;
    } else {
        return false;
    }
}

+ (void)showToast:(NSString *_Nullable)message {
    if(message == nil || message.length <=0){
        NSLog(@"[FlutterAddtoappBridgePlugin] showToast return; message is empty! message=%@",message);
        return;
    }
    NSLog(@"[FlutterAddtoappBridgePlugin] showToast message=%@",message);
    [FlutterAddtoappBridgePluginToast setToastIndicatorStyle:UIBlurEffectStyleDark];
    [FlutterAddtoappBridgePluginToast showToastMessage:message];
}

+ (void)openContainer:(UIViewController *_Nullable)viewController entryPoint:(NSString *_Nullable)entryPoint{
    [FlutterAddtoappBridgePlugin openContainer:viewController entryPoint:entryPoint initialRoute:@"/" registerPlugins:true transparent:false];
}

+ (void)openContainer:(UIViewController *_Nullable)viewController entryPoint:(NSString *_Nullable)entryPoint registerPlugins:(BOOL)registerPlugins{
    [FlutterAddtoappBridgePlugin openContainer:viewController entryPoint:entryPoint initialRoute:@"/" registerPlugins:registerPlugins transparent:false];
}

+ (void)openContainer:(UIViewController *_Nullable)viewController entryPoint:(NSString *_Nullable)entryPoint initialRoute:(NSString *_Nullable)initialRoute registerPlugins:(BOOL)registerPlugins transparent:(BOOL)transparent {
    NSLog(@"[FlutterAddtoappBridgePlugin] openContainer");
    if (viewController) {
        FlutterViewController *flutterViewController = [FlutterAddtoappBridgePlugin getViewControllerWithEntrypoint:entryPoint initialRoute:initialRoute registerPlugins:registerPlugins transparent:transparent];
        if (viewController.navigationController && !transparent) {
            [viewController.navigationController pushViewController:flutterViewController animated:true];
        } else {
            [viewController presentViewController:flutterViewController animated:true completion:nil];
        }
    }
}

+ (FlutterEngine *_Nonnull)getEngineWithEntrypoint:(NSString *_Nonnull)entrypoint {
    return [FlutterAddtoappBridgePlugin getEngineWithEntrypoint:entrypoint initialRoute:@"/" registerPlugins:true];
}

+ (FlutterEngine *_Nonnull)getEngineWithEntrypoint:(NSString *_Nonnull)entrypoint registerPlugins:(BOOL)registerPlugins{
    return [FlutterAddtoappBridgePlugin getEngineWithEntrypoint:entrypoint initialRoute:@"/" registerPlugins:registerPlugins];
}

+ (FlutterEngine *_Nonnull)getEngineWithEntrypoint:(NSString *_Nonnull)entrypoint initialRoute:(NSString *_Nonnull)initialRoute {
    return [FlutterAddtoappBridgePlugin getEngineWithEntrypoint:entrypoint initialRoute:initialRoute registerPlugins:true];
}

+ (FlutterEngine *_Nonnull)getEngineWithEntrypoint:(NSString *_Nonnull)entrypoint initialRoute:(NSString *_Nonnull)initialRoute registerPlugins:(BOOL)registerPlugins {
    
    if(flutterEngineGroup==nil) flutterEngineGroup = [[FlutterEngineGroup alloc] initWithName:@"" project:nil];
    NSCAssert(flutterEngineGroup != nil, @"flutterEngineGroup must not be nil");
       
    FlutterEngine *flutterEngine = [flutterEngineGroup makeEngineWithEntrypoint:entrypoint libraryURI:nil initialRoute:initialRoute];
    NSCAssert(flutterEngine != nil, @"flutterEngine must not be nil");
       
    NSLog(@"[FlutterAddtoappBridgePlugin] getEngineWithEntrypoint start flutterEngine=%@", flutterEngine);
    
    if(registerPlugins){
        [FlutterAddtoappBridgePlugin registerEnginePlugins:flutterEngine];
    }
    NSLog(@"[FlutterAddtoappBridgePlugin] getEngineWithEntrypoint end");
    return flutterEngine;
}

+ (void)registerEnginePlugins:(FlutterEngine * _Nullable)flutterEngine{
    NSLog(@"[FlutterAddtoappBridgePlugin] registerEnginePlugins start");
    if(flutterEngine != nil){
        Class clazz = NSClassFromString(@"GeneratedPluginRegistrant");
        if (clazz && [clazz respondsToSelector:NSSelectorFromString(@"registerWithRegistry:")]) {
            [clazz performSelector:NSSelectorFromString(@"registerWithRegistry:") withObject:flutterEngine];
            NSLog(@"[FlutterAddtoappBridgePlugin] registerEnginePlugins success clazz=%@", clazz);
        }else{
            NSLog(@"[FlutterAddtoappBridgePlugin] registerEnginePlugins failure clazz=%@", clazz);
        }
    }
    NSLog(@"[FlutterAddtoappBridgePlugin] registerEnginePlugins end");
}

+ (FlutterViewController *_Nonnull)getViewControllerWithEntrypoint:(NSString *_Nonnull)entrypoint{
    return [FlutterAddtoappBridgePlugin getViewControllerWithEntrypoint:entrypoint initialRoute:@"/" registerPlugins:true transparent:false];
}

+ (FlutterViewController *_Nonnull)getViewControllerWithEntrypoint:(NSString *_Nonnull)entrypoint registerPlugins:(BOOL)registerPlugins{
   return [FlutterAddtoappBridgePlugin getViewControllerWithEntrypoint:entrypoint initialRoute:@"/" registerPlugins:registerPlugins transparent:false];
}

+ (FlutterViewController *_Nonnull)getViewControllerWithEntrypoint:(NSString *_Nonnull)entrypoint initialRoute:(NSString *_Nonnull)initialRoute registerPlugins:(BOOL)registerPlugins transparent:(BOOL)transparent {
    
    if(flutterEngineGroup==nil) flutterEngineGroup = [[FlutterEngineGroup alloc] initWithName:@"" project:nil];
    NSCAssert(flutterEngineGroup != nil, @"flutterEngineGroup must not be nil");
       
    NSLog(@"[FlutterAddtoappBridgePlugin] getViewControllerWithEntrypoint start");
    
    FlutterEngine *flutterEngine = [FlutterAddtoappBridgePlugin getEngineWithEntrypoint:entrypoint initialRoute:initialRoute registerPlugins:registerPlugins];
    NSCAssert(flutterEngine != nil, @"flutterEngine must not be nil");

    FlutterViewController *flutterViewController = [[FlutterViewController alloc] initWithEngine:flutterEngine nibName:nil bundle:nil];
    
    if (transparent) {
        NSLog(@"[FlutterAddtoappBridgePlugin] getViewControllerWithEntrypoint transparent start");
        flutterViewController.definesPresentationContext = YES;
        flutterViewController.view.backgroundColor = [UIColor clearColor];
        flutterViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [flutterViewController setViewOpaque:false];
        NSLog(@"[FlutterAddtoappBridgePlugin] getViewControllerWithEntrypoint transparent end");
    }
    
    NSLog(@"[FlutterAddtoappBridgePlugin] getViewControllerWithEntrypoint end flutterEngine=%@， flutterViewController=%@",flutterEngine, flutterViewController);
    return flutterViewController;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    UIViewController *topmostViewController = [FlutterAddtoappBridgePlugin topmostViewController];
    NSLog(@"[FlutterAddtoappBridgePlugin] handleMethodCall [ios] topViewController=%@, method=%@, arguments=%@", topmostViewController, call.method, call.arguments);

    if (onGlobalMethodCall != nil) {
        onGlobalMethodCall(topmostViewController, call, ^(id _Nullable _result) {
            if (FlutterMethodNotImplemented == _result) {
                onDefaultGlobalMethodCall(topmostViewController, call, result);
            } else {
                result(_result);
            }
        });
    } else {
        onDefaultGlobalMethodCall(topmostViewController, call, result);
    }
}

@end

#pragma clang diagnostic pop
