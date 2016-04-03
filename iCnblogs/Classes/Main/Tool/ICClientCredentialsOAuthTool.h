//
//  ICClientCredentialsOAuthTool.h
//  iCnblogs
//
//  Created by poloby on 16/3/5.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICClientCredentialsOAuth;

/**
 * 因为grant_type的client credentials，所以不需要考虑refresh_token等等问题，相对简单一些
 */
@interface ICClientCredentialsOAuthTool : NSObject

+ (void)save:(ICClientCredentialsOAuth *)oauth;
+ (ICClientCredentialsOAuth *)oauthByStoredData;
+ (void)oauthWithClientID:(NSString *)clientID
             clientSecret:(NSString *)clientSecret
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError* error))failure;
+ (BOOL)isOAuthInfoExistedInStoredData; // 判断oauth.data是否存在OAuth信息
+ (BOOL)isAccessTokenExpired:(ICClientCredentialsOAuth *)oauth; // 判断该oauth信息中的access_token是否过期了

@end
