//
//  ICSettingViewController.m
//  iCnblogs
//
//  Created by poloby on 16/4/19.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICSettingViewController.h"
#import "ICTableViewDataSource.h"
#import "ICUser.h"
#import "ICUserTool.h"
#import "ICLeftSideMenu.h"
#import "ICNavigationController.h"
#import "ICMeViewController.h"

#import <RESideMenu/RESideMenu.h>
#import <Masonry/Masonry.h>
#import <CNPPopupController/CNPPopupController.h>
#import <SDWebImage/SDImageCache.h>
#import <MBProgressHUD/MBProgressHUD.h>

#define ICOAuthFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"oauth.data"]

typedef NS_ENUM(NSInteger, ICSettingType) {
    ICSettingTypeClearCache,    // 清除缓存
    ICSettingTypeAboutAuthor,   // 关于作者
    ICSettingTypeComment,       // 给我评价($)_($)
    ICSettingTypeAboutApp,      // 关于i博客园
    ICSettingTypeQuit           // 退出账号
};

@interface ICSettingViewController () <UITableViewDelegate, CNPPopupControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ICTableViewDataSource *settingDataSource;
@property (nonatomic, strong) CNPPopupController *aboutAuthorPopupController;
@property (nonatomic, strong) CNPPopupController *aboutAppPopupController;

@end

@implementation ICSettingViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self.view addSubview:self.tableView];
    [self layoutSubPageViews];
}

- (void)setupNavigationBar
{
    self.navigationItem.title = @"设置";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_left_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftSideMenuViewController)];
}

- (void)layoutSubPageViews
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
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
        } else if (cell.tag == ICSettingTypeAboutAuthor) {
            // 弹出关于作者
            [self.aboutAuthorPopupController presentPopupControllerAnimated:YES];
        } else if (cell.tag == ICSettingTypeAboutApp) {
            // 弹出关于给我评价($)_($)
            [self.aboutAppPopupController presentPopupControllerAnimated:YES];
        } else if (cell.tag == ICSettingTypeQuit) {
            if ([ICUserTool isLogin]) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [ICUserTool logoutWithProgressBlock:^{
                    hud.labelText = @"正在注销账号...";
                    hud.dimBackground = YES;
                } successBlock:^{
                    // 显示注销成功
                    hud.labelText = @"注销成功";
                    [hud hide:YES afterDelay:1.0];
                    ICNavigationController *meNavigationController = [[ICNavigationController alloc] initWithRootViewController:[[ICMeViewController alloc] init]];
                    ICLeftSideMenu *leftMenu = [[ICLeftSideMenu alloc] initWithContentViewController:meNavigationController];
                    [self.navigationController presentViewController:leftMenu animated:YES completion:nil];
                } failureBlock:^{
                    hud.labelText = @"注销失败";
                    [hud hide:YES afterDelay:1.0];
                }];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![ICUserTool isLogin] && indexPath == [self quitIndexPath]) {
        return 0.0;
    }
    
    return ICDeviceWidth * 0.1;
}

#pragma mark - CNPPopupController Delegate
- (void)popupController:(CNPPopupController *)controller didDismissWithButtonTitle:(NSString *)title {
    ICLog(@"Dismissed with button title: %@", title);
}

- (void)popupControllerDidPresent:(CNPPopupController *)controller {
    ICLog(@"Popup controller presented.");
}

#pragma mark - event response
- (void)presentLeftSideMenuViewController
{
    [self.sideMenuViewController presentLeftMenuViewController];
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

// 退出账号的indexPath
- (NSIndexPath *)quitIndexPath
{
    return [NSIndexPath indexPathForRow:0 inSection:2];
}

#pragma mark - event response
- (void)closePopView:(UIView *)popView
{
    [popView removeFromSuperview];
}

#pragma mark - getters and setters
- (ICTableViewDataSource *)settingDataSource
{
    if (_settingDataSource == nil) {
        NSArray *settingItems = @[@[@"清除缓存"], @[@"关于作者", @"关于i博客园", @"给我评价($)_($)"], @[@"退出账号"]];
        _settingDataSource = [[ICTableViewDataSource alloc] initWithItems:settingItems.mutableCopy numberOfSections:settingItems.count cellIdentifier:@"UITableViewCellIdentifier" cellType:@"UITableViewCell" configureBlock:^(UITableViewCell *cell, NSString *item) {
            
            if ([item isEqualToString:@"清除缓存"]) {
                item = [self getCacheSize];
                cell.tag = ICSettingTypeClearCache;
            } else if ([item isEqualToString:@"关于作者"]) {
                cell.tag = ICSettingTypeAboutAuthor;
            } else if ([item isEqualToString:@"关于i博客园"]) {
                cell.tag = ICSettingTypeAboutApp;
            } else if ([item isEqualToString:@"给我评价($)_($)"]) {
                cell.tag = ICSettingTypeComment;
            } else if ([item isEqualToString:@"退出账号"]) {
                cell.tag = ICSettingTypeQuit;
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithWhite:28.0/255.0 alpha:1.0];
            cell.textLabel.text = item;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.font = [UIFont systemFontOfiPhone4OrLessSize:12.0 iPhone5Size:12.0 iPhone6Or6SSize:14.0 iPhone6PlusOr6SPlusSize:16.0];
        }];
    }
    return _settingDataSource;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = ICInkColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self.settingDataSource;
    }
    
    return _tableView;
}

- (CNPPopupController *)aboutAuthorPopupController
{
    if (_aboutAuthorPopupController == nil) {
        UILabel *aboutAuthorLabel = [[UILabel alloc] init];
        aboutAuthorLabel.text = @"大家好，我叫桑果!\n希望和大家多多交流\n常驻博客园\n<<我叫polobymulberry>>";
        aboutAuthorLabel.numberOfLines = 4;
        aboutAuthorLabel.textAlignment = NSTextAlignmentCenter;
        
        UILabel *gmailLabel = [[UILabel alloc] init];
        gmailLabel.text = @"Gmail : jianxiongpan@gmail.com";
        gmailLabel.textAlignment = NSTextAlignmentCenter;
        
        _aboutAuthorPopupController = [[CNPPopupController alloc] initWithContents:@[aboutAuthorLabel, gmailLabel]];
        _aboutAuthorPopupController.theme = [CNPPopupTheme defaultTheme];
        _aboutAuthorPopupController.theme.popupStyle = CNPPopupStyleCentered;
        _aboutAuthorPopupController.delegate = self;
    }
    
    return _aboutAuthorPopupController;
}

- (CNPPopupController *)aboutAppPopupController
{
    if (_aboutAppPopupController == nil) {
        UILabel *aboutAppLabel = [[UILabel alloc] init];
        aboutAppLabel.text = @"我是一个博客园第三方客户端!\n目前已经开源^_^";
        aboutAppLabel.numberOfLines = 2;
        aboutAppLabel.textAlignment = NSTextAlignmentCenter;
        
        UILabel *githubLabel = [[UILabel alloc] init];
        githubLabel.text = @"GitHub\n<<请您搜索iCnblogs>>";
        githubLabel.numberOfLines = 2;
        githubLabel.textAlignment = NSTextAlignmentCenter;
        
        _aboutAppPopupController = [[CNPPopupController alloc] initWithContents:@[aboutAppLabel, githubLabel]];
        _aboutAppPopupController.theme = [CNPPopupTheme defaultTheme];
        _aboutAppPopupController.theme.popupStyle = CNPPopupStyleCentered;
        _aboutAppPopupController.delegate = self;
    }
    
    return _aboutAppPopupController;
}

@end
