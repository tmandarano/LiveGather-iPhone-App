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

@class CollageView;

@interface LiveStreamViewController : UIViewController <MBProgressHUDDelegate> {
	IBOutlet UIButton			*backButton;
	IBOutlet UILabel			*userNameLabel;
	//IBOutlet UIScrollView		*liveStreamScrollView;
	IBOutlet UIButton			*searchButton;
	IBOutlet UIButton			*refreshButton;
	NSMutableArray				*liveStreamObjects;
	LiveGatherAPI				*applicationAPI;
	MBProgressHUD				*HUD;
	CollageView					*liveStreamScrollView;
}

@property (nonatomic, retain) CollageView *liveStreamScrollView;

- (IBAction)goHome;
- (void)updateLiveStreamPhotos;
- (void)newLiveStreamPhotosDownloaded;
- (IBAction)refreshLiveStream;
- (IBAction)searchLiveSteam;
- (void)userTouchedLiveStreamView:(float)x_coord andYCoord:(float)y_coord;

@end
