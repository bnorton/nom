//
//  currentLocation.h
//  nom
//
//  Created by Brian Norton on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface currentLocation : NSObject <CLLocationManagerDelegate>

+ (void)startUpdating;
+ (void)stopUpdating;

+ (CGFloat)lat;
+ (CGFloat)lng;
+ (CGFloat)altitude;
+ (CGFloat)accuracy;

+ (NSString *)howFarFromLat:(CGFloat)lat Long:(CGFloat)lng;

@end
