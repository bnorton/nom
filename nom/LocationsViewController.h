//
//  LocationsViewController.h
//  nom
//
//  Created by Brian Norton on 11/26/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "CustomSegmentedControl.h"

#define __distances @"¼ mile", @"½ mile", @"1 mile", @"2½ miles", @"5 miles", nil
#define __distances_vals [NSNumber numberWithFloat:0.25f], [NSNumber numberWithFloat:0.5f], [NSNumber numberWithFloat:1.0f], [NSNumber numberWithFloat:2.5f], [NSNumber numberWithFloat:5.0f], nil

#define BUTTON_WIDTH 54.0
#define BUTTON_SEGMENT_WIDTH 51.0
#define CAP_WIDTH 5.0

@class cellCache;

typedef enum {
    CapLeft          = 0,
    CapMiddle        = 1,
    CapRight         = 2,
    CapLeftAndRight  = 3
} CapLocation;

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

@interface LocationsViewController : UITableViewController <EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource, CustomSegmentedControlDelegate> {
    
    id current_response;
    NSArray *locations;
    NSMutableArray *filtered_by_all;
    NSMutableArray *filtered_by_cost;
    NSMutableArray *filtered_by_current_category;
    NSMutableArray *filtered_by_distance;
    
    NSMutableDictionary *cell_cache;
    
    NMLocationsFilter filter;
    
    NMFilterDistance distance;
    NSArray *distances;
    NSArray *distance_values;
    
    NSArray *categories;
    EGORefreshTableHeaderView *_refreshHeaderView;
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes 
	BOOL _reloading;

    NSArray* segmentControlTitles;
    
    cellCache *cache;

}

@property (nonatomic, retain) id current_response;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;


- (id)init;
- (id)initFilteredBy:(NMLocationsFilter)filter;

- (void)fetchLocations;
- (void)fetchLocationsWithOptions:(NSDictionary *)options;

- (void)setupLocations;

- (void)preBuildCells;

- (void)filter_by_cost:(NSString *)cost_str;

@end
