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

- (void)viewDidLoad {
	static NSString *appId = @"pefmjggfjdbdhjfibbjg";
	static NSString *tokenUrl = @"<YOUR_TOKEN_URL>";
	
	jrAuthenticate = [JRAuthenticate jrAuthenticateWithAppID:appId andTokenUrl:tokenUrl delegate:self];
	
	[jrAuthenticate showJRAuthenticateDialog];
}

- (void)jrAuthenticate:(JRAuthenticate*)jrAuth didReceiveToken:(NSString*)token { 
	
}

- (void)jrAuthenticate:(JRAuthenticate*)jrAuth didReceiveToken:(NSString*)token forProvider:(NSString*)provider
{
	
}

- (void)jrAuthenticate:(JRAuthenticate*)jrAuth didReachTokenURL:(NSString*)tokenURL withPayload:(NSString*)tokenUrlPayload
{
	
}

- (void)jrAuthenticateDidNotCompleteAuthentication:(JRAuthenticate*)jrAuth
{
	
}

- (void)jrAuthenticate:(JRAuthenticate*)jrAuth didFailWithError:(NSError*)error 
{
	
}

- (void)jrAuthenticate:(JRAuthenticate*)jrAuth callToTokenURL:(NSString*)tokenURL didFailWithError:(NSError*)error
{
	
}

//Start custom methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (IBAction)login {
	NSLog(@"LOGIN");
	/*if([livegatherController loginUser:emailLoginField.text withPassword:passwordLoginField.text])
	{
		[self presentModalViewController:mainViewController animated:YES];
	}*/
}

- (IBAction)signup {
	
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
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
