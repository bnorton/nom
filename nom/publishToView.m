//
//  publishToView.m
//  nom
//
//  Created by Brian Norton on 11/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "publishToView.h"

@implementation publishToView

@synthesize facebook, nom, publish, attach_image;

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 44)];
    if (!self) { return nil; }
    
    [self setBackgroundColor:[UIColor lightGrayColor]];
    facebook = [UIButton buttonWithType:UIButtonTypeCustom];
    [facebook setFrame:CGRectMake(0, 0, 44, 44)];
    [facebook setBackgroundColor:[UIColor blueColor]];
    
    publish = [UIButton buttonWithType:UIButtonTypeCustom];
    [publish setFrame:CGRectMake(100, 0, 44, 44)];
    [publish setBackgroundColor:[UIColor darkGrayColor]];
    
    nom = [UIButton buttonWithType:UIButtonTypeCustom];
    [nom setFrame:CGRectMake(250, 0, 44, 44)];
    [nom setBackgroundColor:[UIColor greenColor]];
    
    [self addSubview:facebook];
    [self addSubview:publish];
    [self addSubview:nom];
    
    return self;
}



@end
