//
//  currentLocation.m
//  nom
//
//  Created by Brian Norton on 11/16/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import "currentLocation.h"
#import "current.h"
#import "Util.h"

static BOOL isScheduledForStop = false;
static NSTimer *scheduledTimer = nil;

@implementation currentLocation

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        
    }
}

- (id)init {
    self = [super init];
    if (!self) return nil;
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    
    return self;
}

- (void)startUpdating {
    if (isScheduledForStop) {
        isScheduledForStop = false;
        [scheduledTimer invalidate];
    }
    [locationManager startUpdatingLocation];
}

- (void)stopUpdatingLater {
    isScheduledForStop = false;
    [locationManager stopUpdatingLocation];
}

- (void)stopUpdating {
    if (isScheduledForStop) {
        return;
    } else {
        isScheduledForStop = true;
        scheduledTimer = [NSTimer scheduledTimerWithTimeInterval:7.5 target:[util currentLocation]
                                  selector:@selector(stopUpdatingLater) 
                                  userInfo:nil repeats:NO];
    }
}

- (CGFloat)lat { return locationManager.location.coordinate.latitude;     }
- (CGFloat)lng { return locationManager.location.coordinate.longitude;    }
- (CGFloat)altitude { return locationManager.location.altitude;           }
- (CGFloat)accuracy { return locationManager.location.horizontalAccuracy; }

+ (NSString *)howFarFromLat:(CGFloat)lat Long:(CGFloat)lng {
    CLLocation *old = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
    CLLocation *now = [[CLLocation alloc] initWithLatitude:[[util currentLocation] lat] longitude:[[util currentLocation] lng]];
    NSString *format = [[util format_location] stringFromDistanceAndBearingFromLocation:now toLocation:old];
    return format;
}

+ (NSString *)primaryImageUrlFromImages:(NSArray *)images {
    NSDictionary *right;
    if (([images count] > 0) && ((right = [images objectAtIndex:0])) != nil) {
        NSString *url;
        if ([(url = [right objectForKey:@"url"]) length] > 0)
            return url;
    }
    return nil;
}

+ (NSArray *)imageUrlsFromLocation:(NSArray *)images {
    NSMutableArray *arr = nil;
    NSString *url;
    if(images != nil){
        for (NSDictionary *img in images) {
            if ([(url = [img objectForKey:@"url"]) length] > 0)
                [arr addObject:url];
        }
    }
    return arr;
}

#pragma mark CLLocation Manager Delegate methods

- (void)locationManager:(CLLocationManager *)manager 
    didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocationAccuracy accuracy = newLocation.horizontalAccuracy;
    if (accuracy < kCLLocationAccuracyHundredMeters){
        
        [self stopUpdating];
    }
}

- (void)locationManager:(CLLocationManager *)manager 
       didFailWithError:(NSError *)error
{
}

- (void)locationManager:(CLLocationManager *)manager 
         didEnterRegion:(CLRegion *)region {
}

- (void)locationManager:(CLLocationManager *)manager 
          didExitRegion:(CLRegion *)region {
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region 
              withError:(NSError *)error {
}

- (void)locationManager:(CLLocationManager *)manager 
didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
}


@end
