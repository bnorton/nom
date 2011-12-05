//
//  NSNull+length.m
//  nom
//
//  Created by Brian Norton on 11/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NSNull+length.h"

@implementation NSNull (length)

-(NSUInteger)length {
    return 0;
}

- (BOOL)isEqualToString:(NSString *)aString {
    NSLog(@"NSNull isEqual to string");
    return [aString isKindOfClass:[NSNull class]] ? YES : NO;
}

@end
