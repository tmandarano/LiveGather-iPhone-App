//
//  LGMutableDictionary.m
//  LiveGather
//
//  Created by Alexander on 8/23/10.
//  Copyright 2010 LiveGather. All rights reserved.
//

#import "LGMutableDictionary.h"


@implementation LGMutableDictionary

- (id)init {
	if (self = [super init]) {
	}
	return self;
}

- (id)initWithCapacity:(NSUInteger)numItems {
	if (self = [super init]) {
		limit = numItems;
		NSLog(@"Init with %d", limit);
	}	
	return self;
}

- (BOOL)setValue:(id)value forKey:(NSString *)key {
	if ([self count] < limit) {
		[super setValue:value forKey:key];
		[arrayOfObjects addObject:[NSString stringWithString:key]];
		return YES;
	}
	else {
		[self removeObjectForKey:[NSString stringWithString:[arrayOfObjects objectAtIndex:0]]];
		[arrayOfObjects removeObjectAtIndex:0];
		[super setValue:value forKey:key];
		return YES;
	}
	return NO;
}

- (BOOL)setObject:(id)anObject forKey:(id)aKey {
	if ([self count] < limit) {
		[super setValue:anObject forKey:aKey];
		[arrayOfObjects addObject:[NSString stringWithString:aKey]];
		return YES;
	}
	else {
		[self removeObjectForKey:[NSString stringWithString:[arrayOfObjects objectAtIndex:0]]];
		[arrayOfObjects removeObjectAtIndex:0];
		[super setObject:anObject forKey:aKey];
		return YES;
	}

	return NO;
}

- (id)objectForKey:(id)aKey {
	return [super objectForKey:aKey];
}

@end
