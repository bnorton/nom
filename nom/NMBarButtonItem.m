//
//  NMBarButtonItem.m
//  nom
//
//  Created by Brian Norton on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NMBarButtonItem.h"
#import "Util.h"

@implementation NMBarButtonItem

- (id)initWithText:(NSString *)txt color:(NMBarButtonItemColor)_color {
    button = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Cancel", nil]];
    button.momentary = YES;
    button.segmentedControlStyle = UISegmentedControlStyleBar;
    double color = 0x0d9c23; // default to green
    
    switch (_color) {
        case NMBarButtonItemColorGreen:
            break;
        case NMBarButtonItemColorRed:
            color = 0xC84131;
            break;
        case NMBarButtonItemColorOrange:
            color = 0xC84131;
            break;
        default:
            break;
    }
    
    button.tintColor = UIColorFromRGB(0x0d9c23);

    self = [super initWithCustomView:button];
    if (! self) { return nil; }

    return self;
}

- (void)addTarget:(id)target action:(SEL)sel {
    [button addTarget:target action:sel forControlEvents:UIControlEventValueChanged];
}

@end
