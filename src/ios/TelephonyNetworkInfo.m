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

- (void)testServerConnectivity:(CDVInvokedUrlCommand*)command;
{
    NSURL *url = [[NSURL alloc] initWithString:[command.arguments objectAtIndex:0]];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
	[request setHTTPMethod:@"GET"];
	NSHTTPURLResponse *response;
	[NSURLConnection sendSynchronousRequest:request returningResponse:&response error: NULL];
	CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:([response statusCode]==200)?YES:NO];
	[self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

@end
