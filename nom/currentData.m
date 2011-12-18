//
//  currentData.m
//  nom
//
//  Created by Brian Norton on 11/23/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import "currentData.h"

@implementation currentData

typedef enum {
    NMActivityTypeThumb,
    NMActivityTypeRecommendation,
    NMActivityTypeRanking
} NMActivityType;

static NSMutableArray *activities;

static NSMutableArray *followers;
static NSMutableArray *following;

static NSMutableArray *locations;

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        
        activities = [[NSMutableArray alloc] initWithCapacity:50];
        followers  = [[NSMutableArray alloc] initWithCapacity:50];
        following  = [[NSMutableArray alloc] initWithCapacity:50];
        locations  = [[NSMutableArray alloc] initWithCapacity:50];
    }
}

+ (void)setActivities:(NSArray *)active { activities = [active mutableCopy]; }
+ (void)appendActivities:(NSArray *)active { [activities addObjectsFromArray:[active mutableCopy]]; }
+ (NSArray *)activities { return activities; }

+ (void)setFollowers:(NSArray *)follow { followers = [follow mutableCopy]; }
+ (void)appendFollowers:(NSArray *)follow { [followers addObjectsFromArray:[follow mutableCopy]]; }
+ (NSArray *)followers { return followers; }

+ (void)setFollowing:(NSArray *)follow { following = [follow mutableCopy]; }
+ (void)appendFollowing:(NSArray *)follow { [following addObjectsFromArray:[follow mutableCopy]]; }
+ (NSArray *)following { return following; }

+ (void)setLocations:(NSArray *)locat { locations = [locat mutableCopy]; }
+ (void)appendLocations:(NSArray *)locat { [locations addObjectsFromArray:[locat mutableCopy]]; }
+ (NSArray *)locations { return locations; }


@end
