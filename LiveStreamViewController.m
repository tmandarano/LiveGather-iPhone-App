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

//Custom Method

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
				//	LGPhoto *photo = [liveStreamObjects objectAtIndex:i];
				//	NSString *caption = [photo photoCaption];
					
				//	NSLog(@"");
					
					photoView = [self configureItem:photoView forIndex:i];
					[photoView setUserInteractionEnabled:YES];
					[photoView setDelegate:self];
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
				//	LGPhoto *photo = [liveStreamObjects objectAtIndex:i];
				//	NSLog(@"%@", [photo photoCaption]);
					
					photoView = [self configureItem:photoView forIndex:i];
					[photoView setUserInteractionEnabled:YES];
					[photoView setDelegate:self];
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
	[visibleLiveStreamItems removeAllObjects];
	
	for (UIView *vw in liveStreamScrollView.subviews) {
		[vw removeFromSuperview];
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
			[liveStreamScrollView addSubview:photoView];
			[visibleLiveStreamItems addObject:photoView];
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
	LGPhotoView *photoView = [[LGPhotoView alloc] initWithImage:[liveStreamObjects objectAtIndex:index]];
	photoView.frame = [self getRectForItemInLiveStream:index];
	[photoView setPhoto:[liveStreamObjects objectAtIndex:index]];
	photoView.index = index;
	
	return photoView;
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
		/*LGPhotoView *photoView = [liveStreamObjects objectAtIndex:imgIndex];
		[liveStreamScrollView bringSubviewToFront:photoView];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:1.0];
		[photoView setFrame:CGRectMake(kLiveStreamStartPoint_X, kLiveStreamStartPoint_Y, kLiveStreamImageWidth, kLiveStreamImageHeight)];
		[UIView commitAnimations];*/
		
		currentLiveStreamMode = kLiveStreamModeLarge;
		//[self drawItemsToLiveStream];
		[self redrawAllItemsToLiveStream];
		CGRect rect = [self getRectForItemInLiveStream:imgIndex];
		[liveStreamScrollView setContentOffset:CGPointMake((rect.origin.x - (2 * kLiveStreamHorizontalPadding)), liveStreamScrollView.contentOffset.y) animated:NO];
		[self drawItemsToLiveStream];
	}
}

- (void)photoLocationLabelWasTouchedWithID:(int)imgID andIndex:(int)imgIndex {
	
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
	NSMutableArray *liveStreamArray = [NSMutableArray arrayWithArray:[applicationAPI getLiveFeed:25]];
	
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
		request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://projc:pr0j(@dev.livegather.com/api/photos/%d/3", photo.photoID]]];
		[request setDownloadDestinationPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.jpg", photo.photoID]]];
		
		NSFileManager *fileManager = [[NSFileManager alloc] init];
		
		if (![fileManager fileExistsAtPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.jpg", photo.photoID]]]) {
			[networkQueue addOperation:request];
		}
		else {
			LGPhoto *data = [applicationAPI getPhotoForID:photo.photoID];
						
			LGPhoto *img = [[LGPhoto alloc] initWithContentsOfFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.jpg", photo.photoID]]];
			[img setID:photo.photoID];
			[img setPhotoIndex:[liveStreamObjects count]];
			[img setPhotoCaption:[data photoCaption]];
			[img setPhotoUser:[data photoUser]];
			[img setPhotoTags:[data photoTags]];
			[img setPhotoUserID:[data photoUserID]];
			[img setPhotoName:[data photoName]];
			[img setPhotoDateAdded:[data photoDateAdded]];
			
			LGPhotoView *photoView = [[LGPhotoView alloc] init];
			[photoView setPhoto:img];
			[photoView setIndex:img.photoIndex];
			[liveStreamObjects addObject:img];
			[liveStreamObjectViews addObject:photoView];
			[self imageFetchComplete:nil];
		}
	}
	[networkQueue go];	
}

- (void)imageFetchComplete:(ASIHTTPRequest *)request {
	if (request == nil) {
		[self drawItemsToLiveStream];
	}
	
	if(networkQueue.requestsCount == 0)
	{
		if (request) {
			NSString *photoID = [[NSString stringWithFormat:@"%@", [request originalURL]] stringByReplacingOccurrencesOfString:@"http://projc:pr0j(@dev.livegather.com/api/photos/" withString:@""];
			photoID = [[NSString stringWithFormat:@"%@", photoID] stringByReplacingOccurrencesOfString:@"/3" withString:@""];
			LGPhoto *photo = [[LGPhoto alloc] initWithContentsOfFile:[request downloadDestinationPath]];
			[photo setID:[photoID intValue]];
			[photo setPhotoIndex:[liveStreamObjects count]];
			[photo setPhotoCaption:@"WTFMATE"];
			LGPhotoView *photoView = [[LGPhotoView alloc] init];
			[photoView setPhoto:photo];
			[photoView setIndex:photo.photoIndex];
			[liveStreamObjects addObject:photo];
			[liveStreamObjectViews addObject:photoView];
		}
		
		[self drawItemsToLiveStream];
	}
	else {
		NSString *photoID = [[NSString stringWithFormat:@"%@", [request originalURL]] stringByReplacingOccurrencesOfString:@"http://projc:pr0j(@dev.livegather.com/api/photos/" withString:@""];
		photoID = [[NSString stringWithFormat:@"%@", photoID] stringByReplacingOccurrencesOfString:@"/3" withString:@""];
		LGPhoto *photo = [[LGPhoto alloc] initWithContentsOfFile:[request downloadDestinationPath]];
		[photo setID:[photoID intValue]];
		[photo setPhotoCaption:@"WTFMATE"];
		LGPhotoView *photoView = [[LGPhotoView alloc] init];
		[photoView setPhoto:photo];
		[photo setPhotoIndex:[liveStreamObjects count]];
		[photoView setIndex:photo.photoIndex];
		[liveStreamObjectViews addObject:photoView];
		[liveStreamObjects addObject:photo];
	}
}

- (void)imageDownloadingFinished {
	
}

- (IBAction)refreshLiveStream {
	NSLog(@"%d %d", [self liveStreamItemsCurrentlyInView:@"first"],[self liveStreamItemsCurrentlyInView:@"last"]);
	NSLog(@"%f %f", [liveStreamScrollView bounds].origin.x, [liveStreamScrollView bounds].origin.y);
	/*currentLiveStreamMode = kLiveStreamModeLarge;
	
	int numImageViewsToPlace = [self numberOfImagesForStream];
	int numRows = 1;
	int numCols = 0;
	int contentSizeHeight = kLiveStreamPreviewStaticHeight;
	
	for (int i = 0; i < numImageViewsToPlace; i++) {
		int row = i % numRows;
		
		if(row == 0)
		{
			numCols += 1;
		}
	}
	
	int contentSizeWidth = (((kLiveStreamImageWidth + kLiveStreamHorizontalPadding) * numCols) + (3 * kLiveStreamHorizontalPadding));
	
	[liveStreamScrollView setContentSize:CGSizeMake(contentSizeWidth, contentSizeHeight)];
	
	for (int i = 0; i < numImageViewsToPlace; i++) {
		int row = i % numRows;
		int col = i / numRows;
		
		LGPhotoView *photoView = [[LGPhotoView alloc] initWithImage:[UIImage imageNamed:@"gray.jpg"]];
		
		if(row == 0)
		{
			[photoView setFrame:CGRectMake((((kLiveStreamImageWidth + kLiveStreamHorizontalPadding) * col) + (2* kLiveStreamHorizontalPadding)), kLiveStreamStartPoint_Y, kLiveStreamImageWidth, kLiveStreamImageHeight)];
		}
		
		[liveStreamScrollView addSubview:photoView];
	}
		
	/*int numImageViewsToPlace = [self numberOfImagesForStream];
	int numRows = 3;
	int numCols = 0;
	int contentSizeHeight = kLiveStreamPreviewStaticHeight;
	
	for (int i = 0; i < numImageViewsToPlace; i++) {
		int row = i % numRows;
		
		if(row == 0)
		{
			numCols += 1;
		}
	}
	
	int contentSizeWidth = ((kLiveStreamPreviewImageWidth + 2) * numCols);
	
	[liveStreamScrollView setContentSize:CGSizeMake(contentSizeWidth, contentSizeHeight)];
	
	for (int i = 0; i < numImageViewsToPlace; i++) {
		int row = i % numRows;
		int col = i / numRows;
		
		LGPhotoView *photoView = [[LGPhotoView alloc] initWithImage:[UIImage imageNamed:@"gray.jpg"]];
		
		if(row == 0)
		{
			[photoView setFrame:CGRectMake(((kLiveStreamPreviewImageWidth + kLiveStreamPreviewHorizontalPadding) * col), kLiveStreamPreviewStartPoint_Y, kLiveStreamPreviewImageWidth, kLiveStreamPreviewImageHeight)];
		}
		else if(row == 1) {
			[photoView setFrame:CGRectMake(((kLiveStreamPreviewImageWidth + kLiveStreamPreviewHorizontalPadding) * col), kLiveStreamPreviewMidStartPoint_Y, kLiveStreamPreviewImageWidth, kLiveStreamPreviewImageHeight)];
		}
		else if(row == 2) {
			[photoView setFrame:CGRectMake(((kLiveStreamPreviewImageWidth + kLiveStreamPreviewHorizontalPadding) * col), kLiveStreamPreviewBottomStartPoint_Y, kLiveStreamPreviewImageWidth, kLiveStreamPreviewImageHeight)];
		}
		
		[liveStreamScrollView addSubview:photoView];
	}*/
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

- (IBAction)searchLiveSteam {
	
}

- (IBAction)goHome {
	if (currentLiveStreamMode == kLiveStreamModeIcons) {
		[[self parentViewController] dismissModalViewControllerAnimated:YES];
	}
	else {
		[self redrawAllItemsToLiveStream];
		int currentItemInView = [self liveStreamItemsCurrentlyInView:@"first"];
		currentLiveStreamMode = kLiveStreamModeIcons;
		[self drawItemsToLiveStream];
		CGRect rect = [self getRectForItemInLiveStream:currentItemInView];
		[liveStreamScrollView setContentOffset:CGPointMake((rect.origin.x - kLiveStreamPreviewHorizontalPadding), liveStreamScrollView.contentOffset.y) animated:YES];
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
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
