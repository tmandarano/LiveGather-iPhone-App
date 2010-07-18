//
//  LiveGatherAppDelegate.m
//  LiveGather
//
//  Created by Alexander on 4/13/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "LiveGatherAppDelegate.h"
#import "MainViewController.h"
#import "AccountLoginViewController.h"

@implementation LiveGatherAppDelegate


@synthesize window;
@synthesize mainViewController;
@synthesize accountViewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	settings = [NSUserDefaults standardUserDefaults];
	
	/*if(![settings stringForKey:kUserSettingUserUsername])
	{
		/*No login information here, we're gonna have to popup the account view
		AccountLoginViewController *aController = [[AccountLoginViewController alloc] initWithNibName:@"AccountLoginView" bundle:nil];
		self.accountViewController = aController;
		[aController release];
		
		accountViewController.view.frame = [UIScreen mainScreen].applicationFrame;
		[window addSubview:[accountViewController view]];
		[window makeKeyAndVisible];* /
		
		static NSString *authAppID = @"pefmjggfjdbdhjfibbjg";
		static NSString *authTokenURL = @"<TOKEN_URL>";
		
		JRAuthenticate *jrAuthenticate = [JRAuthenticate jrAuthenticateWithAppID:authAppID andTokenUrl:authTokenURL delegate:self];
		[jrAuthenticate showJRAuthenticateDialog];
	}
	else {
		//Verify login here, and then show the main view controller
		
		MainViewController *aController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
		self.mainViewController = aController;
		[aController release];
		
		mainViewController.view.frame = [UIScreen mainScreen].applicationFrame;
		[window addSubview:[mainViewController view]];
		[window makeKeyAndVisible];
	}*/
    
	MainViewController *aController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	self.mainViewController = aController;
	[aController release];
	
    mainViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	[window addSubview:[mainViewController view]];
    [window makeKeyAndVisible];
	
	return YES;
}

- (void)jrAuthenticate:(JRAuthenticate*)jrAuth didReceiveToken:(NSString*)token forProvider:(NSString*)provider {
	
}

- (void)jrAuthenticate:(JRAuthenticate*)jrAuth didReachTokenURL:(NSString*)tokenURL withPayload:(NSString*)tokenUrlPayload {
	
}

- (void)dealloc {
    [mainViewController release];
    [window release];
    [super dealloc];
}

@end
