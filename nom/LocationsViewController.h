//
//  LocationsViewController.h
//  nom
//
//  Created by Brian Norton on 11/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define __distances @"¼ mile", @"½ mile", @"1 mile", @"2½ miles", @"5 miles", nil
#define __distances_vals [NSNumber numberWithFloat:0.25f], [NSNumber numberWithFloat:0.5f], [NSNumber numberWithFloat:1.0f], [NSNumber numberWithFloat:2.5f], [NSNumber numberWithFloat:5.0f], nil
typedef enum {
    NMLocationsFilterAll,
    NMLocationsFilterCost,
    NMLocationsFilterCategory,
    NMLocationsFilterDistance
} NMLocationsFilter;

typedef enum {
    NMFilterDistanceQuarter,
    NMFilterDistanceHalf,
    NMFilterDistanceOne,
    NMFilterDistanceTwoHalf,
    NMFilterDistanceFive
} NMFilterDistance;

@interface LocationsViewController : UITableViewController {
    NSArray *locations;
    NSMutableArray *filtered_by_cost;
    NSMutableArray *filtered_by_current_category;
    NSMutableArray *filtered_by_distance;
    
    NMLocationsFilter filter;
    
    NMFilterDistance distance;
    NSArray *distances;
    NSArray *distance_values;
}

- (id)init;
- (id)initFilteredBy:(NMLocationsFilter)filter;

@end
