//
//  ICControllerTool.m
//  iCnblogs
//
//  Created by poloby on 15/12/29.
//  Copyright © 2015年 poloby. All rights reserved.
//

#import "ICControllerTool.h"
#import "ICLeftSideMenu.h"
#import "ICGuideViewController.h"

@implementation ICControllerTool

+ (void)chooseRootViewController
{
    NSString *versionKey = @"CFBundleShortVersionString";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults objectForKey:versionKey];
    
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if ([currentVersion isEqualToString:lastVersion]) {
        [UIApplication sharedApplication].statusBarHidden = NO;

        window.rootViewController = [[ICLeftSideMenu alloc] init];
    } else {
        window.rootViewController = [[ICGuideViewController alloc] init];
        
        [defaults setObject:currentVersion forKey:versionKey];
        [defaults synchronize];
    }
}

@end
