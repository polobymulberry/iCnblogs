//
//  ICOAuthTool.m
//  iCnblogs
//
//  Created by poloby on 16/3/2.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICOAuthTool.h"
#import "ICOAuth.h"

#import <AFNetworking/AFNetworking.h>

#define ICOAuthTokenURL @"http://api.cnblogs.com/token"

#define ICOAuthFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"oauth.data"]

@implementation ICOAuthTool

+ (ICOAuth *)oauthByStoredData
{
    ICOAuth *oauth = [NSKeyedUnarchiver unarchiveObjectWithFile:ICOAuthFilePath];
    return oauth;
}

+ (void)oauthWithRefreshToken:(NSString *)refresh_token success:(void (^)(id _Nullable))success failure:(void (^)(NSError * _Nonnull))failure
{
    if (refresh_token) {
        // 请求用户数据
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:ICClientID password:ICClientSecret];
        // manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager POST:ICOAuthTokenURL parameters:@{@"grant_type" : @"refresh_token", @"refresh_token" : refresh_token} progress:^(NSProgress * _Nonnull uploadProgress) {
            // empty
        } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];
    }
}

+ (void)oauthWithUserName:(NSString *)username
                 password:(NSString *)password
                  success:(void (^)(id _Nullable))success
                  failure:(void (^)(NSError * _Nonnull))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:ICClientID password:ICClientSecret];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:ICOAuthTokenURL parameters:@{@"grant_type" : @"password", @"username" : username, @"password" : password } progress:^(NSProgress * _Nonnull uploadProgress) {
        // empty
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        if (responseObject)
            success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure)
            failure(error);
    }];
}

+ (BOOL)isOAuthInfoExistedInStoredData
{
    ICOAuth *oauth = [NSKeyedUnarchiver unarchiveObjectWithFile:ICOAuthFilePath];
    
    if (oauth) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isAccessTokenExpired:(ICOAuth *)oauth
{
    if (oauth) {
        if ([oauth.expires_time compare:[NSDate date]] == NSOrderedDescending) {
            return NO;
        }
    }
    
    return YES;
}

+ (BOOL)isRefreshTokenExistedInStoredData:(ICOAuth *)oauth
{
    if (oauth && oauth.refresh_token) {
        return YES;
    }
    
    return NO;
}

+ (void)save:(ICOAuth *)oauth
{
    [NSKeyedArchiver archiveRootObject:oauth toFile:ICOAuthFilePath];
}

@end
