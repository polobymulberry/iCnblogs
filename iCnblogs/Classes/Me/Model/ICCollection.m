//
//  ICCollection.m
//  iCnblogs
//
//  Created by poloby on 16/3/6.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICCollection.h"

NSString *const kCollectionWZLinkId  = @"WzLinkId";
NSString *const kCollectionTitle     = @"Title";
NSString *const kCollectionLinkUrl   = @"LinkUrl";
NSString *const kCollectionSummary   = @"Summary";
NSString *const kCollectionTags      = @"Tags";
NSString *const kCollectionDate      = @"DateAdded";

@implementation ICCollection

+ (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    ICCollection *collection = [[ICCollection alloc] init];
    
    collection.wzLinkId = [attributes[kCollectionWZLinkId] integerValue];
    collection.title = attributes[kCollectionTitle];
    collection.linkUrl = [NSURL URLWithString:attributes[kCollectionLinkUrl]];
    collection.summary = attributes[kCollectionSummary];
    NSMutableArray *tmp = [NSMutableArray array];
    for (NSString *tag in attributes[kCollectionTags]) {
        [tmp addObject:tag];
    }
    collection.tags = [tmp copy];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'hh:mm:ss";
    collection.dateAdded = [dateFormatter dateFromString:attributes[kCollectionDate]];

    return collection;
}

@end
