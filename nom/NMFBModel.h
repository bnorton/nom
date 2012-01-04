//
//  NMFBModel.h
//  nom
//
//  Created by Brian Norton on 11/28/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Facebook.h"

#define FB_BASE     @"https://graph.facebook.com/"
#define FB_ME       @"me"
#define FB_FRIENDS  @"me/friends?fields=id,name,location,picture,email"

#define FB_SUCCESS_MESSAGE @"OK, We've Connected to FB"

#define FB_TITLE        @"Nommed @ %@."
#define FB_CAPTION      @"...used Nom in %@"
#define FB_TITLE_AND_DISH @"I just Nommed at %@ and had %@"

#define FB_PUBLISH_LINK         @"http://justnom.it/r/%@"
#define FB_ACTION_LINK  @"http://justnom.it/itunes"

#define FB_ACTION_NAME  @"Nom to Find & Recommend"


@interface NMFBModel : NSObject <FBRequestDelegate, FBDialogDelegate, FBLoginDialogDelegate, FBSessionDelegate> {
    
    void (^auth_success)(void);
    void (^auth_failure)(void);

    void (^me_success)(NSDictionary *me);
    void (^me_failure)(NSDictionary *me);

    void (^me_friends_success)(NSDictionary *friends);
    void (^me_friends_failure)(NSDictionary *friends);

    void (^publish_success)(void);
    void (^publish_failure)(void);

    NSDictionary *_me;
    NSDictionary *_mefriends;
    
}

- (id)init;

- (void)authorizeWithSuccess:(void (^)())success
                    failure:(void (^)())failure;

-(void)registerMeSeccuess:(void (^)())meSuccess
                meFailure:(void (^)())meFailure;

- (void)meWithSuccess:(void (^)(NSDictionary * response))success
              failure:(void (^)(NSDictionary * response))failure;

- (void)meFriendsWithSuccess:(void (^)(NSDictionary * response))success
                     failure:(void (^)(NSDictionary * response))failure;

- (void)publish:(NSString *)body locationName:(NSString *)location_name 
           city:(NSString *)city imageUrl:(NSString *)image token:(NSString *)token
        success:(void (^)(void))success
        failure:(void (^)(void))failure;
@end
