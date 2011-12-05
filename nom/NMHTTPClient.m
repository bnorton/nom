//
//  NMAPIClient.m
//  nom
//
//  Created by Brian Norton on 11/15/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import "NMHTTPClient.h"
#import "NSData+SSToolkitAdditions.h"
#import "AFHTTPRequestOperation.h"
@implementation NMHTTPClient

+ (void)showInfo:(NSString *)path params:(NSDictionary *)params request:(NSMutableURLRequest*)request {
    NSLog(@"INFO: calling out to %@ with params %@ \n and request object %@\n\n================================",path,params,request);
}

+ (void)addDefaultParams:(NSMutableDictionary *)params {
    /**
     * Setup default params if we dont already have them
     */
    if( ! [params objectForKey:@"user_nid"]) {
        NSString *user_nid = [currentUser getStringForKey:@"user_nid"];
        if (user_nid) { [params setObject:user_nid forKey:@"user_nid"]; }
        
        /* Add the auth_token of the user_nid comes from current_user */
        NSString *auth_token = [currentUser getStringForKey:@"auth_token"];
        if (auth_token) { [params setObject:auth_token forKey:@"auth_token"]; }
    }
        
    NSNumber *lat = [NSNumber numberWithFloat:[currentLocation lat]];
    if (lat) { [params setObject:lat forKey:@"lat"]; }
    
    NSNumber *lng = [NSNumber numberWithFloat:[currentLocation lng]];
    if (lat) { [params setObject:lng forKey:@"lng"]; }

}

+ (void)enqueueRequestWithMethod:(NSString *)method path:(NSString *)path 
                      parameters:(NSMutableDictionary *)parameters
                   success:(void (^)(NSDictionary * response))success
                   failure:(void (^)(NSDictionary * response))failure {
        
    if (!parameters) { parameters = [[NSMutableDictionary alloc] initWithCapacity:4]; }
    
    [NMHTTPClient addDefaultParams:parameters];
    
    NSMutableURLRequest *request = [HTTPClient requestWithMethod:method path:path parameters:parameters];
    
    [self showInfo:path params:parameters request:request];

    AFJSONRequestOperation * operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request 
      success:^(NSURLRequest *request, NSURLResponse *response, id JSON) {
        if (success) { 
            NSLog(@"INFO: success callback for %@",path);
            success(JSON); 
        }
        else {NSLog(@"WARN: %@ has no success callback registered for patameters %@", path, parameters);}
    } failure:^(NSURLRequest *request, NSURLResponse *response, NSError *error, id JSON) {
        if (failure) { NSLog(@"INFO failure callback %@ for %@ and %@",error, path, JSON);
            failure(JSON);
        } else {NSLog(@"WARN: %@ has no failure callback registered for patameters %@", path, parameters);}
    }];
    
    [HTTPQueue addOperation:operation];
}

/**
 * User Management

 #############################################################################
 #####  USERS  ###############################################################
 #############################################################################

 POST => "/users/register"
 POST => "/users/login"
 
 GET => "/users/me"
 POST "/users/check"
 
 get "/users/search"
 get "/users/:nid/detail"
 
 #############################################################################
 #############################################################################
 */

+ (void)registerUserEmail:(NSString *)email password:(NSString *)password screen_name:(NSString *)screen_name
                  success:(void (^)(NSDictionary * response))success
                  failure:(void (^)(NSDictionary * response))failure {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithCapacity:3];
    
    if (email)       { [parameters setObject:email forKey:@"email"]; }
    if (password)    { [parameters setObject:password forKey:@"password"]; }
    if (screen_name) { [parameters setObject:screen_name forKey:@"screen_name"]; }
    
    [NMHTTPClient enqueueRequestWithMethod:@"POST" path:@"/users/register.json" parameters:parameters success:success failure:failure];
}

+ (void)registerUserFacebook:(NSDictionary *)facebook
                  success:(void (^)(NSDictionary * response))success
                  failure:(void (^)(NSDictionary * response))failure {
    id fb;
    @try { fb = [[util JSONWriter] stringWithObject:facebook]; }
    @catch (NSException *ex) { fb = facebook; }
    
    NSArray *items  = [NSArray arrayWithObjects:fb, @"facebook", nil];
    NSArray *params = [NSArray arrayWithObjects:@"fbhash", @"regtype", nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:items forKeys:params];
    
    [parameters setObject:[currentUser getStringForKey:@"fb_access_token"] forKey:@"fb_access_token"];
    
    [NMHTTPClient enqueueRequestWithMethod:@"POST" path:@"/users/register.json" parameters:parameters success:success failure:failure];
    
}

+ (void)loginIdentifier:(NSString *)email_or_screen_name password:(NSString *)password 
                success:(void (^)(NSDictionary * response))success
                failure:(void (^)(NSDictionary * response))failure {
    
    NSArray *items  = [NSArray arrayWithObjects:email_or_screen_name, password,nil];
    NSArray *params = [NSArray arrayWithObjects:@"email",@"password", nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:items forKeys:params];
    
    [NMHTTPClient enqueueRequestWithMethod:@"POST" path:@"/users/login.json" parameters:parameters success:success failure:failure];
    
}

+(void)meWithSuccess:(void (^)(NSDictionary * response))success 
             failure:(void (^)(NSDictionary * response))failure {
    [NMHTTPClient enqueueRequestWithMethod:@"POST" path:@"/users/me.json" parameters:nil success:success failure:failure];
}

+(void)screenNameCheck:(NSString *)screen_names success:(void (^)(NSDictionary * response))success 
               failure:(void (^)(NSDictionary * response))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObject:screen_names forKey:@"screen_name"];
    [NMHTTPClient enqueueRequestWithMethod:@"POST" path:@"/users/check.json" parameters:parameters success:success failure:failure];
}

+(void)userDetail:(NSString *)user_nid success:(void (^)(NSDictionary * response))success 
               failure:(void (^)(NSDictionary * response))failure {
    [NMHTTPClient enqueueRequestWithMethod:@"GET" path:[NSString stringWithFormat:@"/users/%@/detail.json", user_nid] parameters:nil success:success failure:failure];
}


/**
 * Location Based Services
 
 #############################################################################
 #####  LOCATIONS  ###########################################################
 #############################################################################
 
 POST => "/locations/new"
 GET => "/locations/here"
 GET => "/locations/search" 
 
 #############################################################################
 #############################################################################
 */

/** Location Based Services */

+ (void)here:(CGFloat)distance categories:(NSString *)categories cost:(NSString *)cost
                success:(void (^)(NSDictionary * response))success
                failure:(void (^)(NSDictionary * response))failure {
    
    NSMutableArray *items  = [[NSMutableArray alloc] initWithCapacity:4];
    NSMutableArray *params = [[NSMutableArray alloc] initWithCapacity:4];
    /* @optional */
    if (distance < 0.25) { distance = 0.5f; }
    if (distance > 5.0f) { distance = 5.0f; }
    
    [items addObject:[NSString stringWithFormat:@"%f", distance]];
    [params addObject:@"dist"];
    [items addObject:[NSString stringWithFormat:@"%d", 50]];
    [params addObject:@"limit"];
    /* @optional */
    if (categories) {
        [items addObject:[categories componentsSeparatedByString:@","]];
        [params addObject:@"categories"];
    }
    /* @optional */
    if (cost) {
        [items addObject:cost];
        [params addObject:@"cost"];
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:items forKeys:params];
    
    [NMHTTPClient enqueueRequestWithMethod:@"GET" path:@"/locations/here.json" parameters:parameters success:success failure:failure];
    
}

/** Location :: Search / User :: Search */

+ (void)search:(NSString *)identifier path:(NSString *)path
                success:(void (^)(NSDictionary * response))success
                failure:(void (^)(NSDictionary * response))failure {
    
    NSArray *items  = [NSArray arrayWithObjects:identifier, nil];
    NSArray *params = [NSArray arrayWithObjects:@"query", nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:items forKeys:params];
    
    [NMHTTPClient enqueueRequestWithMethod:@"GET" path:path parameters:parameters success:success failure:failure];
    
}
+ (void)searchUser:(NSString *)identifier
           success:(void (^)(NSDictionary * response))success
           failure:(void (^)(NSDictionary * response))failure {
    
    [NMHTTPClient search:identifier path:@"/users/search.json" success:success failure:failure];
}

+ (void)searchLocation:(NSString *)identifier
           success:(void (^)(NSDictionary * response))success
           failure:(void (^)(NSDictionary * response))failure {
    
    [NMHTTPClient search:identifier path:@"/locations/search.json" success:success failure:failure];
}

/**
 * Category fetching
 */

+ (void)categoriesWithSuccess:(void (^)(NSDictionary * response))success
     failure:(void (^)(NSDictionary * response))failure {
    
    [NMHTTPClient enqueueRequestWithMethod:@"POST" path:@"/categories/all.json" 
                                parameters:nil success:success failure:failure];
    
}

+ (void)categoriesForLocation:(NSString*)location_nid 
                      success:(void (^)(NSDictionary * response))success
                      failure:(void (^)(NSDictionary * response))failure {
    
    [NMHTTPClient enqueueRequestWithMethod:@"POST" path:[NSString stringWithFormat:@"/locations/%@/categories.json", location_nid] 
                                parameters:nil success:success failure:failure];
    
}

/**
 * Thumbs
 
 #############################################################################
 #####  THUMBS  ##############################################################
 #############################################################################
 
 POST => "locations/:nid/thumbs/new"
 POST => "users/:nid/thumbs/new"
 
 #############################################################################
 #############################################################################
 */

+ (void)thumbValue:(NSString *)value path:(NSString *)path
                success:(void (^)(NSDictionary * response))success
                failure:(void (^)(NSDictionary * response))failure {

    NSArray *items  = [NSArray arrayWithObjects:value,nil];
    NSArray *params = [NSArray arrayWithObjects:@"value",nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:items forKeys:params];
    
    [NMHTTPClient enqueueRequestWithMethod:@"POST" path:path parameters:parameters success:success failure:failure];

}

+ (void)thumbLocation:(NSString *)location_nid value:(NSString *)value
                success:(void (^)(NSDictionary * response))success
                failure:(void (^)(NSDictionary * response))failure {
    
    [NMHTTPClient thumbValue:value path:[NSString stringWithFormat:@"/locations/%@/thumbs/create.json",location_nid] 
                success:success failure:failure];
    
}

+ (void)thumbUser:(NSString *)their_user_nid value:(NSString *)value
                success:(void (^)(NSDictionary * response))success
                failure:(void (^)(NSDictionary * response))failure {
    
    [NMHTTPClient thumbValue:value path:[NSString stringWithFormat:@"/users/%@/thumbs/create.json",their_user_nid] 
                     success:success failure:failure];
    
}

/**
 * Posting to networks
 */

+ (void)publish:(NSString *)bl success:(void (^)(NSDictionary * response))success
     failure:(void (^)(NSDictionary * response))failure {
    
    NSArray *items  = [NSArray arrayWithObjects:bl,nil];
    NSArray *params = [NSArray arrayWithObjects: nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:items forKeys:params];
    
    [NMHTTPClient enqueueRequestWithMethod:@"POST" path:@"/users/register.json" parameters:parameters success:success failure:failure];
    
}

/**
 * Ranking
 
 #############################################################################
 #####  RANKING  #############################################################
 #############################################################################
 get "/rankings/new"           => "rankings#new"                       ## POST
 get "/rankings/destory"       => "rankings#destory"                   ## POST
 
 get "user/:nid/ranked"        => "rankings#user"
 get "location/:nid/rankings"  => "rankings#location"

 #############################################################################
 #############################################################################
 */
+ (void)rank:(NSString *)location_nid value:(NSString *)rank_value 
                success:(void (^)(NSDictionary * response))success
                failure:(void (^)(NSDictionary * response))failure {
    
    NSArray *items  = [NSArray arrayWithObjects:location_nid, nil];
    NSArray *params = [NSArray arrayWithObjects:@"location_nid", nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:items forKeys:params];
    
    [NMHTTPClient enqueueRequestWithMethod:@"POST" path:@"/users/register.json" parameters:parameters success:success failure:failure];
    
}

+ (void)removeRank:(NSString *)rank_nid 
                success:(void (^)(NSDictionary * response))success
                failure:(void (^)(NSDictionary * response))failure {
    
    NSArray *items  = [NSArray arrayWithObjects:rank_nid, nil];
    NSArray *params = [NSArray arrayWithObjects:@"rank_nid", nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:items forKeys:params];
    
    [NMHTTPClient enqueueRequestWithMethod:@"POST" path:@"/users/register.json" parameters:parameters success:success failure:failure];
    
}



/**
 * Recommendations
 
 #############################################################################
 #####  RECOMMENDATIONS  #####################################################
 #############################################################################
 get "/recommendation/new"          => "recommendations#new"          ### POST
 get "/recommendation/destroy"      => "recommendations#destroy"      ### POST
 
 get "/users/:nid/recommended"    => "recommendations#user"
 get "/locations/:nid/recommended"=> "recommendations#location"
 
 #############################################################################
 #############################################################################
 */

+ (void)recommend:(NSString *)location_nid text:(NSString *)text facebook:(BOOL)facebook
                    success:(void (^)(NSDictionary * response))success
                    failure:(void (^)(NSDictionary * response))failure
                    progress:(void (^)(NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite))progress {
    
    NSArray *items  = [NSArray arrayWithObjects:location_nid, text,[NSNumber numberWithBool:NO], nil];
    NSArray *params = [NSArray arrayWithObjects:@"location_nid",@"text",@"image_attachment_present", nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:items forKeys:params];
    
    if (facebook) { [parameters setObject:[NSNumber numberWithBool:YES] forKey:@"facebook"]; }
    
    /**
     * Build the image and the image metadata
     */
    BOOL image_flag = FALSE;
    NSData *image_data = nil;
    NSString *file_name = nil;
    
    if ([currentUser getBooleanForKey:@"image_attachment_present?"]) {
        UIImage *attachment = [UIImage imageNamed:[currentUser getStringForKey:@"image_attachment"]];
        if (attachment) {
            image_data = UIImagePNGRepresentation(attachment);
            if ([image_data length] > 0) {
                image_flag = TRUE;
                file_name = [NSString stringWithFormat:@"%@.png", [image_data SHA1Sum]];
                [parameters setObject:[NSNumber numberWithBool:YES] forKey:@"image_attachment_present"];
            }
        }
    }
    
    /**
     * Construct and begin the request with callbacks
     */
    NSMutableURLRequest *request = [HTTPClient multipartFormRequestWithMethod:@"POST" path:@"/recommendations/create.json" parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        if (image_flag) { 
           [formData appendPartWithFileData:image_data name:@"image[image]" fileName:file_name mimeType:@"image/png"];
        }
    }];

    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) { NSLog(@"DONE %@", responseObject);
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) { NSLog(@"FAIL %@", error);
        if (failure) {
            failure([(AFJSONRequestOperation *)operation responseJSON]);
        }
    }];
    [operation setUploadProgressBlock:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
        NSLog(@" %d Sent %d of %d bytes",bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
        if (progress) {
            progress(totalBytesWritten,totalBytesExpectedToWrite);
        }
    }];
    [[[NSOperationQueue alloc] init] addOperation:operation];
//    [HTTPQueue addOperation:operation];
}

/**
 * Following / Followers
 
 #############################################################################
 #####  FOLLOWERS  ###########################################################
 #############################################################################
 POST => '/follow/new'
 POST => '/follow/destroy'
 
 GET =>'/followers'
 GET => '/following'

 #############################################################################
 #############################################################################
 */


+ (void)followAction:(NSString *)path otherUserId:(NSString *)other_user_nid 
           success:(void (^)(NSDictionary * response))success
           failure:(void (^)(NSDictionary * response))failure {
    
    NSArray *items  = [NSArray arrayWithObjects:other_user_nid, nil];
    NSArray *params = [NSArray arrayWithObjects:@"other_user_nid", nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:items forKeys:params];
    
    [NMHTTPClient enqueueRequestWithMethod:@"POST" path:path parameters:parameters success:success failure:failure];
    
}

+ (void)follow:(NSString *)other_user_nid 
       success:(void (^)(NSDictionary * response))success
       failure:(void (^)(NSDictionary * response))failure {
    
    [NMHTTPClient followAction:@"/followers/create.json" otherUserId:other_user_nid success:success failure:failure];
    
}

+ (void)unFollow:(NSString *)other_user_nid 
       success:(void (^)(NSDictionary * response))success
       failure:(void (^)(NSDictionary * response))failure {
    
    [NMHTTPClient followAction:@"/followers/destroy.json" otherUserId:other_user_nid success:success failure:failure];
    
}

+ (void)followFor:(NSString *)user_nid path:(NSString *)path success:(void (^)(NSDictionary * response))success
          failure:(void (^)(NSDictionary * response))failure {
    
    NSMutableDictionary *params = nil;
    if ( ! [user_nid isEqualToString:[currentUser getStringForKey:@"user_nid"]]) {
        params = [NSMutableDictionary dictionaryWithObject:user_nid forKey:@"user_nid"];
    }
    [NMHTTPClient enqueueRequestWithMethod:@"GET" path:path parameters:params success:success failure:failure];
    
}

+ (void)followersFor:(NSString *)user_nid withSuccess:(void (^)(NSDictionary * response))success
             failure:(void (^)(NSDictionary * response))failure {
    
    [NMHTTPClient followFor:user_nid path:@"/followers.json" success:success failure:failure];
}

+ (void)followingFor:(NSString *)user_nid withSuccess:(void (^)(NSDictionary * response))success
             failure:(void (^)(NSDictionary * response))failure {
    
    [NMHTTPClient followFor:user_nid path:@"/following.json" success:success failure:failure];    
}

/**
 * Comments
 
 #############################################################################
 #####  COMMENTS  ############################################################
 #############################################################################
 get "/recommendation/:nid/comments"
 get "/location/:nid/comments"
 get "/user/:nid/comments"
 
 GET => "/comments/search"
 POST => "/comment/new"
 POST => "/comment/destroy"
 #############################################################################
 #############################################################################
 */


+ (void)commentAboutLocation:(NSString *)location_nid text:(NSString *)text inResponseTo:(NSString *)response_to
                success:(void (^)(NSDictionary * response))success
                failure:(void (^)(NSDictionary * response))failure {
    
    NSArray *items  = [NSArray arrayWithObjects:location_nid,response_to,nil];
    NSArray *params = [NSArray arrayWithObjects:@"location_nid",@"parent_nid", nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:items forKeys:params];
    
    [NMHTTPClient enqueueRequestWithMethod:@"POST" path:@"/comments/create.json" parameters:parameters success:success failure:failure];
    
}

+ (void)commentOnUser:(NSString *)about_user_nid text:(NSString *)text inResponseTo:(NSString *)response_to
                     success:(void (^)(NSDictionary * response))success
                     failure:(void (^)(NSDictionary * response))failure {
    
    NSArray *items  = [NSArray arrayWithObjects:about_user_nid,response_to,nil];
    NSArray *params = [NSArray arrayWithObjects:@"location_nid",@"parent_nid", nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:items forKeys:params];
    
    [NMHTTPClient enqueueRequestWithMethod:@"POST" path:@"/comments/create.json" parameters:parameters success:success failure:failure];
    
}

+ (void)commentOnRecommendation:(NSString *)recommendation_nid text:(NSString *)text inResponseTo:(NSString *)response_to
                     success:(void (^)(NSDictionary * response))success
                     failure:(void (^)(NSDictionary * response))failure {
    
    NSArray *items  = [NSArray arrayWithObjects:recommendation_nid,response_to,nil];
    NSArray *params = [NSArray arrayWithObjects:@"recommendation_nid",@"parent_nid", nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:items forKeys:params];
    
    [NMHTTPClient enqueueRequestWithMethod:@"POST" path:@"/comments/create.json" parameters:parameters success:success failure:failure];
    
}

+ (void)commentDestroy:(NSString *)comment_nid
                        success:(void (^)(NSDictionary * response))success
                        failure:(void (^)(NSDictionary * response))failure {
    
    NSArray *items  = [NSArray arrayWithObjects:comment_nid,nil];
    NSArray *params = [NSArray arrayWithObjects:@"comment_nid",nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:items forKeys:params];
    
    [NMHTTPClient enqueueRequestWithMethod:@"POST" path:@"/comments/destroy.json" parameters:parameters success:success failure:failure];
    
}

/**
 * Activities
 #############################################################################
 #####  ACTIVITIES  ##########################################################
 #############################################################################
 GET => '/activties'

 #############################################################################
 #############################################################################
 */

+ (void)activitiesWithSuccess:(void (^)(NSDictionary * response))success
                      failure:(void (^)(NSDictionary * response))failure {
 
    [NMHTTPClient enqueueRequestWithMethod:@"GET" path:@"/activities.json" parameters:nil success:success failure:failure];
    
}

+ (void)usersActivities:(NSString *)user withSuccess:(void (^)(NSDictionary * response))success
                failure:(void (^)(NSDictionary * response))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"by_user"];
    [params setObject:user forKey:@"by_user_nid"];
    [NMHTTPClient enqueueRequestWithMethod:@"GET" path:@"/activities.json" parameters:params success:success failure:failure];
    
}

/*
+ (void)imageUpload:(NSString *)location_nid
            success:(void (^)(NSDictionary * response))success
            failure:(void (^)(NSDictionary * response))failure
           progress:(void (^)(NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite))progress {

    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setObject:@"user1" forKey:@"user_nid"];
    [params setObject:@"location1" forKey:@"location_nid"];
    NSData *data = UIImageJPEGRepresentation([UIImage imageNamed:@"blue_brian.jpg"], 0.5);

//    [params setObject:[NSString stringWithFormat:@"%@.jpg", [data SHA1Sum]] forKey:@"image[original_filename]"];
//    [params setObject:@"image/jpeg" forKey:@"image[content_type]"];
//    [params setObject:[NSNumber numberWithInteger:[data length]] forKey:@"image[file_size]"];


    NSMutableURLRequest *request = [HTTPClient multipartFormRequestWithMethod:@"POST" path:@"/image/create.json" parameters:params constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData:data name:@"image[image]" fileName:[NSString stringWithFormat:@"%@.jpg", [data SHA1Sum]] mimeType:@"image/jpeg"];
    }];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSURLResponse *response, id JSON) {
        NSLog(@"INFO: image upload done: %@", JSON);
    } failure:^(NSURLRequest *request, NSURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure callback for imageUpload %@", JSON);
    }];

    
//    AFHTTPRequestOperation *operation = [AFHTTPRequestOperation operationWithRequest:request completion:^(NSURLRequest *request, NSHTTPURLResponse *response, NSData *data, NSError *error) {
//        NSLog(@"Upload Complete");
//    }];

    [operation setUploadProgressBlock:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
        NSLog(@"Sent %d of %d bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    
    
}
*/

/**
 * Upload Arbitrary Image
 ############################################################################
 #####  Image  ##############################################################
 ############################################################################
 
 ############################################################################
 */
+ (void)imageUpload:(NSString *)location_nid
          success:(void (^)(NSDictionary * response))success
          failure:(void (^)(NSDictionary * response))failure
         progress:(void (^)(NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite))progress {
    
    NSArray *items  = [NSArray arrayWithObjects:location_nid,[NSNumber numberWithBool:YES], nil];
    NSArray *params = [NSArray arrayWithObjects:@"location_nid",@"image_attachment_present", nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:items forKeys:params];
    
    [NMHTTPClient addDefaultParams:parameters];
    NSLog(@"formdata params %@", parameters);
    
    /**
     * Build the image and the image metadata
     */
    BOOL image_flag = FALSE;
    NSData *image_data = nil;
    NSString *target_file_name = nil;
    NSString *image_presence_key = [NSString stringWithFormat:@"%@_image_present?",location_nid];
    __block NSString *image_filepath_key = [NSString stringWithFormat:@"%@_image_path",location_nid];
    
    if ([currentUser getBooleanForKey:image_presence_key]) {
        NSString *path = [currentUser getStringForKey:image_filepath_key];
        NSFileManager *filemgr = [NSFileManager defaultManager];
        image_data = [filemgr contentsAtPath: path ];
        NSLog(@"data size %d", [image_data length]);
        
        if ([image_data length] > 0) {
            image_flag = TRUE;
            target_file_name = [NSString stringWithFormat:@"%@.png", [image_data SHA1Sum]];
        }
    } 
    if (! image_flag) {
        if (failure) {
            failure(nil);
            return;
        }
    }
    /**
     * Construct and begin the request with callbacks
     */
    NSMutableURLRequest *request = [HTTPClient multipartFormRequestWithMethod:@"POST" path:@"/image/create.json" 
                    parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData:image_data name:@"image[image]" fileName:target_file_name mimeType:@"image/png"];
    }];
    
    NSLog(@"Image Upload Request %@", request);
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSURLResponse *response, id JSON) {
        NSLog(@"INFO: image upload done: %@", JSON);
        NSFileManager *filemgr = [NSFileManager defaultManager];
        NSString *path = [currentUser getStringForKey:image_filepath_key];
        if ([filemgr removeItemAtPath: path error: NULL]  == YES) {
            NSLog (@"Remove successful"); 
        } else {
            NSLog (@"Remove failed"); 
        }
    
    } failure:^(NSURLRequest *request, NSURLResponse *response, NSError *error, id JSON) {
            NSLog(@"failure callback for imageUpload %@", JSON);
    }];
        
    [operation setUploadProgressBlock:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
        NSLog(@" %d Sent %d of %d bytes",bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
        if (progress) {
            progress(totalBytesWritten,totalBytesExpectedToWrite);
        }
    }];

    [HTTPQueue addOperation:operation];

}

@end
