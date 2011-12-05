//
//  NMAppDelegate.h
//  nom
//
//  Created by Brian Norton on 11/14/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class currentLocation;

@interface NMAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) currentLocation *location;

@property (strong, nonatomic) UITabBarController *tabBarController;

@end
