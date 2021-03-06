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
#import "LGUser.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "CLController.h"

@class MainViewController, LiveGatherAPI, ASIFormDataRequest;

@interface UploadPhotoViewController : UIViewController <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, UIActionSheetDelegate, MBProgressHUDDelegate, CLControllerDelegate, CLLocationManagerDelegate> {
	IBOutlet UIButton			*backButton;
	IBOutlet UIButton			*uploadButton;
	IBOutlet UITextField		*captionTextField;
	IBOutlet UITextField		*tagsTextField;
	IBOutlet UILabel			*locationLabel;
	IBOutlet UIButton			*refreshLocationButton;
	IBOutlet UIButton			*sendToTwitterButton;
	IBOutlet UIButton			*sendToFacebookButton;
	IBOutlet UIImageView		*chosenPhotoPreviewView;
	MBProgressHUD				*HUD;
	
	MainViewController			*mainViewController;
	UIImagePickerController		*imagePickerController;
	
	NSString					*fileResponseFromServer;
}

- (IBAction)cancel;
- (IBAction)upload;
- (IBAction)refreshLocation;
- (IBAction)sendToTwitter;
- (IBAction)sendToFacebook;
- (void)showUserImageControlOption;
- (void)uploadImageToServer:(UIImage *)img;
- (void)resetUploadView;
- (void)doServerUpload;

@end
