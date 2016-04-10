//
//  ICSearchModel.m
//  iCnblogs
//
//  Created by poloby on 16/4/9.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICSearchModel.h"

NSString *const kICSearchModelTitle = @"Title";
NSString *const kICSearchModelContent = @"Content";
NSString *const kICSearchModelUserName = @"UserName";
NSString *const kICSearchModelUserAlias = @"UserAlias";
NSString *const kICSearchModelPublishTime = @"PublishTime";
NSString *const kICSearchModelVoteTimes = @"VoteTimes";
NSString *const kICSearchModelViewTimes = @"ViewTimes";
NSString *const kICSearchModelCommentTimes = @"CommentTimes";
NSString *const kICSearchModelUri = @"Uri";
NSString *const kICSearchModelId = @"Id";

@implementation ICSearchModel

#pragma mark - init methods
+ (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    ICSearchModel *searchModel = [[ICSearchModel alloc] init];
    
    searchModel.title = attributes[kICSearchModelTitle];
    searchModel.content = attributes[kICSearchModelContent];
    searchModel.username = attributes[kICSearchModelUserName];
    searchModel.useralias = attributes[kICSearchModelUserAlias];
    searchModel.publishTime = attributes[kICSearchModelPublishTime];
    searchModel.voteTimes = [attributes[kICSearchModelVoteTimes] stringValue];
    searchModel.viewTimes = [attributes[kICSearchModelViewTimes] stringValue];
    searchModel.commentTimes = [attributes[kICSearchModelCommentTimes] stringValue];
    searchModel.url = [NSURL URLWithString:attributes[kICSearchModelUri]];
    searchModel.searchId = attributes[kICSearchModelId];
    
    return searchModel;
}

#pragma mark - getters and setters
- (void)setPublishTime:(NSString *)publishTime
{
    _publishTime = publishTime;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss"; // "2016-02-02T23:33:00"
    
    NSDate *date = [dateFormatter dateFromString:_publishTime];
    
    if ([date isThisYear]) {
        if ([date isToday]) {
            NSDateComponents *components = [date deltaWithNow];
            
            if (components.hour >= 1) {
                _publishTime = [NSString stringWithFormat:@"%ld小时前", components.hour];
            } else if (components.minute >= 1) {
                _publishTime = [NSString stringWithFormat:@"%ld分钟前", components.minute];
            } else {
                _publishTime = @"刚刚";
            }
        } else if ([date isYesterday]) {
            dateFormatter.dateFormat = @"昨天 HH:mm";
            _publishTime = [dateFormatter stringFromDate:date];
        } else {
            dateFormatter.dateFormat = @"MM-dd HH:mm";
            _publishTime = [dateFormatter stringFromDate:date];
        }
    } else {
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        _publishTime = [dateFormatter stringFromDate:date];
    }
}

- (void)setVoteTimes:(NSString *)voteTimes
{
    _voteTimes = voteTimes;
    
    NSInteger numOfVotes = [_voteTimes integerValue];
    if (numOfVotes >= 10000) { // w
        _voteTimes = [NSString stringWithFormat:@"%ldw+", numOfVotes / 10000];
    } else if (numOfVotes >= 1000) { // k
        _voteTimes = [NSString stringWithFormat:@"%ldk+", numOfVotes / 1000];
    }
}

- (void)setViewTimes:(NSString *)viewTimes
{
    _viewTimes = viewTimes;
    
    NSUInteger numOfViews = [_viewTimes integerValue];
    if (numOfViews >= 10000) { // w
        _voteTimes = [NSString stringWithFormat:@"%ldw+", numOfViews / 10000];
    } else if (numOfViews >= 1000) { // k
        _voteTimes = [NSString stringWithFormat:@"%ldk+", numOfViews / 1000];
    }
}

- (void)setCommentTimes:(NSString *)commentTimes
{
    _commentTimes = commentTimes;
    
    NSUInteger numOfComments = [_commentTimes integerValue];
    if (numOfComments >= 10000) { // w
        _commentTimes = [NSString stringWithFormat:@"%ldw+", numOfComments / 10000];
    } else if (numOfComments >= 1000) { // k
        _commentTimes = [NSString stringWithFormat:@"%ldk+", numOfComments / 1000];
    }
}

@end
