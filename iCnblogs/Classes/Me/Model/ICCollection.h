//
//  ICCollection.h
//  iCnblogs
//
//  Created by poloby on 16/3/6.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kCollectionWZLinkId;
extern NSString *const kCollectionTitle;
extern NSString *const kCollectionLinkUrl;
extern NSString *const kCollectionSummary;
extern NSString *const kCollectionTags;
extern NSString *const kCollectionDate;

@interface ICCollection : NSObject

@property (nonatomic, assign) NSInteger wzLinkId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSURL *linkUrl;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSMutableArray *tags;
@property (nonatomic, strong) NSDate *dateAdded;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
