//
//  ICFlashViewController.m
//  iCnblogs
//
//  Created by poloby on 16/3/11.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICFlashViewController.h"

#import <RESideMenu/RESideMenu.h>

@interface ICFlashViewController ()

@end

@implementation ICFlashViewController

- (void)viewDidLoad
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_left_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftSideMenuViewController)];
    self.navigationItem.title = @"闪存";
}

- (void)presentLeftSideMenuViewController
{
    [self.sideMenuViewController presentLeftMenuViewController];
}

@end
