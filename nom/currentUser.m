//
//  currentUser.m
//  nom
//
//  Created by Brian Norton on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "currentUser.h"

@implementation currentUser

static NSUserDefaults *defaults = nil;

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        defaults = [NSUserDefaults standardUserDefaults];
    }
}

+ (void)setDate:(NSDate *)date forKey:(NSString *)key {
    [currentUser setNumber:[date timeIntervalSince1970] ForKey:key];
}

+ (NSDate *)getDateForKey:(NSString *)key {
    CGFloat then = [currentUser getNumberForKey:key];
    return [NSDate dateWithTimeInterval:then sinceDate:[NSDate date]];
}

+ (NSString *)getStringForKey:(NSString *)key {
    return [defaults stringForKey:key];
}

+ (void)setString:(NSString *)string ForKey:(NSString *)key {
    [defaults setObject:string forKey:key];
    [defaults synchronize];
}

+ (CGFloat)getNumberForKey:(NSString *)key{
    return [defaults floatForKey:key];
}

+ (void)setNumber:(CGFloat)afloat ForKey:(NSString *)key{
    [defaults setObject:[NSNumber numberWithFloat:afloat] forKey:key];
    [defaults synchronize];
}

+ (BOOL)getBooleanForKey:(NSString *)key{
    return [defaults boolForKey:key];
}

+ (void)setBoolean:(BOOL)abool ForKey:(NSString *)key{
    [defaults setObject:[NSNumber numberWithBool:abool] forKey:key];
    [defaults synchronize];    
}

@end
