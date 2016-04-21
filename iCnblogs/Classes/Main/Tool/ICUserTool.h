//
//  ICUserTool.h
//  iCnblogs
//
//  Created by poloby on 16/4/19.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICUserTool : NSObject

+ (BOOL)isLogin;
+ (void)logoutWithProgressBlock:(void (^)())progress
                   successBlock:(void (^)())success
                   failureBlock:(void (^)())failure;

@end
