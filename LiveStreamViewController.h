//
//  LiveStreamViewController.h
//  LiveGather
//
//  Created by Alexander on 4/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveGatherAPI.h"
#import "MBProgressHUD.h"
#import <MapKit/MapKit.h>
#import "CollageView.h"
#import "CollageItem.h"
#import "LGPhoto.h"
#import "LGTag.h"
#import "LGPhotoView.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@class CollageView, ASINetworkQueue;

@interface LiveStreamViewController : UIViewController <MBProgressHUDDelegate, UIScrollViewDelegate> {
	IBOutlet UIButton			*backButton;
	IBOutlet UILabel			*userNameLabel;
	//IBOutlet UIScrollView		*liveStreamScrollView;
	IBOutlet UIButton			*searchButton;
	IBOutlet UIButton			*refreshButton;
	LiveGatherAPI				*applicationAPI;
	MBProgressHUD				*HUD;
	CollageView					*liveStreamScrollView;
	ASINetworkQueue				*networkQueue;
	
	NSMutableArray				*liveStreamObjects;
	NSMutableArray				*liveStreamObjectViews;
	NSMutableSet				*visibleLiveStreamItems;
	NSMutableSet				*recycledLiveStreamItems;
}

@property (nonatomic, retain) CollageView *liveStreamScrollView;

- (IBAction)goHome;
- (void)updateLiveStreamPhotos;
- (void)downloadNewLiveStreamPhotos;
- (IBAction)refreshLiveStream;
- (IBAction)searchLiveSteam;

- (void)imageFetchComplete:(ASIHTTPRequest *)request;
- (void)imageDownloadingFinished;

- (int)liveStreamItemsCurrentlyInView:(NSString *)index;
- (CGRect)getRectForItemInLiveStream:(int)index;

- (void)drawItemsToLiveStream;
- (int)numberOfImagesForStream;
- (BOOL)isDisplayingItemForIndex:(int)index;
- (LGPhotoView *)dequeueRecycledLiveStreamView;
- (LGPhotoView *)configureItem:(LGPhotoView *)item forIndex:(int)index;

@end
