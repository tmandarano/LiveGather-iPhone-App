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
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "LiveGatherAPI.h"

@class ResourceManager, UploadPhotoViewController, AccountLoginViewController, LiveStreamViewController, ASINetworkQueue;

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MBProgressHUDDelegate> {
	IBOutlet UIButton					*viewLiveStreamButton;
	IBOutlet UIButton					*capturePhotoButton;
	IBOutlet UIButton					*choosePhotoButton;
	UIImagePickerController				*imagePickerController;
	IBOutlet UIImageView				*mainLiveStreamIcon;
	IBOutlet UILabel					*mainLiveStreamIconTitle;
	IBOutlet UILabel					*mainLiveStreamIconDescription;
	IBOutlet UIActivityIndicatorView	*mainLiveStreamIconLoadingIndicator;
	IBOutlet UIImageView				*liveStreamIconOne;
	IBOutlet UIImageView				*liveStreamIconTwo;
	IBOutlet UIImageView				*liveStreamIconThree;
	IBOutlet UIImageView				*liveStreamIconFour;
	IBOutlet UIImageView				*liveStreamIconFive;
	IBOutlet UIImageView				*liveStreamIconSix;
	IBOutlet UIImageView				*liveStreamIconSeven;
	IBOutlet UIImageView				*liveStreamIconEight;
	IBOutlet UIImageView				*liveStreamIconNine;
	IBOutlet UIImageView				*liveStreamIconTen;
	IBOutlet UIActivityIndicatorView	*liveStreamIconOneLoadingIndicator;
	IBOutlet UIActivityIndicatorView	*liveStreamIconTwoLoadingIndicator;
	IBOutlet UIActivityIndicatorView	*liveStreamIconThreeLoadingIndicator;
	IBOutlet UIActivityIndicatorView	*liveStreamIconFourLoadingIndicator;
	IBOutlet UIActivityIndicatorView	*liveStreamIconFiveLoadingIndicator;
	IBOutlet UIActivityIndicatorView	*liveStreamIconSixLoadingIndicator;
	IBOutlet UIActivityIndicatorView	*liveStreamIconSevenLoadingIndicator;
	IBOutlet UIActivityIndicatorView	*liveStreamIconEightLoadingIndicator;
	IBOutlet UIActivityIndicatorView	*liveStreamIconNineLoadingIndicator;
	IBOutlet UIActivityIndicatorView	*liveStreamIconTenLoadingIndicator;
	NSUserDefaults						*settings;
	ResourceManager						*appResourceManager;
	UploadPhotoViewController			*uploadViewController;
	LiveStreamViewController			*liveStreamView;
	ASINetworkQueue						*networkQueue;
	IBOutlet UIProgressView				*progressView;
	MBProgressHUD						*HUD;
	LiveGatherAPI						*applicationAPI;
}

@property (nonatomic, retain) ResourceManager *appResourceManager;

- (IBAction)takePhoto;
- (IBAction)choosePhoto;
- (IBAction)viewLiveStream;

- (void)updateLiveStreamPhotos;
- (void)newLiveStreamPhotosDownloaded;

//
- (IBAction)showInfo;
//

@end
