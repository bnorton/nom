//
//  NMAPIClient.h
//  nom
//
//  Created by Brian Norton on 11/15/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import <MobileCoreServices/UTCoreTypes.h>
#import "AFHTTPClient.h"
#import "Util.h"
#import "currentUser.h"
#import "currentLocation.h"
#import "AFNetworking.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"


@interface NMHTTPClient : AFHTTPClient 

/* ######################################################################
 * ########################### USER #####################################
 */
+ (void)registerUserEmail:(NSString *)email password:(NSString *)password screen_name:(NSString *)screen_name
                    success:(void (^)(NSDictionary * response))success
                    failure:(void (^)(NSDictionary * response))failure;

+ (void)registerUserFacebook:(NSDictionary *)facebook
                    success:(void (^)(NSDictionary * response))success
                    failure:(void (^)(NSDictionary * response))failure;

+ (void)loginIdentifier:(NSString *)email_or_screen_name password:(NSString *)password 
                    success:(void (^)(NSDictionary * response))success
                    failure:(void (^)(NSDictionary * response))failure;

+ (void)meWithSuccess:(void (^)(NSDictionary * response))success 
                    failure:(void (^)(NSDictionary * response))failure;

+ (void)screenNameCheck:(NSString *)screen_names success:(void (^)(NSDictionary * response))success 
                    failure:(void (^)(NSDictionary * response))failure;

+ (void)userDetail:(NSString *)user_nid success:(void (^)(NSDictionary * response))success 
                    failure:(void (^)(NSDictionary * response))failure;

/* ########################### END USER ##################################
 *
 * #######################################################################
 * ########################### LOCATION ##################################
 */
+ (void)here:(CGFloat)distance categories:(NSString *)categories cost:(NSString *)cost limit:(NSUInteger)limit
                    success:(void (^)(NSDictionary * response))success
                    failure:(void (^)(NSDictionary * response))failure;

+ (void)searchUser:(NSString *)identifier
                    success:(void (^)(NSDictionary * response))success
                    failure:(void (^)(NSDictionary * response))failure;

+ (void)searchLocation:(NSString *)identifier location:(NSString *)location
                    success:(void (^)(NSDictionary * response))success
                    failure:(void (^)(NSDictionary * response))failure;
/* ########################### END LOCATION ##############################
 *
 * #######################################################################
 * ########################### THUMBS ####################################
 */
+ (void)thumbLocation:(NSString *)location_nid value:(NSString *)value
                    success:(void (^)(NSDictionary * response))success
                    failure:(void (^)(NSDictionary * response))failure;

+ (void)thumbUser:(NSString *)their_user_nid value:(NSString *)value
                    success:(void (^)(NSDictionary * response))success
                    failure:(void (^)(NSDictionary * response))failure;

/* ########################### END THUMBS ################################
 * #######################################################################
 *
 * ########################### PUBLISHING ################################
 */
+ (void)rank:(NSString *)location_nid value:(NSString *)rank_value 
                    success:(void (^)(NSDictionary * response))success
                    failure:(void (^)(NSDictionary * response))failure;

+ (void)removeRank:(NSString *)rank_nid 
                    success:(void (^)(NSDictionary * response))success
                    failure:(void (^)(NSDictionary * response))failure;

+ (void)recommend:(NSString *)location_nid imageNid:(NSString *)image_nid 
             text:(NSString *)text facebook:(BOOL)facebook token:(NSString *)token
          success:(void (^)(NSDictionary * response))success
          failure:(void (^)(NSDictionary * response))failure;



/* ########################### END PUBLISHING ############################
 * #######################################################################
 *
 * ########################### MISC ######################################
 */
+ (void)categoriesWithSuccess:(void (^)(NSDictionary * response))success
                    failure:(void (^)(NSDictionary * response))failure;



/* ########################### END MISC ##################################
 *
 * #######################################################################
 * ########################### FOLLOWERS #################################
 */

+ (void)follow:(NSString *)other_user_nid 
                    success:(void (^)(NSDictionary * response))success
                    failure:(void (^)(NSDictionary * response))failure;

+ (void)unFollow:(NSString *)other_user_nid 
                    success:(void (^)(NSDictionary * response))success
                    failure:(void (^)(NSDictionary * response))failure;

+ (void)followersFor:(NSString *)user_nid withSuccess:(void (^)(NSDictionary * response))success
             failure:(void (^)(NSDictionary * response))failure;

+ (void)followingFor:(NSString *)user_nid withSuccess:(void (^)(NSDictionary * response))success
             failure:(void (^)(NSDictionary * response))failure;

/* ########################### END FOLLOWERS #############################
 *
 * #######################################################################
 * ########################### COMMENTS ##################################
 */

+ (void)commentAboutLocation:(NSString *)location_nid text:(NSString *)text inResponseTo:(NSString *)response_to
                    success:(void (^)(NSDictionary * response))success
                    failure:(void (^)(NSDictionary * response))failure;

+ (void)commentOnUser:(NSString *)about_user_nid text:(NSString *)text inResponseTo:(NSString *)response_to
                    success:(void (^)(NSDictionary * response))success
                    failure:(void (^)(NSDictionary * response))failure;

+ (void)commentOnRecommendation:(NSString *)recommendation_nid text:(NSString *)text inResponseTo:(NSString *)response_to
                    success:(void (^)(NSDictionary * response))success
                    failure:(void (^)(NSDictionary * response))failure;

+ (void)commentDestroy:(NSString *)comment_nid
                    success:(void (^)(NSDictionary * response))success
                    failure:(void (^)(NSDictionary * response))failure;

/* ########################### END COMMENTS ##############################

 * #######################################################################
 * ########################### ACTIVITIES ################################
 */

+ (void)activitiesWithSuccess:(void (^)(NSDictionary * response))success
                      failure:(void (^)(NSDictionary * response))failure;

+ (void)usersActivities:(NSString *)user withSuccess:(void (^)(NSDictionary * response))success
                        failure:(void (^)(NSDictionary * response))failure;

+ (void)imageUpload:(NSString *)location_nid
            success:(void (^)(NSDictionary * response))success
            failure:(void (^)(NSDictionary * response))failure
           progress:(void (^)(NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite))progress;

+ (void)imageFetch:(id)image_path;
@end
