//
//  ICLibrary.m
//  iCnblogs
//
//  Created by poloby on 16/3/12.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICLibrary.h"

NSString *const kICLibraryId            = @"Id";
NSString *const kICLibraryTitle         = @"Title";
NSString *const kICLibrarySummary       = @"Summary";
NSString *const kICLibraryAuthor        = @"Author";
NSString *const kICLibraryDiggCount     = @"DiggCount";
NSString *const kICLibraryViewCount     = @"ViewCount";
NSString *const kICLibraryDateAdded     = @"DateAdded";

@implementation ICLibrary

#pragma mark - init methods
- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    ICLibrary *library = [[ICLibrary alloc] init];
    
    library.libraryId   = [attributes[kICLibraryId] integerValue];
    library.title       = attributes[kICLibraryTitle];
    library.summary     = attributes[kICLibrarySummary];
    library.author      = attributes[kICLibraryAuthor];
    library.diggCount   = [attributes[kICLibraryDiggCount] stringValue];
    library.viewCount   = [attributes[kICLibraryViewCount] stringValue];
    library.dateAdded   = attributes[kICLibraryDateAdded];
    
    return library;
}

#pragma mark - getters and setters
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

- (void)setDateAdded:(NSString *)dateAdded
{
    _dateAdded = dateAdded;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS"; // "016-03-09T20:28:40.983"
    
    NSDate *date = [dateFormatter dateFromString:dateAdded];
    
    if ([date isThisYear]) {
        if ([date isToday]) {
            NSDateComponents *components = [date deltaWithNow];
            
            if (components.hour >= 1) {
                _dateAdded = [NSString stringWithFormat:@"%ld小时前", components.hour];
            } else if (components.minute >= 1) {
                _dateAdded = [NSString stringWithFormat:@"%ld分钟前", components.minute];
            } else {
                _dateAdded = @"刚刚";
            }
        } else if ([date isYesterday]) {
            dateFormatter.dateFormat = @"昨天 HH:mm";
            _dateAdded = [dateFormatter stringFromDate:date];
        } else {
            dateFormatter.dateFormat = @"MM-dd HH:mm";
            _dateAdded = [dateFormatter stringFromDate:date];
        }
    } else {
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        _dateAdded = [dateFormatter stringFromDate:date];
    }
}

@end
