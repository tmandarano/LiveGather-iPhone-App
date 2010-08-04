    //
//  SinglePhotoViewController.m
//  LiveGather
//
//  Created by Alexander on 8/2/10.
//  Copyright 2010 LiveGather. All rights reserved.
//

#import "SinglePhotoViewController.h"


@implementation SinglePhotoViewController

@synthesize imageID;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {	
	[self showImageWithID:imageID];
    [super viewDidLoad];
}

- (IBAction)cancel {
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}

- (IBAction)addComment {
	
}

- (void)showComments {
	
}

- (void)showImageWithID:(int)imgID {
	if (!networkQueue) {
		networkQueue = [[ASINetworkQueue alloc] init];
	}
	[networkQueue reset];
	[networkQueue setRequestDidFinishSelector:@selector(imageFetchComplete:)];
	[networkQueue setShowAccurateProgress:YES];
	[networkQueue setDelegate:self];
	
	ASIHTTPRequest *request;
	request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://projc:pr0j(@dev.livegather.com/api/photos/%d/3", imgID]]];
	[request setDownloadDestinationPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.jpg", imgID]]];
	
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	
	if (![fileManager fileExistsAtPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.jpg", imgID]]]) {
		[networkQueue addOperation:request];
	}
	else {
		[self imageAlreadyExists:imgID];
	}
	
	[networkQueue go];
}

- (void)imageFetchComplete:(ASIHTTPRequest *)request {
	UIImage *image = [[UIImage alloc] initWithContentsOfFile:[request downloadDestinationPath]];
	[mainImageView setImage:image];
}

- (void)imageAlreadyExists:(int)imgID {
	UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.jpg", imgID]]];
	[mainImageView setImage:image];
}

- (void)initializeResources {
	if (mainImageView) {
		UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.jpg", imageID]]];
		[mainImageView setImage:image];
	}
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
