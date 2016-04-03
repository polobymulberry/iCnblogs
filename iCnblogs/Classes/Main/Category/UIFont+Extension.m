//
//  UIFont+Extension.m
//  iCnblogs
//
//  Created by poloby on 16/4/1.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "UIFont+Extension.h"

@implementation UIFont (Extension)

+ (UIFont *)systemFontOfiPhone4OrLessSize:(CGFloat)iPhone4OrLessSize iPhone5Size:(CGFloat)iPhone5SSize iPhone6Or6SSize:(CGFloat)iPhone6Or6SSize iPhone6PlusOr6SPlusSize:(CGFloat)iPhone6PlusOr6SPlusSize
{
    CGFloat fontSize;
    
    if (IS_IPHONE_4_OR_LESS) {
        fontSize = iPhone4OrLessSize;
    } else if (IS_IPHONE_5) {
        fontSize = iPhone5SSize;
    } else if (IS_IPHONE_6 || IS_IPHONE_6S) {
        fontSize = iPhone6Or6SSize;
    } else if (IS_IPHONE_6_PLUS || IS_IPHONE_6S_PLUS){
        fontSize = iPhone6PlusOr6SPlusSize;
    } else {
        fontSize = iPhone5SSize; // 默认是5S，不为别的，因为我用的是5S
    }
    
    return [UIFont systemFontOfSize:fontSize];
}

+ (UIFont *)boldSystemFontOfiPhone4OrLessSize:(CGFloat)iPhone4OrLessSize iPhone5Size:(CGFloat)iPhone5SSize iPhone6Or6SSize:(CGFloat)iPhone6Or6SSize iPhone6PlusOr6SPlusSize:(CGFloat)iPhone6PlusOr6SPlusSize
{
    CGFloat fontSize;
    
    if (IS_IPHONE_4_OR_LESS) {
        fontSize = iPhone4OrLessSize;
    } else if (IS_IPHONE_5) {
        fontSize = iPhone5SSize;
    } else if (IS_IPHONE_6 || IS_IPHONE_6S) {
        fontSize = iPhone6Or6SSize;
    } else if (IS_IPHONE_6_PLUS || IS_IPHONE_6S_PLUS){
        fontSize = iPhone6PlusOr6SPlusSize;
    } else {
        fontSize = iPhone5SSize; // 默认是5S，不为别的，因为我用的是5S
    }
    
    return [UIFont boldSystemFontOfSize:fontSize];
}

@end
