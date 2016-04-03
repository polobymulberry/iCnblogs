//
//  ICClientCredentialsOAuth.h
//  iCnblogs
//
//  Created by poloby on 16/3/5.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kICClientCredentialsOAuth;
extern NSString *const kICClientExpiresIn;
extern NSString *const kICClientExpiresTime;

/**
 * 除此了上面两种grant_type为password和refresh_token，还有一种grant_type，那就是client_credentials
 */
@interface ICClientCredentialsOAuth : NSObject <NSCoding>

@property (nonatomic, copy) NSString *access_token;
@property (nonatomic, copy) NSString *expires_in;
@property (nonatomic, strong) NSDate *expires_time;

+ (instancetype)initWithAttribute:(NSDictionary *)attributes;

@end
