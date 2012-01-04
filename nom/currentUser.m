//
//  currentUser.m
//  nom
//
//  Created by Brian Norton on 11/16/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import "currentUser.h"

@implementation currentUser

static NSUserDefaults *defaults = nil;
static NSMutableDictionary *user = nil;

+ (void)loadCurrentUser {
    if ([[defaults objectForKey:@"auth_token"] length] > 0) { [user setObject:[defaults objectForKey:@"auth_token"] forKey:@"auth_token"]; }
    if ([[defaults objectForKey:@"user_nid"] length] > 0)   { [user setObject:[defaults objectForKey:@"user_nid"] forKey:@"user_nid"]; }
    if ([[defaults objectForKey:@"email"] length] > 0)      { [user setObject:[defaults objectForKey:@"email"] forKey:@"email"]; }
    if ([[defaults objectForKey:@"name"] length] > 0)       { [user setObject:[defaults objectForKey:@"name"] forKey:@"name"]; }
    if ([[defaults objectForKey:@"screen_name"] length] > 0){ [user setObject:[defaults objectForKey:@"screen_name"] forKey:@"screen_name"]; }
    if ([[defaults objectForKey:@"image_url"] length] > 0)  { [user setObject:[defaults objectForKey:@"image_url"] forKey:@"image_url"]; }
    if ([[defaults objectForKey:@"created_at"] length] > 0) { [user setObject:[defaults objectForKey:@"created_at"] forKey:@"created_at"]; }
    if ([[defaults objectForKey:@"updated_at"] length] > 0) { [user setObject:[defaults objectForKey:@"updated_at"] forKey:@"updated_at"]; }
    if ([[defaults objectForKey:@"city"] length] > 0)       { [user setObject:[defaults objectForKey:@"city"] forKey:@"city"]; }
    if ([[defaults objectForKey:@"follower_count"] length] > 0){ [user setObject:[defaults objectForKey:@"follower_count"] forKey:@"follower_count"]; }

}

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        defaults = [NSUserDefaults standardUserDefaults];
        
        user = [[NSMutableDictionary alloc] initWithCapacity:20];
        
        [currentUser loadCurrentUser];
        [currentUser setLoggedIn];
    }
}

+ (NSDictionary *)user {
    return user;
}

+ (void)setDate:(NSDate *)date forKey:(NSString *)key {
    [currentUser setNumber:[date timeIntervalSince1970] ForKey:key];
}

+ (NSDate *)getDateForKey:(NSString *)key {
    CGFloat then = [currentUser getNumberForKey:key];
    NSDate *is_now = [NSDate date];
    CGFloat now = [is_now timeIntervalSince1970];
    return [NSDate dateWithTimeInterval:(now - then) sinceDate:is_now];
}

+ (NSString *)getStringForKey:(NSString *)key {
    return [defaults stringForKey:key];
}

+ (void)setString:(NSString *)string ForKey:(NSString *)key {
    [defaults setObject:[string copy] forKey:key];
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

+ (void)setUser:(NSDictionary *)_user {
    if (_user != nil) {
        if ([[_user objectForKey:@"auth_token"] length] > 0) { [defaults setObject:[_user objectForKey:@"auth_token"] forKey:@"auth_token"]; }
        if ([[_user objectForKey:@"user_nid"] length] > 0)   { [defaults setObject:[_user objectForKey:@"user_nid"] forKey:@"user_nid"]; }
        if ([[_user objectForKey:@"email"] length] > 0)      { [defaults setObject:[_user objectForKey:@"email"] forKey:@"email"]; }
        if ([[_user objectForKey:@"name"] length] > 0)       { [defaults setObject:[_user objectForKey:@"name"] forKey:@"name"]; }
        if ([[_user objectForKey:@"screen_name"] length] > 0){ [defaults setObject:[_user objectForKey:@"screen_name"] forKey:@"screen_name"]; }
        if ([[_user objectForKey:@"image_url"] length] > 0)  { [defaults setObject:[_user objectForKey:@"image_url"] forKey:@"image_url"]; }
        if ([[_user objectForKey:@"created_at"] length] > 0) { [defaults setObject:[_user objectForKey:@"created_at"] forKey:@"created_at"]; }
        if ([[_user objectForKey:@"updated_at"] length] > 0) { [defaults setObject:[_user objectForKey:@"updated_at"] forKey:@"updated_at"]; }
        if ([[_user objectForKey:@"city"] length] > 0)       { [defaults setObject:[_user objectForKey:@"city"] forKey:@"city"]; }
        if ([[_user objectForKey:@"follower_count"] length] > 0){ [defaults setObject:[_user objectForKey:@"follower_count"] forKey:@"follower_count"]; }
        
        [defaults synchronize];
        
        [currentUser loadCurrentUser];
        [currentUser setLoggedIn];
    }
    
    
}

+ (NSDictionary *)getUser {
    return user;
}

+ (void)setLoggedIn {
    if ([user objectForKey:@"auth_token"]) {
        [currentUser setBoolean:YES ForKey:@"user_logged_in"];
        [currentUser setBoolean:YES ForKey:@"logged_in_or_connected"];
    } else {
        [currentUser setBoolean:NO ForKey:@"user_logged_in"];
        [currentUser setBoolean:NO ForKey:@"logged_in_or_connected"];
    }
}

+ (id)getObjectForKey:(NSString *)key{
    return [defaults objectForKey:key];
}

+ (void)setObject:(id)obj forKey:(NSString *)key{
    [defaults setObject:obj forKey:key];
    [defaults synchronize];    
}


@end

/*
{
    "auth_token" = 995b5fc73c400b0eb8a878caec0c49778e8c2322feaccd30ca6e0904ff8b0c9e;
    city = "San Francisco";
    country = "US";
    "created_at" = "2011-11-24T21:07:39Z";
    description = "<null>";
    email = "hey.i.am.brian@gmail.com";
    facebook = "<null>";
    "follower_count" = "<null>";
    "has_joined" = 1;
    id = 5;
    "image_url" = "http://img.justnom.it.s3.aws.etc/image_file.png";
    "last_seen" = "2011-11-24 21:07:39";
    name = "<null>";
    nid = 4eceb21beef0a652cb000001;
    phone = "<null>";
    "screen_name" = "<null>";
    street = "<null>";
    twitter = "<null>";
    url = "<null>";
} 
*/