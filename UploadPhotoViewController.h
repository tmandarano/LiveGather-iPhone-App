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

@class MainViewController, LiveGatherAPI;

@interface UploadPhotoViewController : UIViewController <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, UIActionSheetDelegate> {
	IBOutlet UIImageView		*imagePreview;
	IBOutlet UIImageView		*captionTextFieldBackground;
	IBOutlet UIImageView		*tagsTextFieldBackground;
	IBOutlet UITextField		*captionTextField;
	IBOutlet UITextField		*tagsTextField;
	IBOutlet UILabel			*privacySelectionLabel;
	IBOutlet UIButton			*cancelButton;
	IBOutlet UIButton			*uploadButton;
	IBOutlet UIButton			*privacySelectionButton;
	IBOutlet UILabel			*topBarNameLabel;
	
	UIImage						*imageForUpload;
	MainViewController			*mainViewController;
	LiveGatherAPI				*livegatherController;
	UIImagePickerController		*imagePickerController;
}

- (IBAction)cancel;
- (IBAction)upload;
- (IBAction)privacySelectionButtonPressed;
- (void)showUserImageControlOption;

@end
