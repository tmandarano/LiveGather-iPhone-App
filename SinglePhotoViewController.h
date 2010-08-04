//
//  SinglePhotoViewController.h
//  LiveGather
//
//  Created by Alexander on 8/2/10.
//  Copyright 2010 LiveGather. All rights reserved.
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
#import "LGUser.h"

@class ASINetworkQueue, ASIHTTPRequest, LiveGatherAPI;

@interface SinglePhotoViewController : UIViewController {
	IBOutlet UIImageView	*mainImageView;
	IBOutlet UILabel		*imageNameLabel;
	IBOutlet UIButton		*backButton;
	IBOutlet UILabel		*uploadTimeLabel;
	IBOutlet UILabel		*usernameLabel;
	IBOutlet UILabel		*imageLocationLabel;
	IBOutlet UILabel		*imageCaptionLabel;
	IBOutlet UILabel		*imageTagsLabel;
	IBOutlet UILabel		*imageCommentsLabel;
	IBOutlet UIButton		*addCommentButton;
	ASINetworkQueue			*networkQueue;
	LiveGatherAPI			*applicationAPI;
	
	int						imageID;
	LGPhoto					*imageInformation;
}

@property (nonatomic) int imageID;

- (IBAction)cancel;
- (IBAction)addComment;
- (void)showComments;
- (void)showImageWithID:(int)imgID;
- (void)imageFetchComplete:(ASIHTTPRequest *)request;
- (void)imageAlreadyExists:(int)imgID;
- (void)initializeResources;

@end
