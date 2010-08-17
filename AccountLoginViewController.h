//
//  AccountLoginViewController.h
//  LiveGather
//
//  Created by Alexander on 4/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResourceManager.h"
#import "MainViewController.h"
#import "LiveGatherAPI.h"
#import "JRAuthenticate.h"

@class LiveGatherAPI, MainViewController;

@interface AccountLoginViewController : UIViewController <UITextFieldDelegate, JRAuthenticateDelegate> {
	LiveGatherAPI			*applicationAPI;
	MainViewController		*mainViewController;
	JRAuthenticate			*jrAuthenticate;
}

- (IBAction)login;
- (IBAction)signup;

@end
