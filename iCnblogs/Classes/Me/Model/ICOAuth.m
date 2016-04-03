//
//  ICOAuth.m
//  iCnblogs
//
//  Created by poloby on 16/3/1.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICOAuth.h"

NSString *const kICOAuthAccessToken   = @"access_token";
NSString *const kICOAuthExpiresIn     = @"expires_in";
NSString *const kICOAuthExpiresTime   = @"expires_time";
NSString *const kICOAuthRefreshToken  = @"refresh_token";

@implementation ICOAuth

#pragma mark - init
+ (instancetype)initWithAttribute:(NSDictionary *)attributes
{
    ICOAuth *oauth = [[ICOAuth alloc] init];
    
    oauth.access_token = attributes[kICOAuthAccessToken];
    oauth.refresh_token = attributes[kICOAuthRefreshToken];
    // expires_in ==> expires_time
    double expires_in = [attributes[kICOAuthExpiresIn] doubleValue];
    NSDate *now = [NSDate date];
    oauth.expires_time = [now dateByAddingTimeInterval:expires_in];
    
    return oauth;
}

#pragma mark - NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.access_token   = [aDecoder decodeObjectForKey:kICOAuthAccessToken];
        self.expires_time   = [aDecoder decodeObjectForKey:kICOAuthExpiresTime];
        self.refresh_token  = [aDecoder decodeObjectForKey:kICOAuthRefreshToken];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.access_token forKey:kICOAuthAccessToken];
    [aCoder encodeObject:self.expires_time forKey:kICOAuthExpiresTime];
    [aCoder encodeObject:self.refresh_token forKey:kICOAuthRefreshToken];
}

@end
