//
//  NMJSONUtilities.m
//  nom
//
//  Created by Brian Norton on 12/7/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import "NMJSONUtilities.h"
#import "AFJSONUtilities.h"

@implementation NMJSONUtilities

+ (id)jsonStringFrom:(id)item {
    NSError *error;
    @try {
        return AFJSONEncode(item, &error);
    } @catch (NSException *ex) {;}
    
    return nil;
}

@end
