//
//  AppDelegate.m
//  iCnblogs
//
//  Created by poloby on 15/12/28.
//  Copyright © 2015年 poloby. All rights reserved.
//

#import "AppDelegate.h"
#import "ICControllerTool.h"
#import "ICNetworkTool.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 输出沙盒目录
//    NSString *directory = NSHomeDirectory();
//    ICLog(@"directory: %@", directory);
    
    // 初始化并显示window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    // status bar style
    application.statusBarStyle = UIStatusBarStyleLightContent;
    
    // 进入rootViewController
    [ICControllerTool chooseRootViewController];
    
    [ICNetworkTool monitorNetworkStatus];
    
    return YES;
}

@end
