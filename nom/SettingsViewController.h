//
//  SettingsViewController.h
//  nom
//
//  Created by Brian Norton on 11/23/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define settings_labels @"Publish To Nom", @"Publish to Facebook", @"Publish to Twitter", @"About the Nom Project", @"Rate Nom v0.2.0", @"Nom on the Interwebs",@"Twitter (@nom_app)", @"Support",nil
#define settings_links @"http://justnom.it/project", @"http://itunes.apple.com/us/app/nom/id463401211?ls=1&mt=8", @"http://justnom.it", @"http://twitter.com/nom_app", @"http://justnom.it/support", nil

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
    
    BOOL tabbar_hidden;
}

- (id)initWithType:(NMSettingsSource)source;

@end
