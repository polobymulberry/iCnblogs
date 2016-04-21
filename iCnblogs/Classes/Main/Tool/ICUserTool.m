//
//  ICUserTool.m
//  iCnblogs
//
//  Created by poloby on 16/4/19.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICUserTool.h"
#import "ICUser.h"

#define ICOAuthFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"oauth.data"]

@implementation ICUserTool

+ (BOOL)isLogin
{
    return [ICUser user].userId && ![[ICUser user].userId isEqualToString:@""];
}

+ (void)logoutWithProgressBlock:(void (^)())progress successBlock:(void (^)())success failureBlock:(void (^)())failure
{
    if (progress) {
        progress();
    }
    // 删除OAuth信息文件
    BOOL successLogout = [[NSFileManager defaultManager] removeItemAtPath:ICOAuthFilePath error:nil];
    // 还需要将[ICUser user].userId = nil清除
    // 直接置ICUser *user = [ICUser user]; user = nil;不管用！！！
    ICUser *user = [ICUser user];
    user.userId = nil;
    
    if (successLogout && success) {
        success();
    } else if (!successLogout && failure) {
        failure();
    }
}

@end
