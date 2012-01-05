//
//  currentLocation.h
//  nom
//
//  Created by Brian Norton on 11/16/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface currentLocation : NSObject <CLLocationManagerDelegate, MKMapViewDelegate> {
    CLLocationManager *locationManager;
}

- (void)startUpdating;
- (void)stopUpdating;

- (CGFloat)lat;
- (CGFloat)lng;
- (CGFloat)altitude;
- (CGFloat)accuracy;

+ (NSString *)howFarFromLat:(CGFloat)lat Long:(CGFloat)lng;
+ (NSString *)primaryImageUrlFromImages:(NSArray *)images;
+ (NSArray *)imageUrlsFromLocation:(NSArray *)images;
@end
