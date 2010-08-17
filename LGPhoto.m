//
//  LGPhoto.m
//  LiveGather
//
//  Created by Alexander on 7/23/10.
//  Copyright 2010 LiveGather. All rights reserved.
//

#import "LGPhoto.h"


@implementation LGPhoto

@synthesize photoJSON;
@synthesize photoID;
@synthesize photoURL;
@synthesize photoFilename;
@synthesize photoFileID;
@synthesize photoName;
@synthesize photoLocationLatitude;
@synthesize photoLocationLongitude;
@synthesize photoAddress;
@synthesize photoLocation;
@synthesize photoCaption;
@synthesize photoTags;
@synthesize photoUser;
@synthesize photoDateAdded;
@synthesize photoUserID;
@synthesize photoPath;
@synthesize photoIndex;

- (id)init {
	
	if(self = [super init])
	{
	}
	
	return self;
}

@end
