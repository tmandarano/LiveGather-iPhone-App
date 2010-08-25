//
//  LGMutableDictionary.h
//  LiveGather
//
//  Created by Alexander on 8/23/10.
//  Copyright 2010 LiveGather. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LGMutableDictionary : NSMutableDictionary {
	int					limit;
	NSMutableArray		*arrayOfObjects;
}

- (BOOL)setValue:(id)value forKey:(NSString *)key;
- (BOOL)setObject:(id)anObject forKey:(id)aKey;
- (id)objectForKey:(id)aKey;

@end
