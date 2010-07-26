//
//  UploadPhotoViewController.h
//  LiveGather
//
//  Created by Alexander on 4/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResourceManager.h"
#import "MainViewController.h"
#import "LiveGatherAPI.h"
#import "LGPhoto.h"
#import "LGTag.h"

@class MainViewController, LiveGatherAPI;

@interface UploadPhotoViewController : UIViewController <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, UIActionSheetDelegate> {
	IBOutlet UIButton			*backButton;
	IBOutlet UIButton			*uploadButton;
	IBOutlet UITextField		*captionTextField;
	IBOutlet UITextField		*tagsTextField;
	IBOutlet UILabel			*locationLabel;
	IBOutlet UIButton			*refreshLocationButton;
	IBOutlet UIButton			*sendToTwitterButton;
	IBOutlet UIButton			*sendToFacebookButton;
	
	MainViewController			*mainViewController;
	LiveGatherAPI				*livegatherController;
	UIImagePickerController		*imagePickerController;
}

- (IBAction)cancel;
- (IBAction)upload;
- (IBAction)refreshLocation;
- (IBAction)sendToTwitter;
- (IBAction)sendToFacebook;
- (void)showUserImageControlOption;

@end
