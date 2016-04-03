//
//  ICMeViewController.m
//  iCnblogs
//
//  Created by poloby on 16/2/22.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICMeViewController.h"
#import "ICOAuth.h"
#import "ICOAuthTool.h"
#import "ICUser.h"
#import "ICLoginViewController.h"
#import "ICNavigationController.h"
#import "ICUserTableHeaderView.h"
#import "ICUserScrollView.h"
#import "ICLeftSideMenu.h"
#import "ICNetworkTool.h"

#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/Masonry.h>
#import <RESideMenu/RESideMenu.h>
#import <HMSegmentedControl/HMSegmentedControl.h>

#define USER_SEGMENT_COUNT 3
#define ICMeSegmentedControlHeight 36
#define ICUserInfoURL @"http://api.cnblogs.com/api/Users"

@interface ICMeViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) ICUserTableHeaderView *headerView;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UIView *dashLineView;
@property (nonatomic, strong) ICUserScrollView *scrollView;

@end

@implementation ICMeViewController

- (void)viewDidLoad
{
    [self setupNavigationBar];
    self.view.backgroundColor = ICInkColor;
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.dashLineView];
    [self.view addSubview:self.scrollView];
    
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
                   
                   // 跳转回MeViewController
                   ICNavigationController *meNavigationController = [[ICNavigationController alloc] initWithRootViewController:[[ICMeViewController alloc] init]];
                   ICLeftSideMenu *leftMenu = [[ICLeftSideMenu alloc] initWithContentViewController:meNavigationController];
                   [self.navigationController presentViewController:leftMenu animated:YES completion:nil];
               } refreshTokenFailureBlock:^(NSError *error) {
                   ICLog(@"refresh_token failure:%@", error);
               } noAccessTokenBlock:^{
                   ICLoginViewController *loginViewController = [[ICLoginViewController alloc] init];
                   ICNavigationController *navigationController = [[ICNavigationController alloc] initWithRootViewController:loginViewController];
                   [self.navigationController presentViewController:navigationController animated:YES completion:nil];
               }];
}

- (void)setupNavigationBar
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_left_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftSideMenuViewController)];
    
    self.navigationItem.title = @"我";
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_nav_up"] style:UIBarButtonItemStylePlain target:self action:@selector(didTappedLeftBarButton:)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)successWithResponse:(NSDictionary *)response
{
    // 更新user
    ICUser *user = [ICUser initWithAttributes:response];
    [self configureTableViewWithUser:user];
}

- (void)configureTableViewWithUser:(ICUser *)user
{
    [self.headerView.headImageView sd_setImageWithURL:user.avatarURL placeholderImage:[UIImage imageNamed:@"icon_avatar"]];
    self.headerView.nameLabel.text = user.displayName;
    self.headerView.seniorityLabel.text = user.seniority;
}

#pragma mark - event response
- (void)presentLeftSideMenuViewController
{
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (void)didTappedLeftBarButton:(UIBarButtonItem *)barItem
{
    static BOOL isUp = YES;
    
    if (isUp) {
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"icon_nav_down"];
        [self hideHeaderView:YES];
    } else {
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"icon_nav_up"];
        [self hideHeaderView:NO];
    }
    
    isUp = !isUp;
}

#pragma mark - private method
- (void)hideHeaderView:(BOOL)hidden
{
    if (hidden) {
        
        [UIView animateWithDuration:1.0 animations:^{
            self.segmentedControl.frame = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height+self.navigationController.navigationBar.height, ICDeviceWidth, ICMeSegmentedControlHeight);
            self.dashLineView.frame = CGRectMake(ICDeviceWidth * 0.03, [UIApplication sharedApplication].statusBarFrame.size.height+self.navigationController.navigationBar.height + ICMeSegmentedControlHeight + 10, ICDeviceWidth * 0.94, 1.0);
            self.scrollView.frame = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height+self.navigationController.navigationBar.height + ICMeSegmentedControlHeight + 10 + 2, ICDeviceWidth, ICDeviceHeight - ([UIApplication sharedApplication].statusBarFrame.size.height+self.navigationController.navigationBar.height + ICMeSegmentedControlHeight + 10 + 2 + self.tabBarController.tabBar.height));
            self.scrollView.contentSize = CGSizeMake(self.scrollView.width * USER_SEGMENT_COUNT, self.scrollView.height);
            [self.scrollView updateSubViews:self.scrollView.height];
            self.headerView.alpha = 0.0;
        }];
        
        
    } else {
        
        [UIView animateWithDuration:1.0 animations:^{
            self.segmentedControl.frame = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height+self.navigationController.navigationBar.height+ICDeviceWidth*0.5, ICDeviceWidth, ICMeSegmentedControlHeight);
            self.dashLineView.frame = CGRectMake(ICDeviceWidth * 0.03, [UIApplication sharedApplication].statusBarFrame.size.height+self.navigationController.navigationBar.height+ICDeviceWidth*0.5 + ICMeSegmentedControlHeight + 10, ICDeviceWidth * 0.94, 1.0);
            self.scrollView.frame = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height+self.navigationController.navigationBar.height+ICDeviceWidth*0.5 + ICMeSegmentedControlHeight + 10 + 2, ICDeviceWidth, ICDeviceHeight - ([UIApplication sharedApplication].statusBarFrame.size.height+self.navigationController.navigationBar.height+ICDeviceWidth*0.5 + ICMeSegmentedControlHeight + 10 + 2 + self.tabBarController.tabBar.height));
            self.scrollView.contentSize = CGSizeMake(self.scrollView.width * USER_SEGMENT_COUNT, self.scrollView.height);
            [self.scrollView updateSubViews:ICDeviceHeight - ([UIApplication sharedApplication].statusBarFrame.size.height+self.navigationController.navigationBar.height+ICDeviceWidth*0.5 + ICMeSegmentedControlHeight + 10 + 2 + self.tabBarController.tabBar.height)];
            [self.scrollView updateSubViews:self.scrollView.height];
            self.headerView.alpha = 1.0;
        }];
        
        
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.view.width;
    NSInteger pageIndex = (NSInteger)(scrollView.contentOffset.x / pageWidth);
    self.segmentedControl.selectedSegmentIndex = pageIndex;
}

#pragma mark - getters and setters
- (ICUserTableHeaderView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[ICUserTableHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height+self.navigationController.navigationBar.height, ICDeviceWidth, ICDeviceWidth * 0.5);
    }
    
    return _headerView;
}

- (HMSegmentedControl *)segmentedControl
{
    if (_segmentedControl == nil) {
        NSArray *titles = @[@"我的博客", @"我的收藏", @"设置"];
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:titles];
        _segmentedControl.frame = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height+self.navigationController.navigationBar.height+ICDeviceWidth*0.5, ICDeviceWidth, ICMeSegmentedControlHeight);
        // 字体设置
        _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor lightGrayColor], NSFontAttributeName:[UIFont systemFontOfSize:16.0]};
        _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
        _segmentedControl.backgroundColor = [UIColor colorWithWhite:28.0/255.0 alpha:1.0];
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleArrow;
        _segmentedControl.selectionIndicatorHeight = 6.0;
        _segmentedControl.borderType = HMSegmentedControlBorderTypeLeft;
        // 左边会有白线，使用UIView覆盖掉
        UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1.0, 36)];
        coverView.backgroundColor = ICInkColor;
        [_segmentedControl addSubview:coverView];
        
        _segmentedControl.borderColor = [UIColor whiteColor];
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        
        __weak typeof (self) weakSelf = self;
        [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
            [weakSelf.scrollView scrollRectToVisible:CGRectMake(self.scrollView.width * index, 0, weakSelf.scrollView.width, weakSelf.scrollView.height) animated:YES];
        }];
    }
    
    return _segmentedControl;
}

// 虚线
- (UIView *)dashLineView
{
    if (_dashLineView == nil) {
        _dashLineView = [[UIView alloc] initWithFrame:CGRectMake(ICDeviceWidth * 0.03, [UIApplication sharedApplication].statusBarFrame.size.height+self.navigationController.navigationBar.height+ICDeviceWidth*0.5 + 36 + 10, ICDeviceWidth * 0.94, 1.0)];
        [UIView drawDashLine:_dashLineView lineLength:5.0 lineSpacing:5.0 lineColor:[UIColor whiteColor]];
    }
    
    return _dashLineView;
}

- (ICUserScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[ICUserScrollView alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height+self.navigationController.navigationBar.height+ICDeviceWidth*0.5 + 36 + 10 + 2, ICDeviceWidth, ICDeviceHeight - ([UIApplication sharedApplication].statusBarFrame.size.height+self.navigationController.navigationBar.height+ICDeviceWidth*0.5 + 36 + 10 + 2 + self.tabBarController.tabBar.height))];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    
    return _scrollView;
}

@end
