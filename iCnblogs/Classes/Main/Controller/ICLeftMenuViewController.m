//
//  ICLeftMenuViewController.m
//  iCnblogs
//
//  Created by poloby on 15/12/29.
//  Copyright © 2015年 poloby. All rights reserved.
//

#import "ICLeftMenuViewController.h"
#import "ICTableViewDataSource.h"

#import "ICNavigationController.h"
#import "ICMeViewController.h"
#import "ICBlogViewController.h"
#import "ICFlashViewController.h"
#import "ICLibraryViewController.h"
#import "ICMeViewController.h"
#import "ICNewsViewController.h"
#import "ICLeftMenuHeaderView.h"
#import "ICOAuthTool.h"
#import "ICOAuth.h"
#import "ICUser.h"
#import "ICNetworkTool.h"

#import <AFNetworking/AFNetworking.h>
#import <RESideMenu/RESideMenu.h>
#import <Masonry/Masonry.h>
#import <UIImageView+WebCache.h>

// 和下面的blogLeftMenuTitleArray注意对应上
typedef NS_ENUM(NSInteger, ICLeftMenuType) {
    ICLeftMenuTypeBlog      = 0, // 博客
    ICLeftMenuTypeNews      = 1, // 新闻
    ICLeftMenuTypeLibrary   = 2, // 文库
    ICLeftMenuTypeUserInfo  = 3  // 个人
    //ICLeftMenuTypeFlash     = 2, // 闪存
};

#define ICUserInfoURL @"http://api.cnblogs.com/api/Users"

@interface ICLeftMenuViewController () <UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *blogLeftMenuTitleArray;
@property (nonatomic, strong) ICTableViewDataSource *leftBlogMenuTableViewDataSource;

@property (nonatomic, strong) ICBlogViewController *blogHomeViewController;
@property (nonatomic, strong) ICNewsViewController *newsViewController;
@property (nonatomic, strong) ICFlashViewController *flashViewController;
@property (nonatomic, strong) ICLibraryViewController *libraryViewController;
@property (nonatomic, strong) ICMeViewController *meViewController;

@end

@implementation ICLeftMenuViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    [self.view addSubview:self.tableView];
    
    __weak typeof (self) weakSelf = self;
    [ICNetworkTool loadUserInfoWithURL:ICUserInfoURL
               accessTokenSuccessBlock:^(id userInfo) {
                   // 构建个人页面
                   [weakSelf successWithResponse:userInfo];
                   ICLog(@"load user responseObject: %@", userInfo);
               } accessTokenFailureBlock:^(NSError *error) {
                   ICLog(@"load user error: %@", error);
               } refreshTokenSuccessBlock:^(id oauthInfo) {
                   ICOAuth *newOAuth = [ICOAuth initWithAttribute:oauthInfo];
                   [ICOAuthTool save:newOAuth];
                   
                   [ICNetworkTool loadUserInfoWithURL:ICUserInfoURL success:^(id responseObject) {
                       ICLog(@"load user info responseObject: %@", responseObject);
                       [weakSelf successWithResponse:responseObject];
                   } failure:^(NSError *error) {
                       ICLog(@"load user info error: %@", error);
                   }];
               } refreshTokenFailureBlock:^(NSError *error) {
                   ICLog(@"refresh_token failure:%@", error);
               } noAccessTokenBlock:nil];
    
    [self layoutPageSubViews];
}

- (void)successWithResponse:(NSDictionary *)response
{
    // 更新user
    ICUser *user = [ICUser initWithAttributes:response];
    [self configureTableViewWithUser:user];
}

- (void)configureTableViewWithUser:(ICUser *)user
{
    ICLeftMenuHeaderView *leftHeaderView = (ICLeftMenuHeaderView *)self.tableView.tableHeaderView;
    [leftHeaderView.headImageView sd_setImageWithURL:user.avatarURL placeholderImage:[UIImage imageNamed:@"icon_avatar"]];
    leftHeaderView.nameLabel.text = user.displayName;
}

- (void)layoutPageSubViews
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        NSInteger cellHeight;
        if (IS_IPHONE_4_OR_LESS) {
            cellHeight = 32;
        } else if (IS_IPHONE_5) {
            cellHeight = 36;
        } else if (IS_IPHONE_6 || IS_IPHONE_6S) {
            cellHeight = 40;
        } else {
            cellHeight = 44;
        }
        make.size.mas_equalTo(CGSizeMake(ICDeviceWidth * 0.4, cellHeight * 7 + ICDeviceWidth * 0.4));
        make.leading.mas_equalTo(self.view.mas_leading);
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(-ICDeviceWidth*0.3);
    }];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger selectedIndex = indexPath.section * tableView.numberOfSections + indexPath.row;
    
    switch (selectedIndex) {
        case ICLeftMenuTypeBlog:
            [self.sideMenuViewController hideMenuViewController];
            self.sideMenuViewController.contentViewController = [[ICNavigationController alloc] initWithRootViewController:self.blogHomeViewController];
            break;
        case ICLeftMenuTypeNews:
            [self.sideMenuViewController hideMenuViewController];
            self.sideMenuViewController.contentViewController = [[ICNavigationController alloc] initWithRootViewController:self.newsViewController];
            break;
//        case ICLeftMenuTypeFlash:
//            [self.sideMenuViewController hideMenuViewController];
//            self.sideMenuViewController.contentViewController = [[ICNavigationController alloc] initWithRootViewController:self.flashViewController];
//            break;
        case ICLeftMenuTypeLibrary:
            [self.sideMenuViewController hideMenuViewController];
            self.sideMenuViewController.contentViewController = [[ICNavigationController alloc] initWithRootViewController:self.libraryViewController];
            break;
        case ICLeftMenuTypeUserInfo:
            [self.sideMenuViewController hideMenuViewController];
            self.sideMenuViewController.contentViewController = [[ICNavigationController alloc] initWithRootViewController:self.meViewController];
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPHONE_4_OR_LESS) {
        return 32;
    } else if (IS_IPHONE_5) {
        return 36;
    } else if (IS_IPHONE_6 || IS_IPHONE_6S) {
        return 40;
    } else {
        return 44;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ICLeftMenuHeaderView *headerView = [[ICLeftMenuHeaderView alloc] init];
    headerView.size = CGSizeMake(ICDeviceWidth * 0.4, ICDeviceWidth * 0.3);
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTappedHeaderView)];
    [headerView addGestureRecognizer:tapGestureRecognizer];
    
    [self configureTableHeaderView:headerView];
    return headerView;
}

- (void)configureTableHeaderView:(ICLeftMenuHeaderView *)headerView
{
    [ICNetworkTool loadUserInfoWithURL:ICUserInfoURL accessTokenSuccessBlock:^(id userInfo) {
        ICLog(@"responseObject: %@", userInfo);
        // 构建个人页面
        ICUser *user = [ICUser initWithAttributes:userInfo];
        [headerView.headImageView sd_setImageWithURL:user.avatarURL placeholderImage:[UIImage imageNamed:@"icon_avatar"]];
        headerView.nameLabel.text = user.displayName;
    } accessTokenFailureBlock:^(NSError *error) {
        ICLog(@"left menu load user info error: %@", error);
    } refreshTokenSuccessBlock:^(id oauthInfo) {
        ICOAuth *oauth = [ICOAuth initWithAttribute:oauthInfo];
        [ICOAuthTool save:oauth];
        
        [ICNetworkTool loadUserInfoWithURL:ICUserInfoURL success:^(id responseObject) {
            // 构建个人页面
            ICUser *user = [ICUser initWithAttributes:responseObject];
            [headerView.headImageView sd_setImageWithURL:user.avatarURL placeholderImage:[UIImage imageNamed:@"icon_avatar"]];
            headerView.nameLabel.text = user.displayName;
        } failure:^(NSError *error) {
            ICLog(@" error: %@", error);
        }];
        
    } refreshTokenFailureBlock:^(NSError *error) {
        ICLog(@"refresh token error: %@", error);
    } noAccessTokenBlock:nil];
}

- (void)didTappedHeaderView
{
    [self.sideMenuViewController hideMenuViewController];
    self.sideMenuViewController.contentViewController = [[ICNavigationController alloc] initWithRootViewController:[[ICMeViewController alloc] init]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ICDeviceWidth * 0.4;
}

#pragma mark - getters and setters
- (NSMutableArray *)blogLeftMenuTitleArray
{
    if (_blogLeftMenuTitleArray == nil) {
        _blogLeftMenuTitleArray =
        [NSMutableArray arrayWithObjects:@"博客",@"新闻",/*@"闪存",*/@"文库",@"个人",nil];
    }
    return _blogLeftMenuTitleArray;
}

- (ICTableViewDataSource *)leftBlogMenuTableViewDataSource
{
    if (_leftBlogMenuTableViewDataSource == nil) {
        
        // items
        NSMutableArray *items = self.blogLeftMenuTitleArray;
        
        _leftBlogMenuTableViewDataSource = [[ICTableViewDataSource alloc] initWithItems:items cellIdentifier:@"UITableViewCellIdentifier" cellType:@"UITableViewCell" configureBlock:^(UITableViewCell *cell, NSString *item) {
            cell.textLabel.text = item;
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }];
    }
    
    return _leftBlogMenuTableViewDataSource;
}

#pragma mark - getters and setters
- (ICBlogViewController *)blogHomeViewController
{
    if (_blogHomeViewController == nil) {
        _blogHomeViewController = [[ICBlogViewController alloc] init];
    }
    
    return _blogHomeViewController;
}

- (ICNewsViewController *)newsViewController
{
    if (_newsViewController == nil) {
        _newsViewController = [[ICNewsViewController alloc] init];
    }
    
    return _newsViewController;
}

- (ICFlashViewController *)flashViewController
{
    if (_flashViewController == nil) {
        _flashViewController = [[ICFlashViewController alloc] init];
    }
    
    return _flashViewController;
}

- (ICLibraryViewController *)libraryViewController
{
    if (_libraryViewController == nil) {
        _libraryViewController = [[ICLibraryViewController alloc] init];
    }
    
    return _libraryViewController;
}

- (ICMeViewController *)meViewController
{
    if (_meViewController == nil) {
        _meViewController = [[ICMeViewController alloc] init];
    }
    
    return _meViewController;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.scrollEnabled = NO;
        _tableView.dataSource = self.leftBlogMenuTableViewDataSource;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}

@end
