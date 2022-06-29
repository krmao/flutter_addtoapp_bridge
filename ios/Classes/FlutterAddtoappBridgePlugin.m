#import "FlutterAddtoappBridgePlugin.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

static FlutterMethodChannel *channel = nil;
static OnGlobalMethodCall onGlobalMethodCall = nil;
static OnGlobalMethodCall onDefaultGlobalMethodCall = ^(UIViewController *_Nullable topViewController, FlutterMethodCall *_Nonnull call, FlutterResult _Nonnull result) {
    NSLog(@"--> onDefaultGlobalMethodCall (oc) topViewController=%@, method=%@, arguments=%@", topViewController, call.method, call.arguments);
    if ([@"callPlatform" isEqualToString:call.method]) {
        NSLog(@"onCall %@", [call.arguments class]);
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
            result(@(YES));
        } else if ([@"back" isEqualToString:functionName]) {
            NSMutableArray *argumentsArray = (NSMutableArray *) argumentsWithFunctionNameArray[1];
            int count = [argumentsArray[0] intValue];
            [FlutterAddtoappBridgePlugin back:topViewController count:count];
            result(@(YES));
        } else if ([@"showToast" isEqualToString:functionName]) {
            NSMutableArray *argumentsArray = (NSMutableArray *) argumentsWithFunctionNameArray[1];
            NSString *message = argumentsArray[0];
            [FlutterAddtoappBridgePlugin showToast:topViewController message:message];
            result(@(YES));
        } else {
            result(FlutterMethodNotImplemented);
        }
    } else {
        result(FlutterMethodNotImplemented);
    }
};

@implementation FlutterAddtoappBridgePlugin

+ (void)runBlockInMainThread:(dispatch_block_t _Nonnull)block {
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
    NSLog(@"--> back currentViewController=%@ count=%ld", currentViewController, count);
    if (!currentViewController || (count <= 0 && count != -1)) {
        return;
    }
    BOOL animated = YES;
    [FlutterAddtoappBridgePlugin runBlockInMainThread:^{
        NSUInteger finalCount = (NSUInteger) count;
        if (currentViewController.navigationController) {
            if (count == -1) {
                [currentViewController.navigationController popToRootViewControllerAnimated:animated];
            } else {
                NSUInteger allCount = currentViewController.navigationController.viewControllers.count;
                if (allCount == 1) {
                    exit(0);
                } else {
                    if (finalCount > allCount) {
                        finalCount = 1;
                    }
                    UIViewController *toVC = currentViewController.navigationController.viewControllers[(allCount - finalCount - 1)];
                    [currentViewController.navigationController popToViewController:toVC animated:animated];
                }
            }
        } else {
            UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
            if (rootViewController == currentViewController) {
                exit(0);
            } else {
                if (count == -1) {
                    if (rootViewController.navigationController) {
                        [rootViewController.navigationController popToRootViewControllerAnimated:true];
                    } else {
                        [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:true completion:nil];
                    };
                } else {
                    [currentViewController dismissViewControllerAnimated:YES completion:nil];
                }
            }
        }
    }];
}

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
#pragma clang diagnostic push
#pragma ide diagnostic ignored "IncompatibleTypes"
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
#pragma clang diagnostic pop
    UIView *firstSubview = alert.view.subviews.firstObject;
    UIView *alertContentView = firstSubview.subviews.firstObject;
    for (UIView *subSubView in alertContentView.subviews) {
        subSubView.backgroundColor = [UIColor colorWithRed:0 / 255.0f green:0 / 255.0f blue:0 / 255.0f alpha:0.73f];
    }
    NSMutableAttributedString *AS = [[NSMutableAttributedString alloc] initWithString:message];
    [AS addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, AS.length)];
#pragma clang diagnostic push
#pragma ide diagnostic ignored "KeyValueCodingInspection"
    [alert setValue:AS forKey:@"attributedTitle"];
#pragma clang diagnostic pop
    [viewController presentViewController:alert animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:^{
        }];
    });
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    UIViewController *topmostViewController = [FlutterAddtoappBridgePlugin topmostViewController];
    NSLog(@"handleMethodCall topViewController=%@, method=%@, arguments=%@", topmostViewController, call.method, call.arguments);

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
