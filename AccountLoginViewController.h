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

@class LiveGatherAPI, MainViewController;

@interface AccountLoginViewController : UIViewController <UITextFieldDelegate> {
	IBOutlet UITextField	*emailLoginField;
	IBOutlet UITextField	*passwordLoginField;
	IBOutlet UIButton		*loginButton;
	IBOutlet UIButton		*signupButton;
	LiveGatherAPI			*livegatherController;
	MainViewController		*mainViewController;
}

- (IBAction)login;
- (IBAction)signup;

@end
