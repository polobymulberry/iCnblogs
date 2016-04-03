//
//  ICNews.h
//  iCnblogs
//
//  Created by poloby on 16/1/10.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import <Foundation/Foundation.h>

// ICNews
extern NSString * const kNewsId;
extern NSString * const kNewsTitle;
extern NSString * const kNewsTopicIcon;
extern NSString * const kNewsTopicId;
extern NSString * const kNewsSummary;
extern NSString * const kNewsDateAdded;
extern NSString * const kNewsViewCount;
extern NSString * const kNewsDiggCount;
extern NSString * const kNewsCommentCount;

@interface ICNews : NSObject

@property (nonatomic, assign) NSInteger newsId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger topicId;
@property (nonatomic, copy) NSURL *topicIcon;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *dateAdded;
@property (nonatomic, copy) NSString *viewCount;
@property (nonatomic, copy) NSString *diggCount;
@property (nonatomic, copy) NSString *commentCount;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
