//
//  NSNull+length.m
//  nom
//
//  Created by Brian Norton on 11/24/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import "NSNull+additions.h"

@implementation NSNull (additions)

-(NSUInteger)length {
    return 0;
}

- (BOOL)isEqualToString:(NSString *)aString {
    NSLog(@"NSNull isEqual to string");
    return [aString isKindOfClass:[NSNull class]] ? YES : NO;
}

- (CGFloat)floatValue {
    return 0.0f;
}
@end
