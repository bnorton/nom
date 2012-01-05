//
//  MapViewController.m
//  nom
//
//  Created by Brian Norton on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "Util.h"

#define MINIMUM_VISIBLE_LATITUDE 0.0035
#define MAP_PADDING 1.5

@implementation MapViewController

@synthesize mapView, toolbar;
@synthesize annotations;

- (id)initWithFrame:(CGRect)frame location:(NSDictionary *)_location
{
    self = [super init];
    if (! self) { return nil; }

    location = _location;

    [self.view setFrame:frame];
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.mapView setDelegate:self];
    [self.mapView setMapType:MKMapTypeStandard];
    [self.mapView setUserTrackingMode:MKUserTrackingModeNone];
    [self.mapView setShowsUserLocation:YES];        
    
    [self.view addSubview:mapView];
    
    NSDictionary *geom = [location objectForKey:@"geolocation"];
    
    CGFloat lat = [[geom objectForKey:@"lat"] floatValue];
    CGFloat lng = [[geom objectForKey:@"lng"] floatValue];
    
    float minLatitude  = fminf([[util currentLocation] lat], lat);
    float maxLatitude  = fmaxf([[util currentLocation] lat], lat);
    
    float minLongitude = fminf([[util currentLocation] lng], lng);        
    float maxLongitude = fmaxf([[util currentLocation] lng], lng);        
    
    NSLog(@"%f %f %f %f", [[util currentLocation] lat], lat,
          [[util currentLocation] lng], lng);
    
    MKCoordinateRegion region;
    region.center.latitude     = (minLatitude + maxLatitude)   / 2;
    region.center.longitude    = (minLongitude + maxLongitude) / 2;
    
    region.span.latitudeDelta  = (maxLatitude - minLatitude) * MAP_PADDING;
    
    region.span.latitudeDelta  = (region.span.latitudeDelta < MINIMUM_VISIBLE_LATITUDE)
    ? MINIMUM_VISIBLE_LATITUDE 
    : region.span.latitudeDelta;
    
    region.span.longitudeDelta = (maxLongitude - minLongitude) * MAP_PADDING;
    
    MKCoordinateRegion scaledRegion = [mapView regionThatFits:region];
    [mapView setRegion:scaledRegion animated:YES];
    
    MKPointAnnotation *annot = [[MKPointAnnotation alloc] init];
    [annot setTitle:[NSString stringWithFormat:@"%@", [location objectForKey:@"name"]]];
    [annot setSubtitle:[location objectForKey:@"street"]];
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(lat, lng);
    
    [annot setCoordinate:coord];
    [self.mapView addAnnotation:annot];

    return self;
}

#pragma mark - MKMapview Delegate

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    
}

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView
{
    
}

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView
{
    
}

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //    CLLocationCoordinate2D loc = [userLocation.location coordinate];
    //    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 1000.0f, 1000.0f);
    //    [aMapView setRegion:region animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView 
            viewForAnnotation:(id <MKAnnotation>)annotation {
    return nil;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    //    MKAnnotationView *aV; 
    //    for (aV in views) {
    //        CGRect endFrame = aV.frame;
    
    //        aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y - 530.0, aV.frame.size.width, aV.frame.size.height);
    //        [aV setAlpha:0];
    //        [UIView beginAnimations:nil context:NULL];
    //        [UIView setAnimationDuration:0.45];
    //        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    //        [aV setFrame:endFrame];
    //        [aV setAlpha:1];
    //        [UIView commitAnimations];
    //    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
