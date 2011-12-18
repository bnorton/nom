//
//  DelayedUISegmentedControl.h
//  nom
//
//  Created by Brian Norton on 11/29/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DelayedUISegmentedControl : UISegmentedControl {
	NSTimer *timer;
	__unsafe_unretained id target;
	SEL action;	
}

@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;

- (void)addTarget:(id)targetValue action:(SEL)actionValue forControlEvents:(UIControlEvents)events;
- (void)segmentAction:(UISegmentedControl *)sender;
- (void)delaySegmentAction;


@end
