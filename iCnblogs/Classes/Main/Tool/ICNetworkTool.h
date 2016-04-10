//
//  ICNetworkTool.h
//  iCnblogs
//
//  Created by poloby on 16/1/7.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICNetworkTool : NSObject

// 监视网络状态
+ (void)monitorNetworkStatus;

// 请求数据
+ (void)loadDataWithURL:(NSString *)requestURL
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;
+ (void)loadDataWithURL:(NSString *)requestURL
             parameters:(NSDictionary *)parameters
                success:(void (^)(id))success
                failure:(void (^)(NSError *))failure;
+ (void)loadContentWithURL:(NSString *)requestURL
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;
/**
 * 如果本地存储了oauth信息并且access token没过期，那么就使用accessTokenSuccessBlock和accessTokenFailureBlock
 * 如果access token过期了，那么就使用refreshTokenSuccessBlock和refreshTokenFailureBlock
 * 如果本地没有存储oauth信息，那就使用noAccessTokenBlock重新获取oauth
 */
+ (void)loadUserInfoWithURL:(NSString *)requestURL
    accessTokenSuccessBlock:(void (^)(id userInfo))accessTokenSuccessBlock
    accessTokenFailureBlock:(void (^)(NSError *error))accessTokenFailureBlock
   refreshTokenSuccessBlock:(void (^)(id oauthInfo))refreshTokenSuccessBlock
   refreshTokenFailureBlock:(void (^)(NSError *error))refreshTokenFailureBlock
         noAccessTokenBlock:(void (^)())noAccessTokenBlock;
+ (void)loadUserInfoWithURL:(NSString *)requestURL
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;
@end
