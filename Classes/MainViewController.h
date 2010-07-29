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
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "LGPhoto.h"
#import "LGTag.h"

@class ResourceManager, UploadPhotoViewController, AccountLoginViewController, LiveStreamViewController, ASINetworkQueue;

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UINavigationControllerDelegate, MBProgressHUDDelegate> {
	IBOutlet UIButton			*viewLiveStreamButton;
	IBOutlet UIScrollView		*liveStreamPreviewScrollView;
	IBOutlet UIScrollView		*tagsScrollView;
	IBOutlet UIButton			*refreshLiveStreamMiniViewButton;
	IBOutlet UIButton			*uploadPhotoButton;
	IBOutlet UIButton			*myStreamButton;
	IBOutlet UIButton			*peopleWatchingButton;
	IBOutlet UIButton			*settingsButton;
	NSUserDefaults				*settings;
	ResourceManager				*appResourceManager;
	UploadPhotoViewController	*uploadViewController;
	LiveStreamViewController	*liveStreamView;
	IBOutlet UIProgressView		*progressView;
	MBProgressHUD				*HUD;
	LiveGatherAPI				*applicationAPI;
	ASINetworkQueue				*networkQueue;
	NSMutableArray				*liveStreamObjects;
}

@property (nonatomic, retain) ResourceManager *appResourceManager;

- (IBAction)viewLiveStream;
- (IBAction)uploadPhoto;

- (void)updateTags;

- (IBAction)updateLiveStreamPhotos;
- (IBAction)refreshStream;
- (void)downloadNewLiveStreamPhotos;
- (void)imageFetchComplete:(ASIHTTPRequest *)request;
- (void)imageDownloadingFinished;

//
- (IBAction)showInfo;
//

@end
