//
//  MainViewController.h
//  LiveGather
//
//  Created by Alexander on 4/13/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "FlipsideViewController.h"
#import "UploadPhotoViewController.h"
#import "LiveStreamViewController.h"
#import "AccountLoginViewController.h"
#import "ResourceManager.h"
#import "MBProgressHUD.h"
#import "LiveGatherAPI.h"

@class ResourceManager, UploadPhotoViewController, AccountLoginViewController, LiveStreamViewController;

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MBProgressHUDDelegate> {
	IBOutlet UIButton			*viewLiveStreamButton;
	IBOutlet UIScrollView		*liveStreamPreviewScrollView;
	UIImagePickerController		*imagePickerController;
	NSUserDefaults				*settings;
	ResourceManager				*appResourceManager;
	UploadPhotoViewController	*uploadViewController;
	LiveStreamViewController	*liveStreamView;
	IBOutlet UIProgressView		*progressView;
	MBProgressHUD				*HUD;
	LiveGatherAPI				*applicationAPI;
}

@property (nonatomic, retain) ResourceManager *appResourceManager;

- (IBAction)viewLiveStream;

- (void)updateLiveStreamPhotos;
- (void)newLiveStreamPhotosDownloaded;

//
- (IBAction)showInfo;
//

@end
