//
//  currentData.h
//  nom
//
//  Created by Brian Norton on 11/23/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface currentData : NSObject

+ (void)setActivities:(NSArray *)active;
+ (void)appendActivities:(NSArray *)active;
+ (NSArray *)activities;

+ (void)setFollowers:(NSArray *)follow;
+ (void)appendFollowers:(NSArray *)follow;
+ (NSArray *)followers;

+ (void)setFollowing:(NSArray *)follow;
+ (void)appendFollowing:(NSArray *)follow;
+ (NSArray *)following;

+ (void)setLocations:(NSArray *)locat;
+ (void)appendLocations:(NSArray *)locat;
+ (NSArray *)locations;

@end
