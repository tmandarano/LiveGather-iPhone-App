//
//  LiveStreamViewController.m
//  LiveGather
//
//  Created by Alexander on 4/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LiveStreamViewController.h"


@implementation LiveStreamViewController

@synthesize liveStreamScrollView;

#define kLiveStreamPreviewStartPoint_X 5
#define kLiveStreamPreviewStartPoint_Y 5
#define kLiveStreamPreviewMidStartPoint_X 5
#define kLiveStreamPreviewMidStartPoint_Y 142
#define kLiveStreamPreviewBottomStartPoint_X 5
#define kLiveStreamPreviewBottomStartPoint_Y 279
#define kLiveStreamPreviewVerticalPadding 2
#define kLiveStreamPreviewHorizontalPadding 2
#define kLiveStreamPreviewImageWidth 125
#define kLiveStreamPreviewImageHeight 129
#define kLiveStreamPreviewStaticHeight 415

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	applicationAPI = [[LiveGatherAPI alloc] init];
	//streamArray = [NSMutableArray new];
	//streamContainersArray = [NSMutableArray new];
	
	liveStreamScrollView = [[CollageView alloc] initWithFrame:CGRectMake(0, 45, 320, 415)];
	[liveStreamScrollView setBackgroundColor:[UIColor blackColor]];
	[liveStreamScrollView setDelegate:self];
	
	if(!liveStreamObjects) liveStreamObjects = [NSMutableArray new];
	if(!liveStreamObjectViews) liveStreamObjectViews = [NSMutableArray new];
	
	if (!visibleLiveStreamItems) visibleLiveStreamItems = [[NSMutableSet alloc] init];
	if (!recycledLiveStreamItems) recycledLiveStreamItems = [[NSMutableSet alloc] init];
	
	[self.view addSubview:liveStreamScrollView];
	[self updateLiveStreamPhotos];
	
	[super viewDidLoad];
}

//Custom Method

- (void)drawItemsToLiveStream {
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
				[liveStreamScrollView addSubview:photoView];
				[visibleLiveStreamItems addObject:photoView];
			}
		}
	}
	else {
		//[self downloadNewLiveStreamPhotos];
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
				int indexNum = ((2 * col) + row);
				[arrayOfCellsInView addObject:[NSNumber numberWithInt:indexNum]];
			}
		}
		else if(row == 1) {
			CGRect rect = CGRectMake(((kLiveStreamPreviewImageWidth + kLiveStreamPreviewHorizontalPadding) * col), kLiveStreamPreviewMidStartPoint_Y, kLiveStreamPreviewImageWidth, kLiveStreamPreviewImageHeight);
			if (CGRectContainsRect(visibleBoundsOfView, rect)) {
				int indexNum = ((2 * col) + row);
				[arrayOfCellsInView addObject:[NSNumber numberWithInt:indexNum]];
			}
		}
		else if(row == 2) {
			CGRect rect = CGRectMake(((kLiveStreamPreviewImageWidth + kLiveStreamPreviewHorizontalPadding) * col), kLiveStreamPreviewBottomStartPoint_Y, kLiveStreamPreviewImageWidth, kLiveStreamPreviewImageHeight);
			if (CGRectContainsRect(visibleBoundsOfView, rect)) {
				int indexNum = ((2 * col) + row);
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
	
	if ((firstIndex - 2) > 0 || (firstIndex - 2) == 0) {
		firstIndex -= 2;
	}
	
	if ((lastIndex + 2) <= ([self numberOfImagesForStream] - 1)) {
		lastIndex += 2;
	}
	else if ((lastIndex + 1) <= ([self numberOfImagesForStream] - 1)) {
		lastIndex += 1;
	}
	
	int returnVal = 0;
	
	if ([index isEqualToString:@"first"]) {
		returnVal = firstIndex;
	}
	else if([index isEqualToString:@"last"]) {
		returnVal = lastIndex;
	}
	else {
		returnVal = -1;
	}
	
	return returnVal;
}

- (CGRect)getRectForItemInLiveStream:(int)index {
	CGRect itemRect;
	
	int numRows = 3;
	int numCols = 0;
	
	for (int i = 0; i <= [self numberOfImagesForStream]; i++) {
		int row = i % numRows;
		
		if(row == 0)
		{
			numCols += 1;
		}
	}
	
	for (int i = 0; i <= [self numberOfImagesForStream]; i++) {
		int row = i % numRows;
		int col = i / numRows;
		
		if(((2 * col) + row) == index)
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
	
	return itemRect;
}

- (void)downloadNewLiveStreamPhotos; {
	NSMutableArray *liveStreamArray = [NSMutableArray arrayWithArray:[applicationAPI getLiveFeed:15]];
	
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
			NSLog(@"Alright the image exists");
			LGPhoto *img = [[LGPhoto alloc] initWithContentsOfFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.jpg", photo.photoID]]];
			[img setID:photo.photoID];
			[liveStreamObjects addObject:img];
			NSLog(@"%d", [liveStreamObjects count]);
			[self imageFetchComplete:nil];
		}
	}
	[networkQueue go];
}

- (void)imageFetchComplete:(ASIHTTPRequest *)request {
	if (request == nil) {
		
	}
	
	if(networkQueue.requestsCount == 0)
	{
		if (request) {
			NSString *photoID = [[NSString stringWithFormat:@"%@", [request originalURL]] stringByReplacingOccurrencesOfString:@"http://projc:pr0j(@dev.livegather.com/api/photos/" withString:@""];
			photoID = [[NSString stringWithFormat:@"%@", photoID] stringByReplacingOccurrencesOfString:@"/3" withString:@""];
			LGPhoto *photo = [[LGPhoto alloc] initWithContentsOfFile:[request downloadDestinationPath]];
			[photo setID:[photoID intValue]];
			[photo setPhotoIndex:[liveStreamObjects count]];
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
	NSLog(@"Live: %d", [visibleLiveStreamItems count]);
	NSLog(@"In the recycling bin: %d", [recycledLiveStreamItems count]);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self drawItemsToLiveStream];
}

- (IBAction)searchLiveSteam {
	
}

- (IBAction)goHome {
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}

- (void)hudWasHidden {
	
}

//<!-- Custom Methods


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
