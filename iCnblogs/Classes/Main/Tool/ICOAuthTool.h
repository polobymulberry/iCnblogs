//
//  ICOAuthTool.h
//  iCnblogs
//
//  Created by poloby on 16/3/2.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICOAuth;

/**
 *  获取用户的OAuth信息有以下几种途径:
 *  1.从oauth.data读取
 *  2.根据用户登录信息从服务器端获取(涉及到用户登录操作，也就是要和View打交道)
 *  3.根据refresh_token从服务器端刷新access_token
 *  此处我的设计是将网络操作封装在了下面的函数中，而不是放在ViewController，因为VC是业务重灾区，不希望暴露过多的细节。
 *  具体处理步骤
 *  1. 判断OAuth是否存储在oauth.data，有的话，使用accountByStoredData获取
 *  2. 如果上面获取的OAuth信息中access_token没过期，则使用该access_token，如果过期了，则执行第3步
 *  3. 判断该OAuth信息中是否存在refresh_token信息，如果有，则使用refresh_token进行刷新，并用新的access_token登录，如果没有，执行第4步
 *  4. 使用用户名和密码登陆
 */
@interface ICOAuthTool : NSObject

/**
 *  该oauth信息是从本地oauth.data获取的
 *  这里又分成两种情况，分别是oauth.data中存储的access_token没过期和过期两种情况
 *  如果access_token过期，需要使用refresh_token重新获取，此时就需要调用网络操作，所以需要用户定义success和failure操作
 */
+ (ICOAuth * _Nullable)oauthByStoredData;
/**
 *  通过refresh_token刷新过期的access_token
 */
+ (void)oauthWithRefreshToken:(NSString * _Nullable)refresh_token
                               success:(nullable void (^)(id _Nullable responseObject))success
                               failure:(nullable void (^)(NSError * _Nonnull error))failure;
/**
 *  根据用户登录信息获取的，也就是上面那个account函数返回如果为空，那么就调用下面这个函数获取account
 */
+ (void)oauthWithUserName:(NSString * _Nullable)username
                   password:(NSString * _Nullable)password
                    success:(nullable void(^)(id _Nullable responseObject))success
                    failure:(nullable void(^)(NSError * _Nonnull error))failure;

/**
 * 判断OAuth信息的状态
 */
+ (BOOL)isOAuthInfoExistedInStoredData; // 判断oauth.data是否存在OAuth信息
+ (BOOL)isAccessTokenExpired:(ICOAuth * _Nonnull)oauth; // 判断该oauth信息中的access_token是否过期了
+ (BOOL)isRefreshTokenExistedInStoredData:(ICOAuth * _Nonnull)oauth; // 判断oauth信息中是否存在refresh_token

/**
 * 保存OAuth信息到本地
 */
+ (void)save:(ICOAuth * _Nonnull)oauth;

@end
