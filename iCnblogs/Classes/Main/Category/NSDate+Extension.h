//
//  NSDate+Extension.h
//  iCnblogs
//
//  Created by poloby on 16/1/5.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

- (BOOL)isToday;
- (BOOL)isYesterday;
- (BOOL)isThisYear;
- (NSDate *)dateWithYMD;
- (NSDateComponents *)deltaWithNow;

@end
