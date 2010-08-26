//
//  LGImageLoadOperation.m
//  LiveGather
//
//  Created by Alexander on 8/22/10.
//  Copyright 2010 LiveGather. All rights reserved.
//

#import "LGImageLoadOperation.h"

@implementation LGImageLoadOperation

@synthesize imageID, imageFilePath, imageSize;

- (id)initWithImageID:(int)imgID andSize:(NSString *)imgSize {
	if (![super init]) return nil;
	[self setImageID:imgID];
	[self setImageSize:imgSize];
	applicaitonAPI = [[LiveGatherAPI alloc] init];
	mainViewController = [[MainViewController alloc] init];
    return self;
}

- (id)initWithFilePath:(NSString *)imgPath {
	if (![super init]) return nil;
	[self setImageFilePath:imageFilePath];
	applicaitonAPI = [[LiveGatherAPI alloc] init];
	mainViewController = [[MainViewController alloc] init];
    return self;
}

- (void)main {
	if (![mainViewController.imagesInMemoryDictionary objectForKey:[NSString stringWithFormat:@"%d", imageID]]) {
		NSString *filePath = [applicaitonAPI getFilePathForCachedImageWithID:imageID andSize:imageSize];
		UIImage *returnImage = [[UIImage alloc] initWithContentsOfFile:filePath];
		
		if (returnImage) {
			NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:2];
			[dict setObject:returnImage forKey:@"IMAGE"];
			[dict setValue:[NSString stringWithFormat:@"%d", imageID] forKey:@"IMAGE_ID"];
			NSDictionary *returnDict = [[NSDictionary alloc] initWithDictionary:dict];
			[dict release];
			[mainViewController performSelectorOnMainThread:@selector(imageLoaderLoadedImage:) withObject:returnDict waitUntilDone:NO];
			[returnDict release];
		}
		else {
			NSLog(@"No image for %d", imageID);
		}

	}
	else {
		/*NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
		[dict setObject:nil forKey:@"IMAGE"];
		[dict setValue:@"" forKey:@"IMAGE_ID"];
		NSDictionary *returnDict = [NSDictionary dictionaryWithDictionary:dict];
		[mainViewController performSelectorOnMainThread:@selector(imageLoaderLoadedImage:) withObject:returnDict waitUntilDone:NO];
		[returnDict release];*/
	}
}

- (void)dealloc {
	[imageFilePath release];
	[super dealloc];
}

@end
