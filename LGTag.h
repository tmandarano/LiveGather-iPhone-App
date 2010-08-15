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

@property (nonatomic, retain) NSString *ID;
@property (nonatomic, retain) NSString *tag;
@property (nonatomic, retain) NSString *dateAdded;

@end
