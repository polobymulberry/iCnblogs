//
//  ICLibrary.h
//  iCnblogs
//
//  Created by poloby on 16/3/12.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kICLibraryId;
extern NSString *const kICLibraryTitle;
extern NSString *const kICLibrarySummary;
extern NSString *const kICLibraryAuthor;
extern NSString *const kICLibraryDiggCount;
extern NSString *const kICLibraryViewCount;
extern NSString *const kICLibraryDateAdded;

@interface ICLibrary : NSObject

@property (nonatomic, assign) NSInteger libraryId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *viewCount;
@property (nonatomic, copy) NSString *diggCount;
@property (nonatomic, copy) NSString *dateAdded;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
