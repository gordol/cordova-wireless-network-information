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
	NSURL *url=[NSURL URLWithString:argumentAtIndex:0];
	NSLog(@"url is %@", url);

	NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];

	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody: requestData];

	NSHTTPURLResponse *response;
	[NSURLConnection sendSynchronousRequest:request returningResponse:&response error: NULL];

	return ([response statusCode]==200)?YES:NO;
}

//todo: fixme: init with webview

@end
