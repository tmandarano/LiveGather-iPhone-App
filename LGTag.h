//
//  LGTag.h
//  LiveGather
//
//  Created by Alexander on 7/25/10.
//  Copyright 2010 LiveGather. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LGTag : NSObject {
	NSString	*ID;
	NSString	*tag;
	NSString	*dateAdded;
}

- (NSString *)tagID;
- (void)setTagID:(NSString *)tagID;

- (NSString *)tag;
- (void)setTag:(NSString *)tagName;

- (NSString *)dateAdded;
- (void)setDateAdded:(NSString *)dateTagAdded;

@end
