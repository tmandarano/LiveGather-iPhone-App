    //
//  AccountLoginViewController.m
//  LiveGather
//
//  Created by Alexander on 4/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AccountLoginViewController.h"


@implementation AccountLoginViewController


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}

//Start custom methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if(textField == emailLoginField)
	{
		[passwordLoginField becomeFirstResponder];
	}
	else {
		[textField resignFirstResponder];
	}
	return YES;
}

- (IBAction)login {
	NSLog(@"LOGIN");
	/*if([livegatherController loginUser:emailLoginField.text withPassword:passwordLoginField.text])
	{
		[self presentModalViewController:mainViewController animated:YES];
	}*/
	[livegatherController loginUser:@"xander" withPassword:@"dilbert"];
}

- (IBAction)signup {
	
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 100, self.view.frame.size.width, self.view.frame.size.height);
	[UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 100, self.view.frame.size.width, self.view.frame.size.height);
	[UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if([emailLoginField isFirstResponder] || [passwordLoginField isFirstResponder])
	{
		[emailLoginField resignFirstResponder];
		[passwordLoginField resignFirstResponder];
	}
}

//<!-- End Custom Methods

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	livegatherController = [[LiveGatherAPI alloc] init];
	mainViewController = [[MainViewController alloc] init];
}

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
