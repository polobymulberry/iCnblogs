//
//  ICBlog.h
//  iCnblogs
//
//  Created by poloby on 16/3/6.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kICBlogAuthor;
extern NSString *const kICBlogAvatarUrl;
extern NSString *const kICBlogBlogApp;
extern NSString *const kICBlogCommentCount;
extern NSString *const kICBlogDiggCount;
extern NSString *const kICBlogViewCount;
extern NSString *const kICBlogDescription;
extern NSString *const kICBlogId;
extern NSString *const kICBlogPostDate;
extern NSString *const kICBlogTitle;
extern NSString *const kICBlogUrl;

// 个人博客随笔
@interface ICBlog : NSObject
// 作者名称
@property (nonatomic, copy) NSString *author;
// 作者头像地址
@property (nonatomic, copy) NSURL *avatarUrl;
// 作者整个博客的名称，而非单个随笔的名称，一般于作者名称相同,比如我叫桑果，但是我的blogApp叫polobymulberry
@property (nonatomic, copy) NSString *blogApp;
// 评论数
@property (nonatomic, copy) NSString *commentCount;
// 点赞数
@property (nonatomic, copy) NSString *diggCount;
// 阅读数
@property (nonatomic, copy) NSString *viewCount;
// 简介
@property (nonatomic, copy) NSString *blogDescription;
// id号
@property (nonatomic, assign) NSInteger blogId;
// 发表时间
@property (nonatomic, copy) NSString *postDate;
// 标题
@property (nonatomic, copy) NSString *title;
// 网络地址链接
@property (nonatomic, copy) NSURL *url;

+ (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
