//
//  ICSearchModel.h
//  iCnblogs
//
//  Created by poloby on 16/4/9.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kICSearchModelTitle;
extern NSString *const kICSearchModelContent;
extern NSString *const kICSearchModelUserName;
extern NSString *const kICSearchModelUserAlias;
extern NSString *const kICSearchModelPublishTime;
extern NSString *const kICSearchModelVoteTimes;
extern NSString *const kICSearchModelViewTimes;
extern NSString *const kICSearchModelCommentTimes;
extern NSString *const kICSearchModelUri;
extern NSString *const kICSearchModelId;

@interface ICSearchModel : NSObject

@property (nonatomic, copy) NSString *title; // 查询内容的标题
@property (nonatomic, copy) NSString *content; // 查询内容摘要
@property (nonatomic, copy) NSString *username; // 作者
@property (nonatomic, copy) NSString *useralias; // 博客地址
@property (nonatomic, copy) NSString *publishTime; // 发布时间
@property (nonatomic, copy) NSString *voteTimes; // 被推荐次数
@property (nonatomic, copy) NSString *viewTimes; // 浏览次数
@property (nonatomic, copy) NSString *commentTimes; // 评论次数
@property (nonatomic, strong) NSURL *url; // 页面链接
@property (nonatomic, copy) NSString *searchId;

+ (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
