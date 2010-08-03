//
//  LGPhoto.h
//  LiveGather
//
//  Created by Alexander on 7/23/10.
//  Copyright 2010 LiveGather. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGPhoto : UIImage {
	int			photoID;
	NSString	*photoURL;
	NSString	*photoName;
	NSString	*photoLocationLatitude;
	NSString	*photoLocationLongitude;
	NSString	*photoCaption;
	NSArray		*photoTags;
	NSString	*photoDateAdded;
	NSString	*photoUserID;
	NSString	*photoPath;
	int			photoIndex;
}

//Getters and setters

- (int)photoID;
- (void)setID:(int)ID;

- (void)setPhotoIndex:(int)index;
- (int)photoIndex;

- (NSString *)photoURL;
- (void)setPhotoURL:(NSString *)url;

- (NSString *)photoName;
- (void)setPhotoName:(NSString *)name;

- (NSString *)photoLocationLatitude;
- (NSString *)photoLocationLongitude;
- (void)setPhotoLocation:(NSString *)latitude withLong:(NSString *)longitude;

- (NSString *)photoCaption;
- (void)setPhotoCaption:(NSString *)caption;

- (NSArray *)photoTags;
- (void)setPhotoTags:(NSArray *)tags;

- (NSString *)photoDateAdded;
- (void)setPhotoDateAdded:(NSString *)dateAdded;

- (NSString *)photoUserID;
- (void)setPhotoUserID:(NSString *)userid;

- (NSString *)photoPath;
- (void)setPhotoPath:(NSString *)path;

@end
