//
//  MainViewController.h
//  LiveGather
//
//  Created by Alexander on 4/13/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "UploadPhotoViewController.h"
#import "LiveStreamViewController.h"
#import "AccountLoginViewController.h"
#import "MBProgressHUD.h"
#import "LiveGatherAPI.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "LGPhoto.h"
#import "LGTag.h"
#import "LGPhotoView.h"
#import "SinglePhotoViewController.h"
#import "LGUser.h"

@class UploadPhotoViewController, AccountLoginViewController, LiveStreamViewController, SinglePhotoViewController;
@class ASINetworkQueue;

@interface MainViewController : UIViewController <UIScrollViewDelegate, UINavigationControllerDelegate, MBProgressHUDDelegate, LGPhotoDelegate> {
	IBOutlet UIButton			*viewLiveStreamButton;
	IBOutlet UIScrollView		*liveStreamPreviewScrollView;
	IBOutlet UIScrollView		*tagsScrollView;
	IBOutlet UIButton			*refreshLiveStreamMiniViewButton;
	IBOutlet UIButton			*uploadPhotoButton;
	IBOutlet UIButton			*myStreamButton;
	IBOutlet UIButton			*peopleWatchingButton;
	IBOutlet UIButton			*settingsButton;
	NSUserDefaults				*settings;
	UploadPhotoViewController	*uploadViewController;
	LiveStreamViewController	*liveStreamView;
	SinglePhotoViewController	*singlePhotoView;
	IBOutlet UIProgressView		*progressView;
	MBProgressHUD				*HUD;
	LiveGatherAPI				*applicationAPI;
	ASINetworkQueue				*networkQueue;
	NSMutableArray				*liveStreamObjects;
	NSMutableArray				*liveStreamObjectViews;
	
	NSMutableSet				*visibleLiveStreamItems;
	NSMutableSet				*recycledLiveStreamItems;
	
	NSMutableDictionary			*imageFilePathsDictionary;
}

- (IBAction)viewLiveStream;
- (IBAction)uploadPhoto;

- (void)updateTags;

- (IBAction)updateLiveStreamPhotos;
- (IBAction)refreshStream;
- (void)downloadNewLiveStreamPhotos;
- (void)imageFetchComplete:(ASIHTTPRequest *)request;
- (void)imageDownloadingFinished;


- (int)liveStreamItemsCurrentlyInView:(NSString *)index;
- (CGRect)getRectForItemInLiveStream:(int)index;

- (void)drawItemsToLiveStream;
- (int)numberOfImagesForStream;
- (BOOL)isDisplayingItemForIndex:(int)index;
- (LGPhotoView *)dequeueRecycledLiveStreamView;
- (LGPhotoView *)configureItem:(LGPhotoView *)item forIndex:(int)index;
- (BOOL)isScrollViewScrolling;

@end
