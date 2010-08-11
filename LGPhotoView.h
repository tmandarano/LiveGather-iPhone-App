//
//  LGPhotoView.h
//  LiveGather
//
//  Created by Alexander on 7/30/10.
//  Copyright 2010 LiveGather. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGPhoto.h"

@class LGPhotoView;
@protocol LGPhotoDelegate <NSObject>
@optional
- (void)photoViewWasTouchedWithID:(int)imgID andIndex:(int)imgIndex;
@end


@interface LGPhotoView : UIImageView {
	LGPhoto		*photo;
	int			index;
	id <LGPhotoDelegate> delegate;
}

@property (nonatomic, assign) id <LGPhotoDelegate> delegate;

- (void)setDelegate:(id <LGPhotoDelegate>)dlg;

- (void)setIndex:(int)newIndex;
- (int)index;

- (void)setPhoto:(LGPhoto *)newPhoto;
- (LGPhoto *)photo;

- (int)photoID;

- (NSString *)photoURL;

- (NSString *)photoName;

- (NSString *)photoLocationLatitude;
- (NSString *)photoLocationLongitude;

- (NSString *)photoCaption;

- (NSArray *)photoTags;

- (NSString *)photoDateAdded;

- (NSString *)photoUserID;

- (UIImage *)photoImage;

- (NSString *)photoPath;

@end
