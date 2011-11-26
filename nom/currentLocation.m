//
//  currentLocation.m
//  nom
//
//  Created by Brian Norton on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "currentLocation.h"

static CLLocationManager *locationManager = nil;
static BOOL isScheduledForStop = false;
static NSTimer *scheduledTimer = nil;

@implementation currentLocation

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        locationManager = [[CLLocationManager alloc] init];
    }
}

-(id)init {
    self = [super init];
    if (!self) return nil;
    
    [locationManager setDelegate:self];
    
    return self;
}

+ (void)startUpdating {
    if (isScheduledForStop) {
        isScheduledForStop = false;
        [scheduledTimer invalidate];
    }
    [locationManager startUpdatingHeading];
}

+ (void)stopUpdatingLater {
    isScheduledForStop = false;
    [locationManager stopUpdatingLocation];
}

+ (void)stopUpdating {
    if (isScheduledForStop) {
        return;
    } else {
        isScheduledForStop = true;
        scheduledTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:[currentLocation class]
                                  selector:@selector(stopUpdatingLater) 
                                  userInfo:nil repeats:NO];
    }
}

+ (CGFloat)lat { return locationManager.location.coordinate.latitude;     }
+ (CGFloat)lng { return locationManager.location.coordinate.longitude;    }
+ (CGFloat)altitude { return locationManager.location.altitude;           }
+ (CGFloat)accuracy { return locationManager.location.horizontalAccuracy; }

#pragma mark CLLocation Manager Delegate methods

- (void)locationManager:(CLLocationManager *)manager 
    didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"location : %f, %f, %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude, newLocation.horizontalAccuracy);
    
    CLLocationAccuracy accuracy = newLocation.horizontalAccuracy;
    if (accuracy < kCLLocationAccuracyHundredMeters){
        
        
    }
}

- (void)locationManager:(CLLocationManager *)manager 
       didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError %@", error);
}

- (void)locationManager:(CLLocationManager *)manager 
         didEnterRegion:(CLRegion *)region
{
    NSLog(@"didEnterRegion %@", region);
}

- (void)locationManager:(CLLocationManager *)manager 
          didExitRegion:(CLRegion *)region
{
    NSLog(@"didExitRegion %@", region);
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region 
              withError:(NSError *)error
{
    NSLog(@"monitoringDidFailForRegion %@", region);
}

- (void)locationManager:(CLLocationManager *)manager 
didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"didChangeAuthorizationStatus %d", status);
}


@end
