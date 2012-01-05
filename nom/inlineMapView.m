//
//  inlineMapView.m
//  nom
//
//  Created by Brian Norton on 1/4/12.
//  Copyright (c) 2012 Nom Inc. All rights reserved.
//

#import "inlineMapView.h"

@implementation inlineMapView

@synthesize map, frameImg;

- (id)init
{
    self = [super init];
    if (self) {
        [self setFrame:CGRectMake(0, 0, 300, 103)];
        self.map = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 300, 103)];
        [map setMapType:MKMapTypeStandard];
        [self addSubview:map];
        
        self.frameImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"assets/mapLightbox4.png"]];
        [frameImg setFrame:CGRectMake(0, 0, 300, 103)];
        [self addSubview:frameImg];
    }
    return self;
}


@end
