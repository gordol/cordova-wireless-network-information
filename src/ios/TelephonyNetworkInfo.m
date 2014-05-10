#import "TelephonyNetworkInfo.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@implementation TelephonyNetworkInfo

- (void)getCurrentAccessTechnology:(CDVInvokedUrlCommand*)command
{
	NSLog(@"getCurrentAccessTechnology Running");
	CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
	NSLog(@"Current Radio Access Technology: %@", telephonyInfo.currentRadioAccessTechnology);

	CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[telephonyInfo currentRadioAccessTechnology]];
	[self.commandDelegate sendPluginResult:result callbackId:[command callbackId]];

	NSLog(@"getCurrentAccessTechnology Result: %@", result);
	NSLog(@"getCurrentAccessTechnology Callback: %@", [command callbackId]);

	[NSNotificationCenter.defaultCenter addObserverForName:CTRadioAccessTechnologyDidChangeNotification 
													object:nil 
													 queue:nil 
												usingBlock:^(NSNotification *note) 
												{
													NSLog(@"New Radio Access Technology: %@", telephonyInfo.currentRadioAccessTechnology);
													CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[telephonyInfo currentRadioAccessTechnology]];
													[self.commandDelegate sendPluginResult:result callbackId:[command callbackId]];

													NSLog(@"getCurrentAccessTechnology Observer Result: %@", result);
													NSLog(@"getCurrentAccessTechnology Observer Callback: %@", [command callbackId]);
												}];
	NSLog(@"getCurrentAccessTechnology Done");
}

- (void)testServerConnectivity:(CDVInvokedUrlCommand*)command;
{
	NSLog(@"testServerConnectivity Running");
	[self.commandDelegate runInBackground:^{
		NSURL* url = [[NSURL alloc] initWithString:[command.arguments objectAtIndex:0]];
		NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
		NSHTTPURLResponse* response;
		[request setHTTPMethod:@"GET"];
		[NSURLConnection sendSynchronousRequest:request returningResponse:&response error: NULL];
		CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:([response statusCode]==200)?YES:NO];

		NSLog(@"testServerConnectivity Result: %@", result);
		NSLog(@"getCurrentAccessTechnology Callback: %@", [command callbackId]);

		[self.commandDelegate sendPluginResult:result callbackId:[command callbackId]];
	}];
	NSLog(@"testServerConnectivity Done");
}

- (void)onAppTerminate
{
	//todo
	NSLog(@"App terminating");
}

- (void)onMemoryWarning
{
	//todo
	NSLog(@"Memory Warning");
}

- (void) onPause 
{
	//todo
	NSLog(@"Pausing");
}

- (void) onResume 
{
	//todo
	NSLog(@"Resuming");
}

- (CDVPlugin*)initWithWebView:(UIWebView*)theWebView
{
	self = [super init];
	if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppTerminate) name:UIApplicationWillTerminateNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReset) name:CDVPluginResetNotification object:theWebView];

		self.webView = theWebView;
	}
	return self;
}

- (void)pluginInitialize
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPause) name:UIApplicationDidEnterBackgroundNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onResume) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)dealloc
{
	NSLog(@"Deallocating, cleaning up...");
	//cleanup observers
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
