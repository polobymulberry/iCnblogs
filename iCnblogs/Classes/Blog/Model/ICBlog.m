//
//  ICBlog.m
//  iCnblogs
//
//  Created by poloby on 16/3/6.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICBlog.h"

NSString *const kICBlogAuthor        = @"Author";
NSString *const kICBlogAvatarUrl     = @"Avatar";
NSString *const kICBlogBlogApp       = @"BlogApp";
NSString *const kICBlogCommentCount  = @"CommentCount";
NSString *const kICBlogDiggCount     = @"DiggCount";
NSString *const kICBlogViewCount     = @"ViewCount";
NSString *const kICBlogDescription   = @"Description";
NSString *const kICBlogId            = @"Id";
NSString *const kICBlogPostDate      = @"PostDate";
NSString *const kICBlogTitle         = @"Title";
NSString *const kICBlogUrl           = @"Url";

@implementation ICBlog

+ (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    ICBlog *blog = [[ICBlog alloc] init];
    
    blog.author = attributes[kICBlogAuthor];
    blog.avatarUrl = [NSURL URLWithString:attributes[kICBlogAvatarUrl]];
    blog.blogApp = attributes[kICBlogBlogApp];
    blog.commentCount = [attributes[kICBlogCommentCount] stringValue];
    blog.diggCount = [attributes[kICBlogDiggCount] stringValue];
    blog.viewCount = [attributes[kICBlogViewCount] stringValue];
    blog.blogDescription = attributes[kICBlogDescription];
    blog.blogId = [attributes[kICBlogId] integerValue];
    // 使用setter方法解析
    blog.postDate = attributes[kICBlogPostDate];
    blog.title = attributes[kICBlogTitle];
    blog.url = [NSURL URLWithString:attributes[kICBlogUrl]];
    
    return blog;
}

#pragma mark - getters and setters
- (void)setPostDate:(NSString *)postDate
{
    _postDate = postDate;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss"; // "2016-02-02T23:33:00"
    
    NSDate *date = [dateFormatter dateFromString:postDate];
    
    if ([date isThisYear]) {
        if ([date isToday]) {
            NSDateComponents *components = [date deltaWithNow];
            
            if (components.hour >= 1) {
                _postDate = [NSString stringWithFormat:@"%ld小时前", components.hour];
            } else if (components.minute >= 1) {
                _postDate = [NSString stringWithFormat:@"%ld分钟前", components.minute];
            } else {
                _postDate = @"刚刚";
            }
        } else if ([date isYesterday]) {
            dateFormatter.dateFormat = @"昨天 HH:mm";
            _postDate = [dateFormatter stringFromDate:date];
        } else {
            dateFormatter.dateFormat = @"MM-dd HH:mm";
            _postDate = [dateFormatter stringFromDate:date];
        }
    } else {
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        _postDate = [dateFormatter stringFromDate:date];
    }
}

- (void)setViewCount:(NSString *)viewCount
{
    _viewCount = viewCount;
    
    NSInteger numOfViews = [viewCount integerValue];
    if (numOfViews >= 10000) { // w
        _viewCount = [NSString stringWithFormat:@"%ldw+", numOfViews / 10000];
    } else if (numOfViews >= 1000) { // k
        _viewCount = [NSString stringWithFormat:@"%ldk+", numOfViews / 1000];
    }
}

- (void)setDiggCount:(NSString *)diggCount
{
    _diggCount = diggCount;
    
    NSInteger numOfDiggs = [diggCount integerValue];
    if (numOfDiggs >= 10000) { // w
        _diggCount = [NSString stringWithFormat:@"%ldw+", numOfDiggs / 10000];
    } else if (numOfDiggs >= 1000) { // k
        _diggCount = [NSString stringWithFormat:@"%ldk+", numOfDiggs / 1000];
    }
}

- (void)setCommentCount:(NSString *)commentCount
{
    _commentCount = commentCount;
    
    NSInteger numOfComments = [commentCount integerValue];
    if (numOfComments >= 10000) { // w
        _commentCount = [NSString stringWithFormat:@"%ldw+", numOfComments / 10000];
    } else if (numOfComments >= 1000) { // k
        _commentCount = [NSString stringWithFormat:@"%ldk+", numOfComments / 1000];
    }
}

@end
