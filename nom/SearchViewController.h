//
//  SearchViewController.h
//  nom
//
//  Created by Brian Norton on 12/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UITableViewController <UISearchBarDelegate, UITextFieldDelegate>{
    id current_response;
    NSMutableArray *locations;
    
    UITextField *search_field;
    UIButton *cancel_button;
}

- (void)fetchedBasedOn:(NSString *)query where:(NSString *)loc;

@end
