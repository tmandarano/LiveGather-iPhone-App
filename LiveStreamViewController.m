//
//  LiveStreamViewController.m
//  LiveGather
//
//  Created by Alexander on 4/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LiveStreamViewController.h"


@implementation LiveStreamViewController

//Functions for calculating the index number of livestream items
#define photoIndex(row, col) ((3 * col) + row)
#define largePhotoIndex(row, col) ((1 * col) + row)

//Measurements for all livestream items
#define kLiveStreamPreviewStartPoint_X 5
#define kLiveStreamPreviewStartPoint_Y 15
#define kLiveStreamPreviewMidStartPoint_X 5
#define kLiveStreamPreviewMidStartPoint_Y 147
#define kLiveStreamPreviewBottomStartPoint_X 5
#define kLiveStreamPreviewBottomStartPoint_Y 279
#define kLiveStreamPreviewVerticalPadding 2
#define kLiveStreamPreviewHorizontalPadding 2
#define kLiveStreamPreviewImageWidth 125
#define kLiveStreamPreviewImageHeight 130
#define kLiveStreamPreviewStaticHeight 415
//For Large View
#define kLiveStreamStartPoint_X 15
#define kLiveStreamStartPoint_Y 9
#define kLiveStreamHorizontalPadding 7
#define kLiveStreamImageWidth 290
#define kLiveStreamImageHeight 360


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		
    }
    return self;
}


// We're going to do our setup work here
- (void)viewDidLoad {
	//App API is a designated place for all server and misc. functions
	applicationAPI = [[LiveGatherAPI alloc] init];
	
	//Setup the frame for our scroll view for the livestream
	liveStreamScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 416)];
	[liveStreamScrollView setBackgroundColor:[UIColor blackColor]];
	[liveStreamScrollView setDelegate:self];
	
	//liveStreamObjects will hold LGPhotos and liveStreamObjectViews will hold LGPhotoViews
	if(!liveStreamObjects) liveStreamObjects = [NSMutableArray new];
	if(!liveStreamObjectViews) liveStreamObjectViews = [NSMutableArray new];
	
	if (!visibleLiveStreamItems) visibleLiveStreamItems = [[NSMutableSet alloc] init];
	if (!recycledLiveStreamItems) recycledLiveStreamItems = [[NSMutableSet alloc] init];
	
	currentLiveStreamMode = kLiveStreamModeIcons;
	
	[self.view addSubview:liveStreamScrollView];
	[self updateLiveStreamPhotos];
	
	[super viewDidLoad];
}

//Custom Methods

- (void)drawItemsToLiveStream {
	if (currentLiveStreamMode == kLiveStreamModeIcons) {
		if ([liveStreamObjects count] > 0) {
			int firstIndexVisibleInStream = [self liveStreamItemsCurrentlyInView:@"first"];
			int lastIndexVisibleInStream = [self liveStreamItemsCurrentlyInView:@"last"];
			for (LGPhotoView *photoView in visibleLiveStreamItems) {
				if (photoView.photo.photoIndex < firstIndexVisibleInStream || photoView.photo.photoIndex > lastIndexVisibleInStream) {
					[recycledLiveStreamItems addObject:photoView];
					[photoView removeFromSuperview];
				}
			}
			[visibleLiveStreamItems minusSet:recycledLiveStreamItems];
			
			for (int i = firstIndexVisibleInStream; i <= lastIndexVisibleInStream; i++) {
				if (![self isDisplayingItemForIndex:i]) {
					LGPhotoView *photoView = [self dequeueRecycledLiveStreamView];
					if (photoView == nil) {
						photoView = [[[LGPhotoView alloc] init] autorelease];
					}
					
					photoView = [self configureItem:photoView forIndex:i];
					[photoView setUserInteractionEnabled:YES];
					[photoView setDelegate:self];
					
					LGPhoto *photo = [liveStreamObjects objectAtIndex:i];
					
					//Add in subviews
					UIImageView *uploadDateBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"single_image_location_bg.png"]];
					[uploadDateBackground setFrame:CGRectMake(12, 105, 100, 20)];
					[uploadDateBackground setAlpha:0.65];
					
					UILabel *uploadDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
					[uploadDateLabel setText:[applicationAPI getTimeSinceMySQLDate:photo.photoDateAdded]];
					[uploadDateLabel setTextAlignment:UITextAlignmentCenter];
					[uploadDateLabel setAdjustsFontSizeToFitWidth:YES];
					[uploadDateLabel setMinimumFontSize:10];
					[uploadDateLabel setTextColor:[UIColor whiteColor]];
					[uploadDateLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
					[uploadDateLabel setBackgroundColor:[UIColor clearColor]];
					[uploadDateBackground addSubview:uploadDateLabel];
					
					[photoView addSubview:uploadDateBackground];
					
					/************************MEMORY FIX HERE***************************/
					[uploadDateLabel release];
					[uploadDateBackground release];
					/************************MEMORY FIX HERE***************************/
					
					[liveStreamScrollView addSubview:photoView];
					[visibleLiveStreamItems addObject:photoView];
				}
			}
		}
		else {
			
		}
	}
	else if (currentLiveStreamMode == kLiveStreamModeLarge) {
		if ([liveStreamObjects count] > 0) {
			int firstIndexVisibleInStream = [self liveStreamItemsCurrentlyInView:@"first"];
			int lastIndexVisibleInStream = [self liveStreamItemsCurrentlyInView:@"last"];
			for (LGPhotoView *photoView in visibleLiveStreamItems) {
				if (photoView.photo.photoIndex < firstIndexVisibleInStream || photoView.photo.photoIndex > lastIndexVisibleInStream) {
					[recycledLiveStreamItems addObject:photoView];
					[photoView removeFromSuperview];
				}
			}
			[visibleLiveStreamItems minusSet:recycledLiveStreamItems];
			
			for (int i = firstIndexVisibleInStream; i <= lastIndexVisibleInStream; i++) {
				if (![self isDisplayingItemForIndex:i]) {
					LGPhotoView *photoView = [self dequeueRecycledLiveStreamView];
					if (photoView == nil) {
						photoView = [[[LGPhotoView alloc] init] autorelease];
					}					
					photoView = [self configureItem:photoView forIndex:i];
					[photoView setUserInteractionEnabled:YES];
					[photoView setDelegate:self];
					
					LGPhoto *photo = [liveStreamObjects objectAtIndex:i];
					
					//Add in subviews
					UIImageView *uploadDateBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"single_image_location_bg.png"]];
					[uploadDateBackground setFrame:CGRectMake(5, 7, 97, 18)];
					[uploadDateBackground setAlpha:0.7];
					
					UIImageView *usernameBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"single_image_location_bg.png"]];
					[usernameBackground setFrame:CGRectMake(199, 7, 88, 18)];
					[usernameBackground setAlpha:0.7];
					
					UIImageView *locationBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"single_image_location_bg.png"]];
					[locationBackground setFrame:CGRectMake(77, 311, 155, 18)];
					[locationBackground setAlpha:0.7];
					
					UIImageView *imageDetailsBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"single_image_caption_bg.png"]];
					[imageDetailsBackground setFrame:CGRectMake(5, 332, 280, 23)];
					[imageDetailsBackground setAlpha:0.9];
					
					UILabel *uploadDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 97, 18)];
					[uploadDateLabel setText:[applicationAPI getTimeSinceMySQLDate:photo.photoDateAdded]];
					[uploadDateLabel setTextAlignment:UITextAlignmentCenter];
					[uploadDateLabel setAdjustsFontSizeToFitWidth:YES];
					[uploadDateLabel setMinimumFontSize:10];
					[uploadDateLabel setTextColor:[UIColor whiteColor]];
					[uploadDateLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
					[uploadDateLabel setBackgroundColor:[UIColor clearColor]];
					[uploadDateBackground addSubview:uploadDateLabel];
					
					LGUser *user = photoView.photo.photoUser;
					UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 88, 18)];
					[usernameLabel setText:user.username];
					[usernameLabel setTextAlignment:UITextAlignmentCenter];
					[usernameLabel setAdjustsFontSizeToFitWidth:YES];
					[usernameLabel setMinimumFontSize:10];
					[usernameLabel setTextColor:[UIColor whiteColor]];
					[usernameLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
					[usernameLabel setBackgroundColor:[UIColor clearColor]];
					[usernameBackground addSubview:usernameLabel];
					
					UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 155, 18)];
					[locationLabel setText:photo.photoLocation];
					[locationLabel setTextAlignment:UITextAlignmentCenter];
					[locationLabel setAdjustsFontSizeToFitWidth:YES];
					[locationLabel setMinimumFontSize:10];
					[locationLabel setTextColor:[UIColor whiteColor]];
					[locationLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
					[locationLabel setBackgroundColor:[UIColor clearColor]];
					[locationBackground addSubview:locationLabel];
					
					UILabel *captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 2, 192, 18)];
					[captionLabel setText:photo.photoCaption];
					[captionLabel setTextAlignment:UITextAlignmentLeft];
					[captionLabel setAdjustsFontSizeToFitWidth:YES];
					[captionLabel setMinimumFontSize:10];
					[captionLabel setTextColor:[UIColor blackColor]];
					[captionLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
					[captionLabel setBackgroundColor:[UIColor clearColor]];
					[imageDetailsBackground addSubview:captionLabel];
					
					NSArray *photoTags = [NSArray arrayWithArray:photo.photoTags];
					NSMutableSet *tagsSet = [NSMutableSet setWithArray:photoTags];
					LGTag *tag = [tagsSet anyObject];
					UILabel *tagsLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 2, 75, 18)];
					[tagsLabel setText:[NSString stringWithFormat:@"# %@",tag.tag]];
					[tagsLabel setTextAlignment:UITextAlignmentRight];
					[tagsLabel setAdjustsFontSizeToFitWidth:YES];
					[tagsLabel setMinimumFontSize:10];
					[tagsLabel setTextColor:[UIColor blueColor]];
					[tagsLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
					[tagsLabel setBackgroundColor:[UIColor clearColor]];
					[imageDetailsBackground addSubview:captionLabel];
					[imageDetailsBackground addSubview:tagsLabel];
					
					[photoView addSubview:uploadDateBackground];
					[photoView addSubview:usernameBackground];
					[photoView addSubview:locationBackground];
					[photoView addSubview:imageDetailsBackground];
					
					/************************MEMORY FIX HERE***************************/
					[uploadDateLabel release];
					[usernameLabel release];
					[locationLabel release];
					[captionLabel release];
					[tagsLabel release];
					[uploadDateBackground release];
					[usernameBackground release];
					[locationBackground release];
					[imageDetailsBackground release];
					/************************MEMORY FIX HERE***************************/
					
					[liveStreamScrollView addSubview:photoView];
					[visibleLiveStreamItems addObject:photoView];
				}
			}
		}
		else {
			
		}
	}
}

- (void)redrawAllItemsToLiveStream {
	if (currentLiveStreamMode == kLiveStreamModeLarge) {
		[visibleLiveStreamItems removeAllObjects];
		
		for (UIView *subview in liveStreamScrollView.subviews) {
			[subview removeFromSuperview];
		}
		
		int firstIndexVisibleInStream = [self liveStreamItemsCurrentlyInView:@"first"];
		int lastIndexVisibleInStream = [self liveStreamItemsCurrentlyInView:@"last"];
		for (int i = firstIndexVisibleInStream; i <= lastIndexVisibleInStream; i++) {
			if (![self isDisplayingItemForIndex:i]) {
				LGPhotoView *photoView = [self dequeueRecycledLiveStreamView];
				if (photoView == nil) {
					photoView = [[[LGPhotoView alloc] init] autorelease];
				}
				photoView = [self configureItem:photoView forIndex:i];
				[photoView setUserInteractionEnabled:YES];
				[photoView setDelegate:self];
				
				LGPhoto *photo = [liveStreamObjects objectAtIndex:i];
				
				//Add in subviews
				UIImageView *uploadDateBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"single_image_location_bg.png"]];
				[uploadDateBackground setFrame:CGRectMake(5, 7, 97, 18)];
				[uploadDateBackground setAlpha:0.7];
				
				UIImageView *usernameBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"single_image_location_bg.png"]];
				[usernameBackground setFrame:CGRectMake(199, 7, 88, 18)];
				[usernameBackground setAlpha:0.7];
				
				UIImageView *locationBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"single_image_location_bg.png"]];
				[locationBackground setFrame:CGRectMake(77, 311, 155, 18)];
				[locationBackground setAlpha:0.7];
				
				UIImageView *imageDetailsBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"single_image_caption_bg.png"]];
				[imageDetailsBackground setFrame:CGRectMake(5, 332, 280, 23)];
				[imageDetailsBackground setAlpha:0.9];
				
				UILabel *uploadDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 97, 18)];
				[uploadDateLabel setText:[applicationAPI getTimeSinceMySQLDate:photo.photoDateAdded]];
				[uploadDateLabel setTextAlignment:UITextAlignmentCenter];
				[uploadDateLabel setAdjustsFontSizeToFitWidth:YES];
				[uploadDateLabel setMinimumFontSize:10];
				[uploadDateLabel setTextColor:[UIColor whiteColor]];
				[uploadDateLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
				[uploadDateLabel setBackgroundColor:[UIColor clearColor]];
				[uploadDateBackground addSubview:uploadDateLabel];
				
				LGUser *user = photoView.photo.photoUser;
				UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 88, 18)];
				[usernameLabel setText:user.username];
				[usernameLabel setTextAlignment:UITextAlignmentCenter];
				[usernameLabel setAdjustsFontSizeToFitWidth:YES];
				[usernameLabel setMinimumFontSize:10];
				[usernameLabel setTextColor:[UIColor whiteColor]];
				[usernameLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
				[usernameLabel setBackgroundColor:[UIColor clearColor]];
				[usernameBackground addSubview:usernameLabel];
				
				UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 155, 18)];
				[locationLabel setText:photo.photoLocation];
				[locationLabel setTextAlignment:UITextAlignmentCenter];
				[locationLabel setAdjustsFontSizeToFitWidth:YES];
				[locationLabel setMinimumFontSize:10];
				[locationLabel setTextColor:[UIColor whiteColor]];
				[locationLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
				[locationLabel setBackgroundColor:[UIColor clearColor]];
				[locationBackground addSubview:locationLabel];
				
				UILabel *captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 2, 192, 18)];
				[captionLabel setText:photo.photoCaption];
				[captionLabel setTextAlignment:UITextAlignmentLeft];
				[captionLabel setAdjustsFontSizeToFitWidth:YES];
				[captionLabel setMinimumFontSize:10];
				[captionLabel setTextColor:[UIColor blackColor]];
				[captionLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
				[captionLabel setBackgroundColor:[UIColor clearColor]];
				[imageDetailsBackground addSubview:captionLabel];
				
				NSArray *photoTags = [NSArray arrayWithArray:photo.photoTags];
				NSMutableSet *tagsSet = [NSMutableSet setWithArray:photoTags];
				LGTag *tag = [tagsSet anyObject];
				UILabel *tagsLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 2, 75, 18)];
				[tagsLabel setText:[NSString stringWithFormat:@"# %@",tag.tag]];
				[tagsLabel setTextAlignment:UITextAlignmentRight];
				[tagsLabel setAdjustsFontSizeToFitWidth:YES];
				[tagsLabel setMinimumFontSize:10];
				[tagsLabel setTextColor:[UIColor blueColor]];
				[tagsLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
				[tagsLabel setBackgroundColor:[UIColor clearColor]];
				[imageDetailsBackground addSubview:captionLabel];
				[imageDetailsBackground addSubview:tagsLabel];
				
				[photoView addSubview:uploadDateBackground];
				[photoView addSubview:usernameBackground];
				[photoView addSubview:locationBackground];
				[photoView addSubview:imageDetailsBackground];
				
				/************************MEMORY FIX HERE***************************/
				[uploadDateLabel release];
				[usernameLabel release];
				[locationLabel release];
				[captionLabel release];
				[tagsLabel release];
				[uploadDateBackground release];
				[usernameBackground release];
				[locationBackground release];
				[imageDetailsBackground release];
				/************************MEMORY FIX HERE***************************/
				
				[liveStreamScrollView addSubview:photoView];
				[visibleLiveStreamItems addObject:photoView];
			}
		}
	}
	else if (currentLiveStreamMode == kLiveStreamModeIcons) {
		[visibleLiveStreamItems removeAllObjects];
		
		for (UIView *subview in liveStreamScrollView.subviews) {
			[subview removeFromSuperview];
		}
		
		int firstIndexVisibleInStream = [self liveStreamItemsCurrentlyInView:@"first"];
		int lastIndexVisibleInStream = [self liveStreamItemsCurrentlyInView:@"last"];
		for (int i = firstIndexVisibleInStream; i <= lastIndexVisibleInStream; i++) {
			if (![self isDisplayingItemForIndex:i]) {
				LGPhotoView *photoView = [self dequeueRecycledLiveStreamView];
				if (photoView == nil) {
					photoView = [[[LGPhotoView alloc] init] autorelease];
				}
				photoView = [self configureItem:photoView forIndex:i];
				[photoView setUserInteractionEnabled:YES];
				[photoView setDelegate:self];
				
				LGPhoto *photo = [liveStreamObjects objectAtIndex:i];
				
				//Add in subviews
				UIImageView *uploadDateBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"single_image_location_bg.png"]];
				[uploadDateBackground setFrame:CGRectMake(12, 105, 100, 20)];
				[uploadDateBackground setAlpha:0.65];
				
				UILabel *uploadDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
				[uploadDateLabel setText:[applicationAPI getTimeSinceMySQLDate:photo.photoDateAdded]];
				[uploadDateLabel setTextAlignment:UITextAlignmentCenter];
				[uploadDateLabel setAdjustsFontSizeToFitWidth:YES];
				[uploadDateLabel setMinimumFontSize:10];
				[uploadDateLabel setTextColor:[UIColor whiteColor]];
				[uploadDateLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
				[uploadDateLabel setBackgroundColor:[UIColor clearColor]];
				[uploadDateBackground addSubview:uploadDateLabel];
				
				[photoView addSubview:uploadDateBackground];
				
				/************************MEMORY FIX HERE***************************/
				[uploadDateLabel release];
				[uploadDateBackground release];
				/************************MEMORY FIX HERE***************************/
				
				[liveStreamScrollView addSubview:photoView];
				[visibleLiveStreamItems addObject:photoView];
			}
		}
	}

}

- (LGPhotoView *)dequeueRecycledLiveStreamView {
	LGPhotoView *photoView = [recycledLiveStreamItems anyObject];
	if (photoView) {
		[[photoView retain] autorelease];
		[recycledLiveStreamItems removeObject:photoView];
	}
	return photoView;
}

- (LGPhotoView *)configureItem:(LGPhotoView *)item forIndex:(int)index {
	LGPhoto *photo = [liveStreamObjects objectAtIndex:index];
	LGPhotoView *photoView = [[LGPhotoView alloc] initWithImage:[UIImage imageWithContentsOfFile:photo.photoFilepath]];
	photoView.frame = [self getRectForItemInLiveStream:index];
	[photoView setPhoto:photo];
	photoView.index = index;
	return [photoView autorelease];
}

- (void)updateLiveStreamPhotos {
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	HUD.delegate = self;
	HUD.labelText = @"Loading";
	HUD.detailsLabelText = @"Retrieving LiveStream";
	//[HUD showWhileExecuting:@selector(downloadNewLiveStreamPhotos) onTarget:self withObject:nil animated:YES];
	[self downloadNewLiveStreamPhotos];
}

- (int)numberOfImagesForStream {
	return [liveStreamObjects count];
}

- (BOOL)isDisplayingItemForIndex:(int)index {
	BOOL foundCell = NO;
	for (LGPhotoView *photoView in visibleLiveStreamItems) {
		if (photoView.index == index) {
			foundCell = YES;
			break;
		}
	}
	return foundCell;
}

- (int)liveStreamItemsCurrentlyInView:(NSString *)index {
	int returnVal = 0;
	
	if (currentLiveStreamMode == kLiveStreamModeIcons) {
		NSMutableArray *arrayOfCellsInView = [NSMutableArray new];
		int firstIndex = 0;
		int lastIndex = 0;
		
		int numRows = 3;
		int numCols = 0;
		
		for (int i = 0; i < [self numberOfImagesForStream]; i++) {
			int row = i % numRows;
			
			if(row == 0)
			{
				numCols += 1;
			}
		}
		
		int contentSizeWidth = ((kLiveStreamPreviewImageWidth + 5) * numCols);
		int contentSizeHeight = kLiveStreamPreviewImageHeight + kLiveStreamPreviewVerticalPadding;
		[liveStreamScrollView setContentSize:CGSizeMake(contentSizeWidth, contentSizeHeight)];
		CGRect visibleBoundsOfView = liveStreamScrollView.bounds;
		
		for (int i = 0; i < [self numberOfImagesForStream]; i++) {
			int row = i % numRows;
			int col = i / numRows;
			
			if(row == 0)
			{
				CGRect rect = CGRectMake(((kLiveStreamPreviewImageWidth + kLiveStreamPreviewHorizontalPadding) * col), kLiveStreamPreviewStartPoint_Y, kLiveStreamPreviewImageWidth, kLiveStreamPreviewImageHeight);
				if (CGRectContainsRect(visibleBoundsOfView, rect)) {
					int indexNum = photoIndex(row, col);
					[arrayOfCellsInView addObject:[NSNumber numberWithInt:indexNum]];
				}
			}
			else if(row == 1) {
				CGRect rect = CGRectMake(((kLiveStreamPreviewImageWidth + kLiveStreamPreviewHorizontalPadding) * col), kLiveStreamPreviewMidStartPoint_Y, kLiveStreamPreviewImageWidth, kLiveStreamPreviewImageHeight);
				if (CGRectContainsRect(visibleBoundsOfView, rect)) {
					int indexNum = photoIndex(row, col);
					[arrayOfCellsInView addObject:[NSNumber numberWithInt:indexNum]];
				}
			}
			else if(row == 2) {
				CGRect rect = CGRectMake(((kLiveStreamPreviewImageWidth + kLiveStreamPreviewHorizontalPadding) * col), kLiveStreamPreviewBottomStartPoint_Y, kLiveStreamPreviewImageWidth, kLiveStreamPreviewImageHeight);
				if (CGRectContainsRect(visibleBoundsOfView, rect)) {
					int indexNum = photoIndex(row, col);
					[arrayOfCellsInView addObject:[NSNumber numberWithInt:indexNum]];
				}
			}
		}
		
		firstIndex = [[arrayOfCellsInView lastObject] intValue];
		lastIndex = [[arrayOfCellsInView lastObject] intValue];
		
		for (int i =0; i < [arrayOfCellsInView count]; i++) {		
			if ([[arrayOfCellsInView objectAtIndex:i] intValue] < firstIndex) {
				firstIndex = [[arrayOfCellsInView objectAtIndex:i] intValue];
			}
			if([[arrayOfCellsInView objectAtIndex:i] intValue] > lastIndex) {
				lastIndex = [[arrayOfCellsInView objectAtIndex:i] intValue];
			}
		}
		
		/************************MEMORY FIX HERE***************************/
		[arrayOfCellsInView release];
		/************************MEMORY FIX HERE***************************/
		
		if ((firstIndex - 3) > 0 || (firstIndex - 3) == 0) {
			firstIndex -= 3;
		}
		else if ((firstIndex - 2) > 0 || (firstIndex - 2) == 0) {
			firstIndex -= 2;
		}
		else if ((firstIndex - 1) > 0 || (firstIndex - 1) == 0) {
			firstIndex -= 1;
		}
		
		if ((lastIndex + 3) <= ([self numberOfImagesForStream] - 1)) {
			lastIndex += 3;
		}
		else if ((lastIndex + 2) <= ([self numberOfImagesForStream] - 1)) {
			lastIndex += 2;
		}
		else if ((lastIndex + 1) <= ([self numberOfImagesForStream] - 1)) {
			lastIndex += 1;
		}
				
		if ([index isEqualToString:@"first"]) {
			returnVal = firstIndex;
		}
		else if([index isEqualToString:@"last"]) {
			returnVal = lastIndex;
		}
		else {
			returnVal = -1;
		}
	}
	else if (currentLiveStreamMode == kLiveStreamModeLarge) {
		NSMutableArray *arrayOfCellsInView = [NSMutableArray new];
		int firstIndex = 0;
		int lastIndex = 0;
		
		int numRows = 1;
		int numCols = 0;
		
		for (int i = 0; i < [self numberOfImagesForStream]; i++) {
			int row = i % numRows;
			
			if(row == 0)
			{
				numCols += 1;
			}
		}
		
		int contentSizeHeight = kLiveStreamPreviewStaticHeight;
		int contentSizeWidth = (((kLiveStreamImageWidth + kLiveStreamHorizontalPadding) * numCols) + (3 * kLiveStreamHorizontalPadding));
		[liveStreamScrollView setContentSize:CGSizeMake(contentSizeWidth, contentSizeHeight)];
		CGRect visibleBoundsOfView = liveStreamScrollView.bounds;
		
		for (int i = 0; i < [self numberOfImagesForStream]; i++) {
			int row = i % numRows;
			int col = i / numRows;
			
			if(row == 0)
			{
				CGRect rect = CGRectMake((((kLiveStreamImageWidth + kLiveStreamHorizontalPadding) * col) + (2* kLiveStreamHorizontalPadding)), kLiveStreamStartPoint_Y, kLiveStreamImageWidth, kLiveStreamImageHeight);				
				if (CGRectIntersectsRect(visibleBoundsOfView, rect)) {
					int indexNum = largePhotoIndex(row, col);
					[arrayOfCellsInView addObject:[NSNumber numberWithInt:indexNum]];
				}
			}
		}
		
		firstIndex = [[arrayOfCellsInView lastObject] intValue];
		lastIndex = [[arrayOfCellsInView lastObject] intValue];
		
		for (int i =0; i < [arrayOfCellsInView count]; i++) {		
			if ([[arrayOfCellsInView objectAtIndex:i] intValue] < firstIndex) {
				firstIndex = [[arrayOfCellsInView objectAtIndex:i] intValue];
			}
			if([[arrayOfCellsInView objectAtIndex:i] intValue] > lastIndex) {
				lastIndex = [[arrayOfCellsInView objectAtIndex:i] intValue];
			}
		}
		
		/************************MEMORY FIX HERE***************************/
		[arrayOfCellsInView release];
		/************************MEMORY FIX HERE***************************/
		
		if ((firstIndex - 1) > 0 || (firstIndex - 1) == 0) {
			firstIndex -= 1;
		}
		
		if ((lastIndex + 1) <= ([self numberOfImagesForStream] - 1)) {
			lastIndex += 1;
		}
		
		if ([index isEqualToString:@"first"]) {
			returnVal = firstIndex;
		}
		else if([index isEqualToString:@"last"]) {
			returnVal = lastIndex;
		}
		else {
			returnVal = -1;
		}
	}
	
	return returnVal;
}

- (CGRect)getRectForItemInLiveStream:(int)index {
	CGRect itemRect;
	
	if (currentLiveStreamMode == kLiveStreamModeIcons) {
		int numRows = 3;
		int numCols = 0;
		
		for (int i = 0; i < [self numberOfImagesForStream]; i++) {
			int row = i % numRows;
			
			if(row == 0)
			{
				numCols += 1;
			}
		}
		
		for (int i = 0; i < [self numberOfImagesForStream]; i++) {
			int row = i % numRows;
			int col = i / numRows;
			
			if(photoIndex(row, col) == index) 
			{
				if(row == 0)
				{
					itemRect = CGRectMake(((kLiveStreamPreviewImageWidth + kLiveStreamPreviewHorizontalPadding) * col), kLiveStreamPreviewStartPoint_Y, kLiveStreamPreviewImageWidth, kLiveStreamPreviewImageHeight);
				}
				else if(row == 1) {
					itemRect = CGRectMake(((kLiveStreamPreviewImageWidth + kLiveStreamPreviewHorizontalPadding) * col), kLiveStreamPreviewMidStartPoint_Y, kLiveStreamPreviewImageWidth, kLiveStreamPreviewImageHeight);
				}
				else if(row == 2) {
					itemRect = CGRectMake(((kLiveStreamPreviewImageWidth + kLiveStreamPreviewHorizontalPadding) * col), kLiveStreamPreviewBottomStartPoint_Y, kLiveStreamPreviewImageWidth, kLiveStreamPreviewImageHeight);
				}
				
				break;
			}
		}		
	}
	else if (currentLiveStreamMode == kLiveStreamModeLarge) {
		int numRows = 1;
		int numCols = 0;
		
		for (int i = 0; i < [self numberOfImagesForStream]; i++) {
			int row = i % numRows;
			
			if(row == 0)
			{
				numCols += 1;
			}
		}
		
		for (int i = 0; i < [self numberOfImagesForStream]; i++) {
			int row = i % numRows;
			int col = i / numRows;
						
			if (largePhotoIndex(row, col) == index) {
				if(row == 0)
				{
					itemRect = CGRectMake((((kLiveStreamImageWidth + kLiveStreamHorizontalPadding) * col) + (2* kLiveStreamHorizontalPadding)), kLiveStreamStartPoint_Y, kLiveStreamImageWidth, kLiveStreamImageHeight);
				}
				
				break;
			}
		}
	}
	
	return itemRect;
	
}

- (void)photoViewWasTouchedWithID:(int)imgID andIndex:(int)imgIndex {
	if (currentLiveStreamMode == kLiveStreamModeIcons) {		
		currentLiveStreamMode = kLiveStreamModeLarge;
		//[self drawItemsToLiveStream];
		[self redrawAllItemsToLiveStream];
		CGRect rect = [self getRectForItemInLiveStream:imgIndex];
		[liveStreamScrollView setContentOffset:CGPointMake((rect.origin.x - (2 * kLiveStreamHorizontalPadding)), liveStreamScrollView.contentOffset.y) animated:NO];
		[self redrawAllItemsToLiveStream];
	}
	else if (currentLiveStreamMode == kLiveStreamModeLarge) {
		LGPhotoView *photoview = [liveStreamObjectViews objectAtIndex:imgIndex];
		LGPhoto *photo = photoview.photo;
		[applicationAPI reverseGeocodeCoordinatesWithLatitude:photo.photoLocationLatitude andLongitude:photo.photoLocationLongitude];
	}
}

- (void)photoLocationLabelWasTouchedWithID:(int)imgID andIndex:(int)imgIndex {
	LGPhotoView *photoViewForFlipping;
	for (LGPhotoView *photoView in visibleLiveStreamItems) {
		if (photoView.photo.photoID == imgID) {
			photoViewForFlipping = photoView;
			break;
		}
	}
	LGPhoto *photoInformation = [liveStreamObjects objectAtIndex:imgIndex];
	
	CLLocationCoordinate2D photoCoord = CLLocationCoordinate2DMake([photoInformation.photoLocationLatitude floatValue], [photoInformation.photoLocationLongitude floatValue]);		
	
	MKMapView *mapView = [[MKMapView alloc] init];
	[mapView setFrame:photoViewForFlipping.frame];
	
	[mapView setRegion:MKCoordinateRegionMake(photoCoord, MKCoordinateSpanMake(1, 1)) animated:NO];
	UIButton *doneButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	[doneButton setFrame:CGRectMake(205, 315, 72, 37)];
	[doneButton setTitle:@"Done" forState:UIControlStateNormal];
	[doneButton setAlpha:0.8];
	[doneButton setUserInteractionEnabled:YES];
	[doneButton addTarget:self action:@selector(doneViewingImageMap:) forControlEvents:UIControlEventTouchUpInside];
	[doneButton setTag:photoViewForFlipping.photo.photoID];
	[mapView addSubview:doneButton];
	[doneButton release];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:2.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:photoViewForFlipping cache:YES];
	[photoViewForFlipping removeFromSuperview];
	[liveStreamScrollView addSubview:mapView];
	[UIView commitAnimations];
		
	/************************MEMORY FIX HERE***************************/
	[mapView release];
	/************************MEMORY FIX HERE***************************/
}
	 
- (void)doneViewingImageMap:(id)sender {
	//[self redrawAllItemsToLiveStream];
	NSLog(@"%d", [sender tag]);
}

- (int)largeImageCurrentlyMostDisplayed {
	int firstIndex = [self liveStreamItemsCurrentlyInView:@"first"];
	int lastIndex = [self liveStreamItemsCurrentlyInView:@"last"];
	int indexDifference = ((lastIndex - firstIndex) + 1);
	
	NSLog(@"%d", indexDifference);
	
	int indexVisible = 0;
	
	switch (indexDifference) {
		case 3:
			if (CGRectIntersectsRect([liveStreamScrollView bounds], [self getRectForItemInLiveStream:lastIndex])) {
				firstIndex += 1;
				
				CGRect firstRect = [self getRectForItemInLiveStream:firstIndex];
				CGRect lastRect = [self getRectForItemInLiveStream:lastIndex];
				CGRect liveStreamVisibleBounds = [liveStreamScrollView bounds];
				int liveStreamEndX = liveStreamVisibleBounds.origin.x + 320;
				int firstDiff = liveStreamVisibleBounds.origin.x - firstRect.origin.x;
				
				int first = kLiveStreamImageWidth - firstDiff;
				int last = liveStreamEndX - lastRect.origin.x;
				
				if (first > last) {
					indexVisible = firstIndex;
				}
				else if (last > first) {
					indexVisible = lastIndex;
				}
				else if (first == last) {
					indexVisible = lastIndex;
				}
			}
			else if (CGRectIntersectsRect([liveStreamScrollView bounds], [self getRectForItemInLiveStream:firstIndex])) {
				lastIndex -= 1;
				
				CGRect firstRect = [self getRectForItemInLiveStream:firstIndex];
				CGRect lastRect = [self getRectForItemInLiveStream:lastIndex];
				CGRect liveStreamVisibleBounds = [liveStreamScrollView bounds];
				int liveStreamEndX = liveStreamVisibleBounds.origin.x + 320;
				int firstDiff = liveStreamVisibleBounds.origin.x - firstRect.origin.x;
				
				int first = kLiveStreamImageWidth - firstDiff;
				int last = liveStreamEndX - lastRect.origin.x;
				
				if (first > last) {
					indexVisible = firstIndex;
				}
				else if (last > first) {
					indexVisible = lastIndex;
				}
				else if (first == last) {
					indexVisible = lastIndex;
				}
			}
			break;
		case 4:
			firstIndex += 1;
			lastIndex -= 1;
			
			CGRect firstRect = [self getRectForItemInLiveStream:firstIndex];
			CGRect lastRect = [self getRectForItemInLiveStream:lastIndex];
			CGRect liveStreamVisibleBounds = [liveStreamScrollView bounds];
			int liveStreamEndX = liveStreamVisibleBounds.origin.x + 320;
			int firstDiff = liveStreamVisibleBounds.origin.x - firstRect.origin.x;
			
			int first = kLiveStreamImageWidth - firstDiff;
			int last = liveStreamEndX - lastRect.origin.x;
			
			if (first > last) {
				indexVisible = firstIndex;
			}
			else if (last > first) {
				indexVisible = lastIndex;
			}
			else if (first == last) {
				indexVisible = lastIndex;
			}			
			break;
		case 5:
			indexVisible = lastIndex - 2;
			break;
		default:
			break;
	}
	
	return indexVisible;
}

- (void)downloadNewLiveStreamPhotos; {
	NSMutableArray *liveStreamArray = [NSMutableArray arrayWithArray:[applicationAPI getLiveFeed:50]];
	
	if(!networkQueue) {
		networkQueue = [[ASINetworkQueue alloc] init];
	}
	[networkQueue reset];
	[networkQueue setRequestDidFinishSelector:@selector(imageFetchComplete:)];
	[networkQueue setShowAccurateProgress:YES];
	[networkQueue setDelegate:self];
	
	for (int i = 0; i < [liveStreamArray count]; i++) {
		LGPhoto *photo = [liveStreamArray objectAtIndex:i];
		
		ASIHTTPRequest *request;
		
		if ([applicationAPI deviceRequiresHighResPhotos]) {
			request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://projc:pr0j(@dev.livegather.com/api/photos/%d/iOS_retina/m", photo.photoID]]];
		}
		else {
			request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://projc:pr0j(@dev.livegather.com/api/photos/%d/iOS/m", photo.photoID]]];
		}
		
		[request setDownloadDestinationPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%dM.jpg", photo.photoID]]];
		
		if ([applicationAPI imageFileCacheExistsInSQLWithID:photo.photoID forSize:@"m"]) {
			LGPhoto *img = [[LGPhoto alloc] init];
			
			[img setPhotoFilepath:[applicationAPI getFilePathForCachedImageWithID:photo.photoID andSize:@"m"]];
			[img setPhotoID:photo.photoID];
			LGPhotoView *photoView = [[LGPhotoView alloc] init];
			[photoView setPhoto:photo];
			[photoView setIndex:photo.photoIndex];
			
			[liveStreamObjects addObject:img];
			[liveStreamObjectViews addObject:photoView];
			
			[self drawItemsToLiveStream];
			
			/************************MEMORY FIX HERE***************************/
			[img release];
			[photoView release];
			/************************MEMORY FIX HERE***************************/
		}
		else {
			[applicationAPI addImageFileToCacheWithID:photo.photoID andFilePath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%dM.jpg", photo.photoID]] andImageSize:@"m"];
			[networkQueue addOperation:request];
		}
	}
	[networkQueue go];	
}

- (void)imageFetchComplete:(ASIHTTPRequest *)request {
	if(networkQueue.requestsCount == 0)
	{
		if (request) {
			NSString *photoID = [[NSString stringWithFormat:@"%@", [request originalURL]] stringByReplacingOccurrencesOfString:@"http://projc:pr0j(@dev.livegather.com/api/photos/" withString:@""];
			
			LGPhoto *photo = [[LGPhoto alloc] init];
			
			[photo setPhotoFilepath:[applicationAPI getFilePathForCachedImageWithID:[photoID intValue] andSize:@"m"]];
			[photo setPhotoID:[photoID intValue]];
			[photo setPhotoIndex:[liveStreamObjects count]];
			
			LGPhotoView *photoView = [[LGPhotoView alloc] init];
			[photoView setPhoto:photo];
			[photoView setIndex:photo.photoIndex];
			
			[liveStreamObjects addObject:photo];
			[liveStreamObjectViews addObject:photoView];
			
			/************************MEMORY FIX HERE***************************/
			[photo release];
			[photoView release];
			/************************MEMORY FIX HERE***************************/
		}
		
		[self drawItemsToLiveStream];
	}
	else {			
		NSString *photoID = [[NSString stringWithFormat:@"%@", [request originalURL]] stringByReplacingOccurrencesOfString:@"http://projc:pr0j(@dev.livegather.com/api/photos/" withString:@""];
		
		LGPhoto *photo = [[LGPhoto alloc] init];
		
		[photo setPhotoFilepath:[applicationAPI getFilePathForCachedImageWithID:[photoID intValue] andSize:@"m"]];
		[photo setPhotoID:[photoID intValue]];
		
		LGPhotoView *photoView = [[LGPhotoView alloc] init];
		[photoView setPhoto:photo];
		[photo setPhotoIndex:[liveStreamObjects count]];
		[photoView setIndex:photo.photoIndex];
		
		[liveStreamObjectViews addObject:photoView];
		[liveStreamObjects addObject:photo];
		
		/************************MEMORY FIX HERE***************************/
		[photoView release];
		[photo release];
		/************************MEMORY FIX HERE***************************/
	}
}

- (void)imageDownloadingFinished {
	
}

- (IBAction)refreshLiveStream {
	
}

- (void)refreshComplete:(ASIHTTPRequest *)request {
	
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (currentLiveStreamMode == kLiveStreamModeIcons) {
		[self drawItemsToLiveStream];
	}
	else if (currentLiveStreamMode == kLiveStreamModeLarge) {
		[self drawItemsToLiveStream];
	}
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	if (currentLiveStreamMode == kLiveStreamModeLarge) {
		int visibleIndex = [self largeImageCurrentlyMostDisplayed];
		CGRect visibleRect = [self getRectForItemInLiveStream:visibleIndex];
		[liveStreamScrollView setContentOffset:CGPointMake((visibleRect.origin.x - (2 * kLiveStreamHorizontalPadding)), liveStreamScrollView.contentOffset.y) animated:YES];
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	
}

- (IBAction)searchLiveSteam {
	
}

- (IBAction)goHome {
	if (currentLiveStreamMode == kLiveStreamModeIcons) {
		mainViewController = [[MainViewController alloc] init];
		[mainViewController drawItemsToLiveStream];
		[[self parentViewController] dismissModalViewControllerAnimated:YES];
		[mainViewController release];
	}
	else {
		[self redrawAllItemsToLiveStream];
		int currentItemInView = [self liveStreamItemsCurrentlyInView:@"first"];
		currentLiveStreamMode = kLiveStreamModeIcons;
		[self redrawAllItemsToLiveStream];
		CGRect rect = [self getRectForItemInLiveStream:currentItemInView];
		[liveStreamScrollView setContentOffset:CGPointMake((rect.origin.x - kLiveStreamPreviewHorizontalPadding), liveStreamScrollView.contentOffset.y) animated:NO];
		[self redrawAllItemsToLiveStream];
	}

}

- (void)hudWasHidden {
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 

- (void)didReceiveMemoryWarning {
	NSLog(@"Received Memory Warning");
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
	[visibleLiveStreamItems dealloc];
	[recycledLiveStreamItems dealloc];
	[liveStreamScrollView dealloc];
	[liveStreamObjects dealloc];
	[liveStreamObjectViews dealloc];
}


@end
