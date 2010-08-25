//
//  LGImageLoadOperation.h
//  LiveGather
//
//  Created by Alexander on 8/22/10.
//  Copyright 2010 LiveGather. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "LiveGatherAPI.h"
#import "MainViewController.h"

@interface LGImageLoadOperation : NSOperation {
	NSString				*imageFilePath;
	int						imageID;
	NSString				*imageSize;
	
	@private
	LiveGatherAPI			*applicaitonAPI;
	MainViewController		*mainViewController;
}

@property (nonatomic) int imageID;
@property (nonatomic, retain) NSString *imageFilePath;
@property (nonatomic, retain) NSString *imageSize;

- (id)initWithImageID:(int)imgID andSize:(NSString *)imgSize;
- (id)initWithFilePath:(NSString *)imgPath;

@end
