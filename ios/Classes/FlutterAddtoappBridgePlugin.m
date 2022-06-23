#import "FlutterAddtoappBridgePlugin.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

static FlutterMethodChannel *channel = nil;
static OnGlobalMethodCall onGlobalMethodCall = nil;
static OnGlobalMethodCall onDefaultGlobalMethodCall = ^Boolean(UIViewController *_Nullable topViewController, FlutterMethodCall *_Nonnull call, FlutterResult _Nonnull result) {
    NSLog(@"--> onDefaultGlobalMethodCall (oc) topViewController=%@, method=%@, arguments=%@", topViewController, call.method, call.arguments);
    if ([@"callPlatform" isEqualToString:call.method]) {
        NSLog(@"onCall %@", [call.arguments class]);
        NSArray *argumentsWithFunctionNameArray = (NSArray *) call.arguments;
        NSString *functionName = [argumentsWithFunctionNameArray firstObject];
        if ([@"getPlatformVersion" isEqualToString:functionName]) {
            result([[UIDevice currentDevice] systemVersion]);
            return true;
        } else if ([@"isAddToApp" isEqualToString:functionName]) {
            result(onGlobalMethodCall ? @(true) : @(false));
            return true;
        } else if ([@"putString" isEqualToString:functionName]) {
            NSMutableArray *argumentsArray = (NSMutableArray *) argumentsWithFunctionNameArray[1];
            NSString *key = [argumentsArray[0] stringValue];
            NSString *value = [argumentsArray[1] stringValue];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:value forKey:key];
            [defaults synchronize];
            result(@"0");
            return true;
        } else if ([@"getString" isEqualToString:functionName]) {
            NSMutableArray *argumentsArray = (NSMutableArray *) argumentsWithFunctionNameArray[1];
            NSString *key = [argumentsArray[0] stringValue];
            NSString *defaultValue = [argumentsArray[1] stringValue];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *returnValue = [defaults stringForKey:key];
            if (returnValue == nil) {
                returnValue = defaultValue;
            }
            result(returnValue);
            return true;
        } else if ([@"putLong" isEqualToString:functionName]) {
            NSMutableArray *argumentsArray = (NSMutableArray *) argumentsWithFunctionNameArray[1];
            NSString *key = [argumentsArray[0] stringValue];
            NSInteger value = [argumentsArray[1] integerValue];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@(value) forKey:key]; // object can check if contains
            [defaults synchronize];
            result(@"0");
            return true;
        } else if ([@"getLong" isEqualToString:functionName]) {
            NSMutableArray *argumentsArray = (NSMutableArray *) argumentsWithFunctionNameArray[1];
            NSString *key = [argumentsArray[0] stringValue];
            long long defaultValue = [argumentsArray[1] longLongValue];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if ([defaults objectForKey:key] == nil) {
                result(@(defaultValue));
            } else {
                result(@([defaults integerForKey:key]));
            }
            return true;
        } else if ([@"putFloat" isEqualToString:functionName]) {
            NSMutableArray *argumentsArray = (NSMutableArray *) argumentsWithFunctionNameArray[1];
            NSString *key = [argumentsArray[0] stringValue];
            double value = [argumentsArray[1] doubleValue];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@(value) forKey:key]; // object can check if contains
            [defaults synchronize];
            result(@"0");
            return true;
        } else if ([@"getFloat" isEqualToString:functionName]) {
            NSMutableArray *argumentsArray = (NSMutableArray *) argumentsWithFunctionNameArray[1];
            NSString *key = [argumentsArray[0] stringValue];
            double defaultValue = [argumentsArray[1] doubleValue];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if ([defaults objectForKey:key] == nil) {
                result(@(defaultValue));
            } else {
                result(@([defaults integerForKey:key]));
            }
            return true;
        } else {
            result([NSString stringWithFormat:@"-1 %@ is not support", functionName]);
            return false;
        }
    } else {
        result(FlutterMethodNotImplemented);
        return false;
    }
};

@implementation FlutterAddtoappBridgePlugin
+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    channel = [FlutterMethodChannel
            methodChannelWithName:@"flutter_addtoapp_bridge"
                  binaryMessenger:[registrar messenger]];
    FlutterAddtoappBridgePlugin *instance = [[FlutterAddtoappBridgePlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

+ (void)setOnGlobalMethodCall:(OnGlobalMethodCall _Nullable)onCall {
    onGlobalMethodCall = onCall;
}

+ (UIViewController *_Nullable)topmostViewController {
    // NOTE: Adapted from various stray answers here:
    // https://stackoverflow.com/questions/6131205/iphone-how-to-find-topmost-view-controller/20515681
    UIViewController *viewController = nil;
    for (UIWindow *window in UIApplication.sharedApplication.windows.reverseObjectEnumerator.allObjects) {
        if (window.windowLevel == UIWindowLevelNormal) {
            viewController = window.rootViewController;
            break;
        }
    }
    while (viewController != nil) {
        if ([viewController isKindOfClass:[UITabBarController class]]) {
            viewController = ((UITabBarController *) viewController).selectedViewController;
        } else if ([viewController isKindOfClass:[UINavigationController class]]) {
            viewController = ((UINavigationController *) viewController).visibleViewController;
        } else if (viewController.presentedViewController != nil && !viewController.presentedViewController.isBeingDismissed) {
            viewController = viewController.presentedViewController;
        } else if (viewController.childViewControllers.count > 0) {
            viewController = viewController.childViewControllers.lastObject;
        } else {
            BOOL repeat = NO;
            for (UIView *view in viewController.view.subviews.reverseObjectEnumerator.allObjects) {
                if ([view.nextResponder isKindOfClass:[UIViewController class]]) {
                    viewController = (UIViewController *) view.nextResponder;
                    repeat = YES;
                    break;
                }
            }
            if (!repeat) {
                break;
            }
        }
    }
    return viewController;
}

+ (Boolean)callFlutter:(NSString *_Nonnull)method arguments:(id _Nullable)arguments callback:(FlutterResult _Nullable)callback {
    if (channel != nil) {
        [channel invokeMethod:method arguments:arguments result:callback];
        return true;
    } else {
        return false;
    }
}

+ (void)showToast:(UIViewController *_Nullable)viewController message:(NSString *_Nonnull)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIView *firstSubview = alert.view.subviews.firstObject;
    UIView *alertContentView = firstSubview.subviews.firstObject;
    for (UIView *subSubView in alertContentView.subviews) {
        subSubView.backgroundColor = [UIColor colorWithRed:0 / 255.0f green:0 / 255.0f blue:0 / 255.0f alpha:0.73f];
    }
    NSMutableAttributedString *AS = [[NSMutableAttributedString alloc] initWithString:message];
    [AS addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, AS.length)];
    [alert setValue:AS forKey:@"attributedTitle"];
    [viewController presentViewController:alert animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:^{
        }];
    });
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    UIViewController *topmostViewController = [FlutterAddtoappBridgePlugin topmostViewController];
    NSLog(@"handleMethodCall topViewController=%@, method=%@, arguments=%@", topmostViewController, call.method, call.arguments);

    bool isHandled = false;
    if (onGlobalMethodCall != nil) {
        isHandled = onGlobalMethodCall(topmostViewController, call, result);
    }
    if (!isHandled) {
        isHandled = onDefaultGlobalMethodCall(topmostViewController, call, result);
    }
}

@end

#pragma clang diagnostic pop
