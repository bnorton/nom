//
//  NMFBModel.h
//  nom
//
//  Created by Brian Norton on 11/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Facebook.h"

#define FB_BASE     @"https://graph.facebook.com/"
#define FB_ME       @"me"
#define FB_FRIENDS  @"me/friends?fields=id,name,location,picture,email"

#define FB_SUCCESS_MESSAGE @"OK, We've Connected Nom to Facebook"

@interface NMFBModel : NSObject <FBRequestDelegate, FBDialogDelegate, FBLoginDialogDelegate, FBSessionDelegate> {
    
    void (^auth_success)(void);
    void (^auth_failure)(void);

    void (^me_success)(NSDictionary *me);
    void (^me_failure)(NSDictionary *me);

    void (^me_friends_success)(NSDictionary *friends);
    void (^me_friends_failure)(NSDictionary *friends);
        
    NSDictionary *_me;
    NSDictionary *_mefriends;
    
}

- (id)init;

-(void)authorizeWithSuccess:(void (^)())success
                    failure:(void (^)())failure;

-(void)meWithSuccess:(void (^)(NSDictionary * response))success
             failure:(void (^)(NSDictionary * response))failure;

- (void)meFriendsWithSuccess:(void (^)(NSDictionary * response))success
                     failure:(void (^)(NSDictionary * response))failure;
@end
