//
//  LGPhoto.m
//  LiveGather
//
//  Created by Alexander on 7/23/10.
//  Copyright 2010 LiveGather. All rights reserved.
//

#import "LGPhoto.h"


@implementation LGPhoto

- (id)init {
	
	if(self = [super init])
	{
		
	}
	
	return self;
}


- (NSString *)photoID {
	return photoID;
}

- (void)setID:(NSString *)ID {
	photoID = ID;
}

- (NSString *)photoURL {
	return photoURL;
}

- (void)setPhotoURL:(NSString *)url {
	photoURL = url;
}

- (NSString *)photoName {
	return photoName;
}

- (void)setPhotoName:(NSString *)name {
	photoName = name;
}

- (NSString *)photoLocationLatitude {
	return photoLocationLatitude;
}

- (NSString *)photoLocationLongitude {
	return photoLocationLongitude;
}

- (void)setPhotoLocation:(NSString *)latitude withLong:(NSString *)longitude {
	photoLocationLatitude = latitude;
	photoLocationLongitude = longitude;
}

- (NSString *)photoCaption {
	return photoCaption;
}

- (void)setPhotoCaption:(NSString *)caption {
	photoCaption = caption;
}

- (NSArray *)photoTags {
	return photoTags;
}

- (void)setPhotoTags:(NSArray *)tags {
	photoTags = tags;
}

- (NSString *)photoDateAdded {
	return photoDateAdded;
}

- (void)setPhotoDateAdded:(NSString *)dateAdded {
	photoDateAdded = dateAdded;
}

- (NSString *)photoUserID {
	return photoUserID;
}

- (void)setPhotoUserID:(NSString *)userid {
	photoUserID = userid;
}

- (UIImage *)photoImage {
	return photoImage;
}

- (void)setPhotoImage:(UIImage *)image {
	photoImage = image;
}

- (NSString *)photoPath {
	return photoPath;
}

- (void)setPhotoPath:(NSString *)path {
	photoPath = path;
}

@end
