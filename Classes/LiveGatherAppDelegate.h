//
//  LiveGatherAppDelegate.h
//  LiveGather
//
//  Created by Alexander on 4/13/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResourceManager.h"
#import "LiveGatherAPI.h"

@class MainViewController, AccountLoginViewController;

@interface LiveGatherAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MainViewController *mainViewController;
	AccountLoginViewController *accountViewController;
	NSUserDefaults *settings;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) MainViewController *mainViewController;
@property (nonatomic, retain) AccountLoginViewController *accountViewController;

@end

