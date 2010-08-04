//
//  LGUser.h
//  LiveGather
//
//  Created by Alexander on 8/3/10.
//  Copyright 2010 LiveGather. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LGUser : NSObject {
	NSString		*username;
	NSString		*emailAddress;
	NSString		*userID;
	NSString		*imageURL;
}

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *emailAddress;
@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain) NSString *imageURL;

@end
