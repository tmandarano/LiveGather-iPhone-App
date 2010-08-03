    //
//  SinglePhotoViewController.m
//  LiveGather
//
//  Created by Alexander on 8/2/10.
//  Copyright 2010 LiveGather. All rights reserved.
//

#import "SinglePhotoViewController.h"


@implementation SinglePhotoViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
	[usernameLabel setText:[NSString stringWithFormat:@"%d", imageIDToDisplay]];
	
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
