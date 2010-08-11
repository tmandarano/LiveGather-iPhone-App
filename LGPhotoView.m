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
	//[delegate photoViewWasTouchedWithID:[self photoID]];
	[delegate photoViewWasTouchedWithID:[self photoID] andIndex:[self index]];
}

- (void)setIndex:(int)newIndex {
	index = newIndex;
}

- (int)index {
	return index;
}

- (void)setPhoto:(LGPhoto *)newPhoto {
	photo = newPhoto;
}

- (LGPhoto *)photo; {
	return photo;
}

- (int)photoID {
	return photo.photoID;
}

- (NSString *)photoURL {
	return photo.photoURL;
}

- (NSString *)photoName {
	return photo.photoName;
}

- (NSString *)photoLocationLatitude {
	return photo.photoLocationLatitude;
}

- (NSString *)photoLocationLongitude{
	return photo.photoLocationLongitude;
}

- (NSString *)photoCaption {
	return photo.photoCaption;
}

- (NSArray *)photoTags {
	return photo.photoTags;
}

- (NSString *)photoDateAdded {
	return photo.photoDateAdded;
}

- (NSString *)photoUserID {
	return photo.photoUserID;
}

- (UIImage *)photoImage {
	return photo;
}

- (NSString *)photoPath {
	return photo.photoPath;
}

@end
