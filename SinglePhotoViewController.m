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
	applicationAPI = [[LiveGatherAPI alloc] init];
    [super viewDidLoad];
}

- (IBAction)cancel {
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}

- (IBAction)addComment {
	//PhotoFlipsideLocationView *flipsideView = [[PhotoFlipsideLocationView alloc] init];
	MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(mainImageView.frame.origin.x, mainImageView.frame.origin.y, mainImageView.frame.size.width, mainImageView.frame.size.height)];
	[mapView setShowsUserLocation:YES];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:2.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:mainImageView cache:YES];
	[mainImageView removeFromSuperview];
	[self.view addSubview:mapView];
	[UIView commitAnimations];
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
	LGPhoto *photo = [applicationAPI getPhotoForID:imageID];
	[imageCaptionLabel setText:[NSString stringWithFormat:@"%@", photo.photoCaption]];
	[usernameLabel setText:[NSString stringWithFormat:@"%@", [applicationAPI getUserForID:[photo.photoUserID intValue]].username]];
	NSArray *photoTags = [NSArray arrayWithArray:photo.photoTags];
	LGTag *tag = [photoTags objectAtIndex:0];
	[imageTagsLabel setText:[NSString stringWithFormat:@"#%@", tag.tag]];
}

- (void)imageAlreadyExists:(int)imgID {
	UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.jpg", imgID]]];
	[mainImageView setImage:image];
	LGPhoto *photo = [applicationAPI getPhotoForID:imageID];
	[imageCaptionLabel setText:[NSString stringWithFormat:@"%@", photo.photoCaption]];
	[usernameLabel setText:[NSString stringWithFormat:@"%@", [applicationAPI getUserForID:[photo.photoUserID intValue]].username]];
}

- (void)initializeResources {
	if (mainImageView) {
		UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.jpg", imageID]]];
		[mainImageView setImage:image];
		LGPhoto *photo = [applicationAPI getPhotoForID:imageID];
		[imageCaptionLabel setText:[NSString stringWithFormat:@"%@", photo.photoCaption]];
		[usernameLabel setText:[NSString stringWithFormat:@"%@", [applicationAPI getUserForID:[photo.photoUserID intValue]].username]];
		NSArray *photoTags = [NSArray arrayWithArray:photo.photoTags];
		LGTag *tag = [photoTags objectAtIndex:0];
		[imageTagsLabel setText:[NSString stringWithFormat:@"#%@", tag.tag]];
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	/*UIImageView *imageView = [streamArray objectAtIndex:3];
	UIView *containerView = [streamContainersArray objectAtIndex:3];
	MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height)];
	[mapView setShowsUserLocation:YES];
	NSLog(@"%f", imageView.frame.origin.x);
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:2.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:containerView cache:YES];
	[imageView removeFromSuperview];
	[containerView addSubview:mapView];
	[UIView commitAnimations];*/
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
