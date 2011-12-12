//
//  SettingsViewController.h
//  nom
//
//  Created by Brian Norton on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define settings_labels @"Publish To Nom", @"Publish to Facebook", @"Publish to Twitter", @"About Nom", @"Rate Nom v1.0", @"Legal etc.",@"Support",nil
#define settings_links @"http://justnom.it/project", @"http://itunes.apple.com/us/app/nom-project/id488587906?ls=1&mt=8", @"http://justnom.it/legal", @"http://justnom.it/support", nil

#define NOM 201
#define FACEBOOK 202
#define TWITTER 203

typedef enum {
    NMSettingsSourceConnect,
    NMSettingsSourceProfile
} NMSettingsSource;

@interface SettingsViewController : UITableViewController {
    NMSettingsSource source;
    NSArray *labels;
    NSArray *links;
}

- (id)initWithType:(NMSettingsSource)source;

@end
