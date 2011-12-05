//
//  LocationDetailViewController.h
//  nom
//
//  Created by Brian Norton on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationDetailViewController : UITableViewController {
    NSDictionary *location;
    NSString *location_nid;
}

@property (nonatomic,retain) NSDictionary *location;

- (id)initWithLocation:(NSDictionary *)_location;

@end
