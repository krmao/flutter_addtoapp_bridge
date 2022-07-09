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
          NSLog(@"AppDelegate onCall %@" ,[call.arguments class]);
          NSArray *argumentsWithFunctionNameArray = (NSArray *)call.arguments;
          NSString *functionName = [argumentsWithFunctionNameArray firstObject];
          if([@"getPlatformVersion" isEqualToString:functionName]){
              result([[UIDevice currentDevice] systemVersion]);
          }else if([@"open" isEqualToString:functionName]){
              NSArray *argumentsArray = (NSArray *)[argumentsWithFunctionNameArray objectAtIndex:1];
              NSString *url = [argumentsArray firstObject];
              if([@"toast" isEqualToString:url]){
                  [FlutterAddtoappBridgePlugin showToast:(NSString *)[argumentsArray objectAtIndex:1]];
                  result(@"0");
              }else{
                  result(FlutterMethodNotImplemented);
              }
          }else{
              result(FlutterMethodNotImplemented);
          }
      }else{
          result(FlutterMethodNotImplemented);
      }
  }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [FlutterAddtoappBridgePlugin showToast:@"show toast delay 5 second on AppDelegate"];
    });
    
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
