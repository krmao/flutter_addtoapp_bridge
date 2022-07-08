#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "FlutterAddtoappBridgePlugin.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
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
                  [FlutterAddtoappBridgePlugin showToast:(NSString *)[argumentsArray objectAtIndex:1]];
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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [FlutterAddtoappBridgePlugin showToast:@"hahahahahahahahahhahahahahahahhahaha"];
    });
    
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
