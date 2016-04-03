
//
//  ICClientCredentialsOAuthTool.m
//  iCnblogs
//
//  Created by poloby on 16/3/5.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICClientCredentialsOAuthTool.h"
#import "ICClientCredentialsOAuth.h"

#import <AFNetworking/AFNetworking.h>

#define ICClientCredentialOAuthToken @"http://api.cnblogs.com/token"
#define ICClientCredentialOAuthFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"client_credentials_oauth.data"]

@implementation ICClientCredentialsOAuthTool

+ (void)save:(ICClientCredentialsOAuth *)oauth
{
    [NSKeyedArchiver archiveRootObject:oauth toFile:ICClientCredentialOAuthFilePath];
}

+ (ICClientCredentialsOAuth *)oauthByStoredData
{
    ICClientCredentialsOAuth *oauth  = [NSKeyedUnarchiver unarchiveObjectWithFile:ICClientCredentialOAuthFilePath];
    return oauth;
}

+ (void)oauthWithClientID:(NSString *)clientID
             clientSecret:(NSString *)clientSecret
                  success:(void (^)(id))success
                  failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:clientID password:clientSecret];
    
    [manager POST:ICClientCredentialOAuthToken parameters:@{@"grant_type" : @"client_credentials"} progress:^(NSProgress * _Nonnull uploadProgress) {
        // empty
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (BOOL)isOAuthInfoExistedInStoredData
{
    ICClientCredentialsOAuth *oauth = [NSKeyedUnarchiver unarchiveObjectWithFile:ICClientCredentialOAuthFilePath];
    
    if (oauth) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isAccessTokenExpired:(ICClientCredentialsOAuth *)oauth
{
    if (oauth) {
        if ([oauth.expires_time compare:[NSDate date]] == NSOrderedDescending) {
            return NO;
        }
    }
    
    return YES;
}

@end
