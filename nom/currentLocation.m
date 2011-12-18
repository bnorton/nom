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

- (id)init {
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

+ (NSString *)howFarFromLat:(CGFloat)lat Long:(CGFloat)lng {
    CLLocation *old = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
    CLLocation *now = [[CLLocation alloc] initWithLatitude:[currentLocation lat] longitude:[currentLocation lng]];
    NSString *format = [[util format_location] stringFromDistanceAndBearingFromLocation:now toLocation:old];
    NSLog(@"INFO how far from %@", format);
    return format;
}

+ (NSString *)primaryImageUrlFromImages:(NSArray *)images {
    NSDictionary *right;
    @try {
        if (([images count] > 0) && (right = [images objectAtIndex:0])) {
            NSString *url;
            if ([(url = [right objectForKey:@"url"]) length] > 0) {
                return url;
            }
        }
    } @catch (NSException *ex) {}
    return nil;
}

+ (NSArray *)imageUrlsFromLocation:(NSArray *)images {
    NSMutableArray *arr = nil;
    NSString *url;
    @try {
        for (NSDictionary *img in images) {
            if ([(url = [img objectForKey:@"url"]) length] > 0)
                [arr addObject:url];
        }
    } @catch (NSException *ex) {}
    return arr;
}

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
