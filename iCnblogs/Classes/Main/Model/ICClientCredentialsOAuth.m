//
//  ICClientCredentialsOAuth.m
//  iCnblogs
//
//  Created by poloby on 16/3/5.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICClientCredentialsOAuth.h"

NSString *const kICClientCredentialsOAuth   = @"access_token";
NSString *const kICClientExpiresIn          = @"expires_in";
NSString *const kICClientExpiresTime        = @"expires_time";

@implementation ICClientCredentialsOAuth

+ (instancetype)initWithAttribute:(NSDictionary *)attributes
{
    ICClientCredentialsOAuth *clientCredentialsOAuth = [[ICClientCredentialsOAuth alloc] init];
    
    clientCredentialsOAuth.access_token = attributes[kICClientCredentialsOAuth];
    clientCredentialsOAuth.expires_in = attributes[kICClientExpiresIn];
    
    NSDate *now = [NSDate date];
    clientCredentialsOAuth.expires_time = [now dateByAddingTimeInterval:clientCredentialsOAuth.expires_in.doubleValue];
    
    return clientCredentialsOAuth;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.access_token = [aDecoder decodeObjectForKey:kICClientCredentialsOAuth];
        self.expires_in = [aDecoder decodeObjectForKey:kICClientExpiresIn];
        self.expires_time = [aDecoder decodeObjectForKey:kICClientExpiresTime];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.access_token forKey:kICClientCredentialsOAuth];
    [aCoder encodeObject:self.expires_in forKey:kICClientExpiresIn];
    [aCoder encodeObject:self.expires_time forKey:kICClientExpiresTime];
}

@end
