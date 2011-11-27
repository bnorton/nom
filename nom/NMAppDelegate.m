//
//  NMAppDelegate.m
//  nom
//
//  Created by Brian Norton on 11/14/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import "NMAppDelegate.h"

#import "NMInitialConnectViewController.h"
#import "NMActivityViewController.h"
#import "LocationsViewController.h"
#import "ConnectViewController.h"
#import "currentUser.h"

#import "Util.h"

@implementation NMAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackTranslucent];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIViewController *activity = [[NMActivityViewController alloc] initWithType:NMActivityTypeByFollowing];
    UIViewController *locations= [[LocationsViewController alloc] init];
    UIViewController *connect  = [[ConnectViewController alloc] init];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:activity, locations, connect, nil];
    [self.tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"tab_bar4a.png"]];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.tabBarController];

//    self.window.rootViewController = self.tabBarController;
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar4f.png"] 
                            forBarMetrics:UIBarMetricsDefault];

    NSLog(@"logged in or connected %d", [currentUser getBooleanForKey:@"logged_in_or_connected"]);
//    [currentUser setBoolean:NO ForKey:@"logged_in_or_connected"];
    
    if ( ! [currentUser getBooleanForKey:@"logged_in_or_connected"]) {
        UIViewController *initialConnect = [[NMInitialConnectViewController alloc] init];
        UINavigationController *isnav = [[UINavigationController alloc] initWithRootViewController:initialConnect];
        
        [isnav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar4f.png"] 
                                  forBarMetrics:UIBarMetricsDefault];

        [nav performBlock:^{
            [nav presentModalViewController:isnav animated:YES];
        } afterDelay:1.2];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
