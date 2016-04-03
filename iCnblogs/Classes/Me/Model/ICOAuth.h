//
//  ICOAuth.h
//  iCnblogs
//
//  Created by poloby on 16/3/1.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import <Foundation/Foundation.h>

// 用于解析JSON数据和存储ICOAuth对象实例
extern NSString *const kICOAuthAccessToken;
extern NSString *const kICOAuthExpiresIn;     // 做业务的时候不需要暴露expires_in，只需要暴露expires_time这个属性就行
extern NSString *const kICOAuthExpiresTime;
extern NSString *const kICOAuthRefreshToken;

/**
 *  OAuth信息 主要用于账户登录
 */
@interface ICOAuth : NSObject <NSCoding>
/**
 *  access_token 存储OAuth登录所需的access_token
 */
@property (nonatomic, copy) NSString *access_token;
/**
 *  expires_in OAuth登录后，access_token过期时间
 */
@property (nonatomic, copy) NSDate *expires_time;
/**
 *  refresh_token access_token过期后，不需要让用户重新登录，直接使用refresh_token重新登录
 */
@property (nonatomic, copy) NSString *refresh_token;
/**
 *  根据服务器端返回的JSON数据(attributes)，解析成对应的ICOAuth对象实例
 */
+ (instancetype)initWithAttribute:(NSDictionary *)attributes;

@end
