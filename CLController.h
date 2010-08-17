#import <CoreLocation/CoreLocation.h>
// This protocol is used to send the text for location updates back to another view controller
@protocol CLControllerDelegate <NSObject>
@required
-(void)newLocationUpdate:(NSString *)text;
-(void)newError:(NSString *)text;
@end


// Class definition
@interface CLController : NSObject <CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
	id delegate;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic,assign) id <CLControllerDelegate> delegate;


- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error;

+ (CLController *)sharedInstance;

@end

