//
//  LGPhoto.h
//  LiveGather
//
//  Created by Alexander on 7/23/10.
//  Copyright 2010 LiveGather. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LGPhoto : UIImageView {
	NSString	*photoID;
	NSString	*photoURL;
	NSString	*photoName;
	NSString	*photoLocationLatitude;
	NSString	*photoLocationLongitude;
	NSString	*photoCaption;
	NSArray		*photoTags;
	NSString	*photoDateAdded;
	NSString	*photoUserID;
	UIImage		*photoImage;
	NSString	*photoPath;
}

//Getters and setters

- (NSString *)photoID;
- (void)setID:(NSString *)ID;

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

- (UIImage *)photoImage;
- (void)setPhotoImage:(UIImage *)image;

- (NSString *)photoPath;
- (void)setPhotoPath:(NSString *)path;

@end
