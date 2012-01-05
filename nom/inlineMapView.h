//
//  inlineMapView.h
//  nom
//
//  Created by Brian Norton on 1/4/12.
//  Copyright (c) 2012 Nom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface inlineMapView : UIView

@property (nonatomic, retain) MKMapView *map;
@property (nonatomic, retain) UIImageView *frameImg;

- (id)init;

@end
