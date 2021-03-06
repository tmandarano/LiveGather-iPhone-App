//
//  MainViewController.m
//  LiveGather
//
//  Created by Alexander on 4/13/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController

@synthesize imagesInMemoryDictionary;

#define miniPhotoIndex(row, col) ((2 * col) + row)
#define kLiveStreamPreviewStartPoint_X 10
#define kLiveStreamPreviewStartPoint_Y 5
#define kLiveStreamPreviewLowerStartPoint_X 10
#define kLiveStreamPreviewLowerStartPoint_Y 70
#define kLiveStreamPreviewVerticalPadding 2
#define kLiveStreamPreviewHorizontalPadding 2
#define kLiveStreamPreviewImageWidth 61
#define kLiveStreamPreviewImageHeight 61
#define kLiveStreamPreviewStaticHeight 149


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
	uploadViewController = [[UploadPhotoViewController alloc] init];
	liveStreamView = [[LiveStreamViewController alloc] init];
	singlePhotoView = [[SinglePhotoViewController alloc] init];
	applicationAPI = [[LiveGatherAPI alloc] init];
	
	[tagsScrollView setShowsHorizontalScrollIndicator:NO];
	
	if(!liveStreamObjects) liveStreamObjects = [NSMutableArray new];
	if(!liveStreamObjectViews) liveStreamObjectViews = [NSMutableArray new];
	if(!imagesInMemoryDictionary) [self initImageDictionaryWithCapacity:15];
	
	if(!imageFetchingQueue) imageFetchingQueue = [[NSOperationQueue alloc] init];
	
	[self updateLiveStreamPhotos];
	[self updateTags];
	
	[liveStreamPreviewScrollView setDelegate:self];
	
	if (!visibleLiveStreamItems) visibleLiveStreamItems = [[NSMutableSet alloc] init];
	if (!recycledLiveStreamItems) recycledLiveStreamItems = [[NSMutableSet alloc] init];
		
	[refreshLiveStreamMiniViewButton setFrame:CGRectMake(277, 419, 35, 32)];
	
	[super viewDidLoad];
}

//Custom Methods for this Class

- (IBAction)uploadPhoto {
	//[self presentModalViewController:uploadViewController animated:YES];
	//[uploadViewController showUserImageControlOption];
}

- (IBAction)viewLiveStream {
	[self presentModalViewController:liveStreamView animated:YES];
	[visibleLiveStreamItems removeAllObjects];
	[recycledLiveStreamItems removeAllObjects];
}

- (void)updateTags {
	NSMutableArray *tagsArray = [[NSMutableArray alloc] initWithArray:[applicationAPI getRecentTagsWithLimit:10]];
	
	int numTagsToPlace = [tagsArray count];
	int currentPositionInScrollView = 0;
	
	for (int i = 0; i < numTagsToPlace; i++) {
		LGTag *tag = [tagsArray objectAtIndex:i];
		UILabel *label = [[UILabel alloc] init];
		[label setTextColor:[UIColor blueColor]];
		[label setFont:[UIFont fontWithName:@"Helvetica" size:14]];
		[label setText:[NSString stringWithFormat:@"#%@",[tag tag]]];
		[tagsScrollView addSubview:label];
		CGSize labelSize = [label.text sizeWithFont:label.font];
		label.frame = CGRectMake(0, 0, labelSize.width, labelSize.height);
		currentPositionInScrollView = labelSize.width + 5;
		[tagsScrollView setContentSize:CGSizeMake(currentPositionInScrollView, 20)];
		
		/************************MEMORY FIX HERE***************************/
		[label release];
		/************************MEMORY FIX HERE***************************/
	}
	
	/************************MEMORY FIX HERE***************************/
	[tagsArray release];
	/************************MEMORY FIX HERE**************************/
}

- (void)drawItemsToLiveStream {	
	if ([liveStreamObjects count] > 0) {
		int firstIndexVisibleInStream = [self liveStreamItemsCurrentlyInView:@"first"];
		int lastIndexVisibleInStream = [self liveStreamItemsCurrentlyInView:@"last"];
		for (LGPhotoView *photoView in visibleLiveStreamItems) {
			if (photoView.photo.photoIndex < firstIndexVisibleInStream || photoView.photo.photoIndex > lastIndexVisibleInStream) {
				[photoView setImage:nil];
				[recycledLiveStreamItems addObject:photoView];
				[photoView removeFromSuperview];
			}
		}
		[visibleLiveStreamItems minusSet:recycledLiveStreamItems];
		
		for (int i = firstIndexVisibleInStream; i <= lastIndexVisibleInStream; i++) {
			NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
			
			if (![self isDisplayingItemForIndex:i]) {
				LGPhotoView *photoView = [self dequeueRecycledLiveStreamView];
				if (photoView == nil) {
					photoView = [[[LGPhotoView alloc] init] autorelease];
				}
				photoView = [self configureItem:photoView forIndex:i];
				[photoView setUserInteractionEnabled:YES];
				[photoView setDelegate:self];
				[liveStreamPreviewScrollView addSubview:photoView];
				[visibleLiveStreamItems addObject:photoView];
			}
			
			[pool release];
		}
	}
	else {
		[self downloadNewLiveStreamPhotos];
	}

}

- (int)liveStreamItemsCurrentlyInView:(NSString *)index {
	NSMutableArray *arrayOfCellsInView = [NSMutableArray new];
	int firstIndex = 0;
	int lastIndex = 0;
	
	int numRows = 2;
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
	[liveStreamPreviewScrollView setContentSize:CGSizeMake(contentSizeWidth, contentSizeHeight)];
	CGRect visibleBoundsOfView = liveStreamPreviewScrollView.bounds;
		
	for (int i = 0; i < [self numberOfImagesForStream]; i++) {
		int row = i % numRows;
		int col = i / numRows;
		
		if(row == 1)
		{
			CGRect rect = CGRectMake(((kLiveStreamPreviewImageWidth + kLiveStreamPreviewHorizontalPadding) * col), kLiveStreamPreviewLowerStartPoint_Y, kLiveStreamPreviewImageWidth, kLiveStreamPreviewImageHeight);
			if (CGRectContainsRect(visibleBoundsOfView, rect)) {
				int indexNum = miniPhotoIndex(row, col);
				[arrayOfCellsInView addObject:[NSNumber numberWithInt:indexNum]];
			}
		}
		else {
			CGRect rect = CGRectMake(((kLiveStreamPreviewImageWidth + kLiveStreamPreviewHorizontalPadding) * col), kLiveStreamPreviewStartPoint_Y, kLiveStreamPreviewImageWidth, kLiveStreamPreviewImageHeight);
			if (CGRectContainsRect(visibleBoundsOfView, rect)) {
				int indexNum = miniPhotoIndex(row, col);
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
	
	if ((firstIndex - 2) > 0 || (firstIndex - 2) == 0) {
		firstIndex -= 2;
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

- (LGPhotoView *)configureItem:(LGPhotoView *)item forIndex:(int)index {
	LGPhoto *photo = [liveStreamObjects objectAtIndex:index];
	//LGPhotoView *photoView = [[LGPhotoView alloc] initWithImage:[UIImage imageWithContentsOfFile:photo.photoFilepath]];
	
	LGPhotoView *photoView;
	if ([imagesInMemoryDictionary objectForKey:[NSString stringWithFormat:@"%d", photo.photoID]] != nil) {
		photoView = [[LGPhotoView alloc] initWithImage:[imagesInMemoryDictionary objectForKey:[NSString stringWithFormat:@"%d", photo.photoID]]];
	}
	else {
		photoView = [[LGPhotoView alloc] initWithImage:[UIImage imageWithContentsOfFile:[applicationAPI getFilePathForCachedImageWithID:photo.photoID andSize:@"t"]]];
		if (!isLiveStreamScrolling) {
			LGImageLoadOperation *op = [[LGImageLoadOperation alloc] initWithImageID:photo.photoID andSize:@"s"];
			[imageFetchingQueue addOperation:op];
		}
	}
	
	photoView.frame = [self getRectForItemInLiveStream:index];
	[photoView setPhoto:photo];
	photoView.index = index;
	return [photoView autorelease];
}

- (void)imageLoaderLoadedImage:(NSDictionary *)dict {
	UIImage *image = [dict objectForKey:@"IMAGE"];
	NSString *imageID = [dict valueForKey:@"IMAGE_ID"];
	[self setImageDictionaryObject:image forKey:imageID];
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

- (CGRect)getRectForItemInLiveStream:(int)index {
	CGRect itemRect;
	
	int numRows = 2;
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
		
		if(miniPhotoIndex(row, col) == index)
		{
			if(row == 1)
			{
				itemRect = CGRectMake(((kLiveStreamPreviewImageWidth + kLiveStreamPreviewHorizontalPadding) * col), kLiveStreamPreviewLowerStartPoint_Y, kLiveStreamPreviewImageWidth, kLiveStreamPreviewImageHeight);
			}
			else {
				itemRect = CGRectMake(((kLiveStreamPreviewImageWidth + kLiveStreamPreviewHorizontalPadding) * col), kLiveStreamPreviewStartPoint_Y, kLiveStreamPreviewImageHeight, kLiveStreamPreviewImageHeight);
			}
			break;
		}
	}
	
	return itemRect;
}

- (LGPhotoView *)dequeueRecycledLiveStreamView {
	LGPhotoView *photoView = [recycledLiveStreamItems anyObject];
	if (photoView) {
		[[photoView retain] autorelease];
		[recycledLiveStreamItems removeObject:photoView];
	}
	return photoView;
}

- (IBAction)refreshStream {
	
}

- (void)photoViewWasTouchedWithID:(int)imgID andIndex:(int)imgIndex {
	[singlePhotoView setImageID:imgID];
	[self presentModalViewController:singlePhotoView animated:YES];
	[singlePhotoView initializeResources];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	isLiveStreamScrolling = YES;
	[self drawItemsToLiveStream];
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	isLiveStreamScrolling = NO;
}

- (IBAction)updateLiveStreamPhotos {	
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
	HUD.detailsLabelText = @"Algorithm is working";
    [HUD showWhileExecuting:@selector(downloadNewLiveStreamPhotos) onTarget:self withObject:nil animated:YES];
}

- (void)downloadNewLiveStreamPhotos {
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
			request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://projc:pr0j(@dev.livegather.com/api/photos/%d/iOS/s", photo.photoID]]];
		}
		else {
			request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://projc:pr0j(@dev.livegather.com/api/photos/%d/iOS/s", photo.photoID]]];
		}
		
		[request setDownloadDestinationPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%dS.jpg", photo.photoID]]];
		
		if ([applicationAPI imageFileCacheExistsInSQLWithID:photo.photoID forSize:@"s"]) {
			LGPhoto *img = [[LGPhoto alloc] init];
			
			[img setPhotoFilepath:[applicationAPI getFilePathForCachedImageWithID:photo.photoID andSize:@"s"]];
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
			[applicationAPI addImageFileToCacheWithID:photo.photoID andFilePath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%dS.jpg", photo.photoID]] andImageSize:@"s"];
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
			
			[photo setPhotoFilepath:[applicationAPI getFilePathForCachedImageWithID:[photoID intValue] andSize:@"s"]];
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
		
		[photo setPhotoFilepath:[applicationAPI getFilePathForCachedImageWithID:[photoID intValue] andSize:@"s"]];
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

- (void)setImageDictionaryValue:(id)value forKey:(NSString *)key {
	if ([imagesInMemoryDictionary count] < dictionaryLimit) {
		[imagesInMemoryDictionary setValue:value forKey:key];
		[arrayOfImageDictionaryItems addObject:[NSString stringWithString:key]];
	}
	else {
		[imagesInMemoryDictionary removeObjectForKey:[NSString stringWithString:[arrayOfImageDictionaryItems objectAtIndex:0]]];
		[arrayOfImageDictionaryItems removeObjectAtIndex:0];
		[imagesInMemoryDictionary setValue:value forKey:key];
	}
}

- (void)setImageDictionaryObject:(id)object forKey:(id)key {
	if ([imagesInMemoryDictionary count] < dictionaryLimit) {
		[imagesInMemoryDictionary setValue:object forKey:key];
		[arrayOfImageDictionaryItems addObject:[NSString stringWithString:key]];
	}
	else {
		[imagesInMemoryDictionary removeObjectForKey:[NSString stringWithString:[arrayOfImageDictionaryItems objectAtIndex:0]]];
		[arrayOfImageDictionaryItems removeObjectAtIndex:0];
		[imagesInMemoryDictionary setObject:object forKey:key];
	}
}

- (void)initImageDictionaryWithCapacity:(int)capacity {
	dictionaryLimit = capacity;
	[imagesInMemoryDictionary initWithCapacity:capacity];
}

- (void)hudWasHidden {
	
}

//<!--End Custom Methods for this Class


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)dealloc {
    [super dealloc];
}


@end
