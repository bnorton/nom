//
//  NMBarButtonItem.h
//  nom
//
//  Created by Brian Norton on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    NMBarButtonItemColorRed,
    NMBarButtonItemColorGreen,
    NMBarButtonItemColorOrange,
    NMBarButtonItemColorYellow
} NMBarButtonItemColor;

@interface NMBarButtonItem : UIBarButtonItem {
    NSString *text;
    UISegmentedControl *button;
}

- (id)initWithText:(NSString *)txt color:(NMBarButtonItemColor)_color;
- (void)addTarget:(id)target action:(SEL)sel;

@end
