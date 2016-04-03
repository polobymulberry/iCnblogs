//
//  ICUserSettingTableView.m
//  iCnblogs
//
//  Created by poloby on 16/3/5.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICUserSettingTableView.h"
#import "ICTableViewDataSource.h"
#import "ICLeftSideMenu.h"
#import "ICNavigationController.h"
#import "ICMeViewController.h"

#import <CNPPopupController/CNPPopupController.h>
#import <SDWebImage/SDImageCache.h>

#define ICOAuthFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"oauth.data"]

typedef NS_ENUM(NSInteger, ICSettingType) {
    ICSettingTypeClearCache,
    ICSettingTypeAboutMe,
    ICSettingTypeComment,
    ICSettingTypeQuit
};

@interface ICUserSettingTableView () <UITableViewDelegate, CNPPopupControllerDelegate>

@property (nonatomic, strong) ICTableViewDataSource *settingDataSource;
@property (nonatomic, strong) CNPPopupController *popupController;

@end

@implementation ICUserSettingTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:28.0/255.0 alpha:1.0];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.delegate = self;
        self.dataSource = self.settingDataSource;
    }
    
    return self;
}

#pragma mark - event response
- (void)closePopView:(UIView *)popView
{
    [popView removeFromSuperview];
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell) {
        if (cell.tag == ICSettingTypeClearCache) {
            //
            ICLog(@"size count : %ld",[[SDImageCache sharedImageCache] getSize]);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                    ICLog(@"清除成功");
                    ICLog(@"size count : %ld",[[SDImageCache sharedImageCache] getSize]);
                    cell.textLabel.text = [self getCacheSize];
                }];
            });
        } else if (cell.tag == ICSettingTypeComment) {
            NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%d", APPID];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        } else if (cell.tag == ICSettingTypeAboutMe) {
            // 弹出关于窗口
            [self.popupController presentPopupControllerAnimated:YES];
        } else if (cell.tag == ICSettingTypeQuit) {
            // 删除account.data数据
            BOOL result = [[NSFileManager defaultManager] removeItemAtPath:ICOAuthFilePath error:nil];
            if (result) {
                ICLog(@"account.data删除成功");
            } else {
                ICLog(@"account.data删除失败");
            }
            ICNavigationController *meNavigationController = [[ICNavigationController alloc] initWithRootViewController:[[ICMeViewController alloc] init]];
            ICLeftSideMenu *leftMenu = [[ICLeftSideMenu alloc] initWithContentViewController:meNavigationController];
            [[self findViewController].navigationController presentViewController:leftMenu animated:YES completion:nil];
        }
    }
}

#pragma mark - CNPPopupController Delegate

- (void)popupController:(CNPPopupController *)controller didDismissWithButtonTitle:(NSString *)title {
    ICLog(@"Dismissed with button title: %@", title);
}

- (void)popupControllerDidPresent:(CNPPopupController *)controller {
    ICLog(@"Popup controller presented.");
}

#pragma mark - private method
- (NSString *)getCacheSize
{
    NSInteger size = [[SDImageCache sharedImageCache] getSize];
    
    NSString *sizeString = @"";
    if (size > 1024 * 1024) {
        sizeString = [NSString stringWithFormat:@"清除缓存(%.2fMB)", size / (1024.0 * 1024.0)];
    } else {
        sizeString = [NSString stringWithFormat:@"清除缓存(%.2fKB)", size / 1024.0];
    }
    
    return sizeString;
}

#pragma mark - getters and setters
- (ICTableViewDataSource *)settingDataSource
{
    if (_settingDataSource == nil) {
        
        NSMutableArray *array = [NSMutableArray arrayWithObjects:@[@"清除缓存"], @[@"关于", @"评价"], @[@"退出帐号"], nil];

        _settingDataSource = [[ICTableViewDataSource alloc] initWithItems:array numberOfSections:array.count cellIdentifier:@"UITableViewCellIdentifier" cellType:@"UITableViewCell" configureBlock:^(UITableViewCell *cell, NSString *item) {
            
            if ([item isEqualToString:@"清除缓存"]) {
                item = [self getCacheSize];
                cell.tag = ICSettingTypeClearCache;
            } else if ([item isEqualToString:@"关于"]) {
                cell.tag = ICSettingTypeAboutMe;
            } else if ([item isEqualToString:@"评价"]) {
                cell.tag = ICSettingTypeComment;
            } else if ([item isEqualToString:@"退出帐号"]) {
                cell.tag = ICSettingTypeQuit;
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithWhite:28.0/255.0 alpha:1.0];
            cell.textLabel.text = item;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor whiteColor];
            if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5) {
                cell.textLabel.font = [UIFont systemFontOfSize:12.0];
            } else if (IS_IPHONE_6 || IS_IPHONE_6S) {
                cell.textLabel.font = [UIFont systemFontOfSize:14.0];
            } else if (IS_IPHONE_6_PLUS || IS_IPHONE_6S_PLUS) {
                cell.textLabel.font = [UIFont systemFontOfSize:16.0];
            }
        }];
    }
    
    return _settingDataSource;
}

- (CNPPopupController *)popupController
{
    if (_popupController == nil) {
        UILabel *aboutMeLabel = [[UILabel alloc] init];
        aboutMeLabel.text = @"大家好，我叫桑果!\n希望和大家多多交流";
        aboutMeLabel.numberOfLines = 3;
        aboutMeLabel.textAlignment = NSTextAlignmentCenter;
        
        UILabel *gmailLabel = [[UILabel alloc] init];
        gmailLabel.text = @"Gmail : jianxiongpan@gmail.com";
        gmailLabel.textAlignment = NSTextAlignmentCenter;
        
        _popupController = [[CNPPopupController alloc] initWithContents:@[aboutMeLabel, gmailLabel]];
        _popupController.theme = [CNPPopupTheme defaultTheme];
        _popupController.theme.popupStyle = CNPPopupStyleCentered;
        _popupController.delegate = self;
    }
    
    return _popupController;
}

@end
