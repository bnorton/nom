//
//  NMFBModel.m
//  nom
//
//  Created by Brian Norton on 11/28/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import "NMFBModel.h"
#import "NMJSONUtilities.h"
#import "Util.h"

@implementation NMFBModel

+ (void)initialize {
    
}

- (id)init {
    self = [super init];
    if (!self) return nil;
    
    return self;
}

#pragma mark authorization

-(void)__authorize
{
    [[util facebook] setSessionDelegate:self];
    [[util facebook] authorize:[util perms]];
}

-(void)authorizeWithSuccess:(void (^)())success
                    failure:(void (^)())failure {

    auth_success = success;
    auth_failure = failure;
    [self __authorize];
}

-(void)registerMeSeccuess:(void (^)())meSuccess
                meFailure:(void (^)())meFailure {
    me_success = meSuccess;
    me_failure = meFailure;
}

-(void)meWithSuccess:(void (^)(NSDictionary * me))success
             failure:(void (^)(NSDictionary * me))failure {
    
    [[util facebook] setSessionDelegate:self];
    if (_me == nil) {
        me_success = success;
        me_failure = failure;
        [[util facebook] requestWithGraphPath:FB_ME
                                  andDelegate:self];
    } else {
        success(_me);
    }
}

- (void)meFriendsWithSuccess:(void (^)(NSDictionary * response))success
                     failure:(void (^)(NSDictionary * response))failure {

    [[util facebook] setSessionDelegate:self];
    if (_mefriends == nil){
        me_friends_success = success;
        me_friends_failure = failure;
        [[util facebook] requestWithGraphPath:FB_FRIENDS 
                                  andDelegate:self];
    } else {
        success(_mefriends);
    }
}

#pragma mark - FBPublish to Stream
/** Possible Arguments 
 name, caption, description, link, picture, message, source
 */
- (void)publish:(NSString *)body locationName:(NSString *)location_name 
           city:(NSString *)city imageUrl:(NSString *)image token:(NSString *)token
        success:(void (^)(void))success
        failure:(void (^)(void))failure {
    
    if (success) { publish_success = [success copy]; }
    if (failure) { publish_failure = [failure copy]; }
    
    if (! ([location_name length] > 0)) {
        return;
    }
    NSArray* actionLinks = [NSArray arrayWithObjects:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             FB_ACTION_NAME, @"name",
                             FB_ACTION_LINK, @"link", nil], nil];
    
    NSString *actionLinksStr = [NMJSONUtilities jsonStringFrom:actionLinks];
    
    NSString *name = [NSString stringWithFormat:FB_TITLE, location_name];
    
    NSString *caption = body;//[NSString stringWithFormat:FB_CAPTION, city];

    NSString *link = [NSString stringWithFormat:FB_PUBLISH_LINK, token];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   name,           @"name",
                                   caption,        @"caption",
                                   link,           @"link",
                                   image,          @"picture",
                                   actionLinksStr, @"actions",
                                   nil];
    
    NSString *path = [currentUser getStringForKey:@"fb_user_id"];
    path = [NSString stringWithFormat:@"%@/%@", ([path length] > 0 ? 
            [currentUser getStringForKey:@"fb_user_id"] :
            [currentUser getStringForKey:@"fb_user_name"]),@"feed"];
    
    [[util facebook] requestWithGraphPath:path andParams:params 
                            andHttpMethod:@"POST" andDelegate:self];
    
}


#pragma mark - FBSessionDelegate

- (void)fbDidLogin {
    [currentUser setString:[[util facebook] accessToken] ForKey:@"fb_access_token"];
    [currentUser setObject:[[util facebook] expirationDate] forKey:@"fb_expiration_date"];
    [currentUser setBoolean:YES ForKey:@"user_facebook_connected"];
    
    if (auth_success) {
        auth_success();
        auth_success = nil;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self meWithSuccess:me_success failure:me_failure];
    });
}

-(void)fbDidNotLogin:(BOOL)cancelled {
    if (auth_failure) {
        auth_failure();
        auth_failure = nil;
    }
}

- (void)fbDidLogout {
}

#pragma mark FBDialogDelegate

- (void)dialogDidComplete:(FBDialog *)dialog {
    
}

- (void)fbDialogLogin:(NSString*)token expirationDate:(NSDate*)expirationDate {
    [currentUser setString:token ForKey:@"fb_access_token"];
    [currentUser setObject:expirationDate forKey:@"fb_expiration_date"];
    [self fbDidLogin];
    
}

- (void)fbDialogNotLogin:(BOOL)cancelled {
    [self fbDidNotLogin:cancelled];
}


#pragma mark FBRequestDelegate

- (void)request:(FBRequest *)request didLoad:(id)result {
    if ([request.url isEqual:[NSString stringWithFormat:@"%@%@", FB_BASE, FB_ME]]) {
        NSString *uid      = [result objectForKey:@"id"];
        NSString *uname    = [result objectForKey:@"username"];
        NSString *fullname = [result objectForKey:@"name"];
        
        [currentUser setString:uid ForKey:@"fb_user_id"];
        [currentUser setString:uname ForKey:@"fb_user_name"];
        [currentUser setString:fullname ForKey:@"fb_full_name"];
        
        [NMHTTPClient registerUserFacebook:result success:^(NSDictionary *response) {
            @try {
                [currentUser setUser:[[response objectForKey:@"results"] objectAtIndex:0]];
            } @catch (NSException *ex) {;}
            if (me_success) {
                me_success(result);
                me_success = nil;
                me_failure = nil;
            }
        } failure:^(NSDictionary *response) {
            if (me_failure) {
                me_failure(result);
                me_success = nil;
                me_failure = nil;
            }
        }];        
    }
    else if ([request.url isEqual:[NSString stringWithFormat:@"%@%@", FB_BASE, FB_FRIENDS]]){
       
    }
    else if ([[NSString stringWithFormat:@"%@",request.url] 
              rangeOfString:@"feed"].location != NSNotFound) {
        if (publish_success) {
            publish_success();
            publish_success = nil;
            publish_failure = nil;
        }
    }
    else {
    }
    if ([result objectForKey:@"owner"]){
        NSLog(@"Photo upload Success");
    } 
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    if ([[NSString stringWithFormat:@"%@",request.url] 
         rangeOfString:@"feed"].location != NSNotFound) {
        if (publish_failure) {
            publish_failure();
        }
    }
    if ([error code] == 10000 && [[error description] 
                                  rangeOfString:@"couldn’t be completed"].location != NSNotFound) {
        // USER REVOKED ACCESS
        NSLog(@"ERROR NMFBModel possible USER REVOKED ACCESS");
    }
}

/*
2011-11-29 00:27:48.936 nom[13930:707] INFO: calling out to /users/register.json with params {
    "auth_token" = 2085d7a6327b76ab307bb0e587390e42d5877edd7380d27d25e632f2f7a3108b;
    regtype = facebook;
    fbHash =     {
        education = (
         {
             concentration = (
              {
                  id = 104076956295773;
                  name = "Computer Science";
             });
             school = {
                 id = 10111634660;
                 name = "UC Berkeley";
             };
             type = College;
             year = {
                 id = 144044875610606;
                 name = 2011;
             };
         },
         {
             school = {
                 id = 110242592338268;
                 name = "University of California, Berkeley";
             };
             type = College;
             with = (
             {
                 id = 1581904554;
                 name = "Horia Airoh";
             });
         });
        email = "brian.nort@gmail.com";
        "first_name" = Brian;
        gender = male;
        id = 679816146;
        "last_name" = Norton;
        link = "http://www.facebook.com/bnort";
        locale = "en_US";
        location =         {
            id = 114952118516947;
            name = "San Francisco, California";
        };
        name = "Brian Norton";
        timezone = "-8";
        "updated_time" = "2011-10-16T05:54:20+0000";
        username = bnort;
        verified = 1;
    };
    lat = "37.80323";
    lng = "-122.4027";
    "user_nid" = 4eccc0fbeef0a64dcf000001;
} 

*/
@end
