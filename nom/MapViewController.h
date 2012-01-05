//
//  MapViewController.h
//  nom
//
//  Created by Brian Norton on 1/4/12.
//  Copyright (c) 2012 Nom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#define flexible_nil [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]

@interface MapViewController : UIViewController <MKMapViewDelegate> {
    NSDictionary *location;
}

@property (nonatomic, retain) MKMapView *mapView;

@property (nonatomic, retain) UIToolbar *toolbar;

@property (nonatomic, retain) NSMutableArray *annotations;

- (id)initWithFrame:(CGRect)frame location:(NSDictionary *)location;

@end
