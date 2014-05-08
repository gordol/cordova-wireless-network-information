#import "TelephonyNetworkInfo.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@implementation TelephonyNetworkInfo

- (void)getCurrentAccessTechnology:(CDVInvokedUrlCommand*)command
{
	CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
	NSLog(@"Current Radio Access Technology: %@", telephonyInfo.currentRadioAccessTechnology);

	CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[telephonyInfo currentRadioAccessTechnology]];
	[self.commandDelegate sendPluginResult:result callbackId:[command callbackId]];

	[NSNotificationCenter.defaultCenter addObserverForName:CTRadioAccessTechnologyDidChangeNotification 
		object:nil 
		queue:nil 
		usingBlock:^(NSNotification *note) 
	{
		NSLog(@"New Radio Access Technology: %@", telephonyInfo.currentRadioAccessTechnology);
		CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[telephonyInfo currentRadioAccessTechnology]];
		[self.commandDelegate sendPluginResult:result callbackId:[command callbackId]];
	}];
}

- (BOOL)testServerConnectivity:(CDVInvokedUrlCommand*)command;
{
	NSURL* url=[command.arguments objectAtIndex:0];
	NSLog(@"url is %@", url);

	NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];

	[request setHTTPMethod:@"GET"];

	NSHTTPURLResponse *response;
	[NSURLConnection sendSynchronousRequest:request returningResponse:&response error: NULL];

	if ([response statusCode] == 200) {
		CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];
	} else { 
		CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsBool:NO];
	}

	[self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

//todo: fixme: init with webview

@end
