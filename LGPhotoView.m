//
//  LGPhotoView.m
//  LiveGather
//
//  Created by Alexander on 7/30/10.
//  Copyright 2010 LiveGather. All rights reserved.
//

#import "LGPhotoView.h"


@implementation LGPhotoView

@synthesize delegate;
@synthesize photo;
@synthesize index;

- (id)init {
	
	if(self = [super init])
	{
		[self setUserInteractionEnabled:YES];
	}
	
	return self;
}

- (void)setDelegate:(id <LGPhotoDelegate>)dlg {
	delegate = dlg;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint pt = [[touches anyObject] locationInView:self];
	
	if (CGRectContainsPoint(CGRectMake(77, 311, 155, 18), pt)) {
		[delegate photoLocationLabelWasTouchedWithID:self.photo.photoID andIndex:self.index];
	}
	else {
		[delegate photoViewWasTouchedWithID:self.photo.photoID andIndex:self.index];
	}

}

@end
