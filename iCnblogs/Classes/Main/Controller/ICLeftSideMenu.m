//
//  ICLeftSideMenu.m
//  iCnblogs
//
//  Created by poloby on 16/3/9.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICLeftSideMenu.h"
#import "ICNavigationController.h"
#import "ICBlogViewController.h"
#import "ICMeViewController.h"
#import "ICLeftMenuViewController.h"

@interface ICLeftSideMenu ()

@property (nonatomic, strong) UIViewController *leftSideMenuContentViewController;

@end

@implementation ICLeftSideMenu

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        ICNavigationController *blogNavigationController = [[ICNavigationController alloc] initWithRootViewController:[[ICBlogViewController alloc] init]];
        _leftSideMenuContentViewController = blogNavigationController;
    }
    
    return self;
}

- (instancetype)initWithContentViewController:(UIViewController *)viewController
{
    self = [super init];
    
    if (self) {
        _leftSideMenuContentViewController = viewController;
    }
    
    return self;
}

- (void)viewDidLoad
{
    // 一进去先显示博客
    //ICNavigationController *blogNavigationController = [[ICNavigationController alloc] initWithRootViewController:[[ICBlogViewController alloc] init]];
//    ICNavigationController *meNavigationController = [[ICNavigationController alloc] initWithRootViewController:[[ICMeViewController alloc] init]];
    // 左侧边栏
    ICNavigationController *blogLeftMenuNavigationController = [[ICNavigationController alloc] initWithRootViewController:[[ICLeftMenuViewController alloc] init]];
    
    [self setContentViewController:self.leftSideMenuContentViewController];
    [self setLeftMenuViewController:blogLeftMenuNavigationController];
    
    self.contentViewInPortraitOffsetCenterX = -ICDeviceWidth * 0.1;
    self.contentViewShadowEnabled = YES;
    self.contentViewShadowOpacity = 0.9;
    self.contentViewShadowColor = [UIColor blackColor];
    self.contentViewShadowOffset = CGSizeMake(-4.0, 4.0);
    self.contentViewScaleValue = 1.0;
    
    [super viewDidLoad];
}

@end
