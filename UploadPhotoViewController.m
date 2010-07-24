//
//  UploadPhotoViewController.m
//  LiveGather
//
//  Created by Alexander on 4/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UploadPhotoViewController.h"

#define kPrivacyAlertTag 3


@implementation UploadPhotoViewController


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
	mainViewController = [[MainViewController alloc] init];
    [super viewDidLoad];
}

- (IBAction)refreshLocation {
	//[((EAGLView*)self.view) drawView];
	EAGLView *eaglView = [[EAGLView alloc] init];
	[eaglView drawView];
}

- (IBAction)sendToTwitter {
	
}

- (IBAction)sendToFacebook {
	
}

- (void)showUserImageControlOption {
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		UIActionSheet *userImagePickerType = [[UIActionSheet alloc] initWithTitle:@"Upload Photo From:"
																		 delegate:self
																cancelButtonTitle:@"Cancel"
														   destructiveButtonTitle:nil
																otherButtonTitles:nil];
		[userImagePickerType addButtonWithTitle:@"Photo Library"];
		[userImagePickerType addButtonWithTitle:@"Camera"];
		[userImagePickerType showInView:self.view];
	}
	else {
		UIActionSheet *userImagePickerType = [[UIActionSheet alloc] initWithTitle:@"Upload Photo From:"
																		 delegate:self
																cancelButtonTitle:@"Cancel"
														   destructiveButtonTitle:nil
																otherButtonTitles:nil];
		[userImagePickerType addButtonWithTitle:@"Photo Library"];
		[userImagePickerType showInView:self.view];
	}
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
	
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSLog(@"%d",buttonIndex);
	switch (buttonIndex) {
		case 2:
			imagePickerController = [[UIImagePickerController alloc] init];
			imagePickerController.delegate = self;
			[imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
			[self presentModalViewController:imagePickerController animated:YES];
			break;
		case 1:
			imagePickerController = [[UIImagePickerController alloc] init];
			imagePickerController.delegate = self;
			[imagePickerController setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
			[self presentModalViewController:imagePickerController animated:YES];
			break;
	}
}
	 
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo {
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
}

//Custom Methods

- (IBAction)cancel {	
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}

- (IBAction)upload {
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if(textField == captionTextField)
	{
		[tagsTextField becomeFirstResponder];
	}
	else {
		[textField resignFirstResponder];
	}
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
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
