//
//  DelayedUISegmentedControl.m
//  nom
//
//  Created by Brian Norton on 11/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DelayedUISegmentedControl.h"

#define TIME_INTERVAL 0.25

@implementation DelayedUISegmentedControl

@synthesize timer;
@synthesize target, action;

- (id)init {
    self = [super init];
    if (! self) { return nil; }
    
    
    
    return self;
}

- (void)segmentAction:(UISegmentedControl *)sender {
	self.timer = [NSTimer scheduledTimerWithTimeInterval:TIME_INTERVAL target:self selector:@selector(delaySegmentAction) userInfo:nil repeats:NO];
}

- (void)addTarget:(id)targetValue action:(SEL)actionValue forControlEvents:(UIControlEvents)events {
	self.target = targetValue;
	self.action = actionValue;
    
	[super addTarget:self action:@selector(segmentAction:) forControlEvents:events];
}

- (void)delaySegmentAction {
	[self sendAction:self.action to:self.target forEvent:nil];
}

@end
