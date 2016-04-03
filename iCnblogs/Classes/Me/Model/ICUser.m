//
//  ICUser.m
//  iCnblogs
//
//  Created by poloby on 16/3/3.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICUser.h"

NSString *const kUserId             = @"UserId";
NSString *const kUserSpaceUserId    = @"SpaceUserId";
NSString *const kUserBlogId         = @"BlogId";
NSString *const kUserDisplayName    = @"DisplayName";
NSString *const kUserFaceURL        = @"Face";
NSString *const kUserAvatarURL      = @"Avatar";
NSString *const kUserSeniority      = @"Seniority";
NSString *const kUserBlogApp        = @"BlogApp";

@implementation ICUser

// 每个手机app上只可能存在一个user，所以此处我使用单例模式
+ (instancetype)user
{
    static ICUser *user = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[ICUser alloc] init];
    });
    
    return user;
}

+ (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    ICUser *user = [ICUser user];
    user.userId         = attributes[kUserId];
    user.spaceUserId    = [attributes[kUserSpaceUserId] integerValue];
    user.blogId         = [attributes[kUserBlogId] integerValue];
    user.displayName    = attributes[kUserDisplayName];
    user.faceURL        = [NSURL URLWithString:attributes[kUserFaceURL]];
    user.avatarURL      = [NSURL URLWithString:attributes[kUserAvatarURL]];
    user.seniority      = attributes[kUserSeniority];
    user.blogApp        = attributes[kUserBlogApp];
    
    return user;
}

@end
