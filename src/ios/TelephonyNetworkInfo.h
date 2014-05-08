#import <Cordova/CDVPlugin.h>

@interface TelephonyNetworkInfo : CDVPlugin {

}

- (void)getCurrentAccessTechnology:(CDVInvokedUrlCommand*)command;
- (void)testServerConnectivity:(CDVInvokedUrlCommand*)command;

@end
