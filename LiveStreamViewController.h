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
#import "CollageItem.h"
#import "LGPhoto.h"
#import "LGTag.h"
#import "LGPhotoView.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "LGUser.h"

typedef enum _CurrentLiveStreamMode {
	kLiveStreamModeIcons = 0,
	kLiveStreamModeLarge
} CurrentLiveStreamMode;

@class ASINetworkQueue;

@interface LiveStreamViewController : UIViewController <MBProgressHUDDelegate, UIScrollViewDelegate, LGPhotoDelegate> {
	IBOutlet UIButton			*backButton;
	IBOutlet UILabel			*userNameLabel;
	IBOutlet UIButton			*searchButton;
	IBOutlet UIButton			*refreshButton;
	LiveGatherAPI				*applicationAPI;
	MBProgressHUD				*HUD;
	UIScrollView				*liveStreamScrollView;
	ASINetworkQueue				*networkQueue;
	CurrentLiveStreamMode		currentLiveStreamMode;
	
	NSMutableArray				*liveStreamObjects;
	NSMutableArray				*liveStreamObjectViews;
	NSMutableSet				*visibleLiveStreamItems;
	NSMutableSet				*recycledLiveStreamItems;
}

- (IBAction)goHome;
- (void)updateLiveStreamPhotos;
- (void)downloadNewLiveStreamPhotos;
- (IBAction)searchLiveSteam;

- (void)imageFetchComplete:(ASIHTTPRequest *)request;
- (void)imageDownloadingFinished;

- (IBAction)refreshLiveStream;
- (void)refreshComplete:(ASIHTTPRequest *)request;

- (int)liveStreamItemsCurrentlyInView:(NSString *)index;
- (CGRect)getRectForItemInLiveStream:(int)index;
- (int)largeImageCurrentlyMostDisplayed;


- (void)drawItemsToLiveStream;
- (void)redrawAllItemsToLiveStream;

- (int)numberOfImagesForStream;
- (BOOL)isDisplayingItemForIndex:(int)index;
- (LGPhotoView *)dequeueRecycledLiveStreamView;
- (LGPhotoView *)configureItem:(LGPhotoView *)item forIndex:(int)index;

- (void)doneViewingImageMap:(id)sender;

@end
