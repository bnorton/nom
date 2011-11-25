//
//  currentUser.h
//  nom
//
//  Created by Brian Norton on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface currentUser : NSObject

+ (NSString *)getStringForKey:(NSString *)key;
+ (void)setNumber:(CGFloat)num ForKey:(NSString *)key;

+ (CGFloat)getNumberForKey:(NSString *)key;
+ (void)setString:(NSString *)string ForKey:(NSString *)key;

+ (BOOL)getBooleanForKey:(NSString *)key;
+ (void)setBoolean:(BOOL)abool ForKey:(NSString *)key;

+ (void)setDate:(NSDate *)date forKey:(NSString *)key;
+ (NSDate *)getDateForKey:(NSString *)key;

+ (void)setUser:(NSDictionary *)user;
+ (NSDictionary *)getUser;

+ (void)setLoggedIn;

@end
