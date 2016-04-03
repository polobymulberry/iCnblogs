//
//  ICUser.h
//  iCnblogs
//
//  Created by poloby on 16/3/3.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kUserId;
extern NSString *const kUserSpaceUserId;
extern NSString *const kUserBlogId;
extern NSString *const kUserDisplayName;
extern NSString *const kUserFaceURL;
extern NSString *const kUserAvatarURL;
extern NSString *const kUserSeniority;
extern NSString *const kUserBlogApp;

@interface ICUser : NSObject

@property (nonatomic, copy)     NSString    *userId;
@property (nonatomic, assign)   NSInteger   spaceUserId;
@property (nonatomic, assign)   NSInteger   blogId;
@property (nonatomic, copy)     NSString    *displayName;
@property (nonatomic, strong)   NSURL       *faceURL; // 这里不是很清楚，face和avatar不一样嘛？
@property (nonatomic, strong)   NSURL       *avatarURL;
@property (nonatomic, copy)     NSString    *seniority; // 园龄
@property (nonatomic, copy)     NSString    *blogApp;

+ (instancetype)user;
+ (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
