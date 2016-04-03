//
//  ICBlogViewController.m
//  iCnblogs
//
//  Created by poloby on 15/12/29.
//  Copyright © 2015年 poloby. All rights reserved.
//

#import "ICBlogViewController.h"
#import "ICNavigationController.h"
#import "ICBlogScrollView.h"

#import <RESideMenu/RESideMenu.h>
#import <HMSegmentedControl/HMSegmentedControl.h>

#define ICBlogSegmentedControlHeight 36

@interface ICBlogViewController () <UITableViewDelegate, UICollectionViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) HMSegmentedControl *segmentedControl; // segmentedControl
@property (nonatomic, strong) ICBlogScrollView *scrollView; // 自定义的scrollView，存放了首页的tableView和精选的collectionView

@end

@implementation ICBlogViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavigationBar];
    
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.scrollView];
}

- (void)setupNavigationBar
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_left_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftSideMenuViewController)];
    self.navigationItem.title = @"博客";
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // scrollView横向滑动
    CGFloat pageWidth = self.view.width;
    NSInteger pageIndex = (NSInteger)(scrollView.contentOffset.x / pageWidth);
    self.segmentedControl.selectedSegmentIndex = pageIndex;
}

#pragma mark - event response
// 左侧滑栏
- (void)presentLeftSideMenuViewController
{
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (HMSegmentedControl *)segmentedControl
{
    if (_segmentedControl == nil) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"首页", @"精选"]];
        // frame
        _segmentedControl.frame = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.height, ICDeviceWidth, ICBlogSegmentedControlHeight);
        // background
        _segmentedControl.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        // selected or not selected title
        _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:20.0]};
        _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
        // selection indicator
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.selectionIndicatorHeight = 2.0;
        _segmentedControl.selectionIndicatorColor = [UIColor whiteColor];
        // index change block
        __weak typeof (self) weakSelf = self;
        [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
            [weakSelf.scrollView scrollRectToVisible:CGRectMake(self.scrollView.width * index, 0, weakSelf.scrollView.width, weakSelf.scrollView.height) animated:YES];
        }];
    }
    
    return _segmentedControl;
}

- (ICBlogScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[ICBlogScrollView alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.height + ICBlogSegmentedControlHeight, ICDeviceWidth, ICDeviceHeight - ICBlogSegmentedControlHeight - [UIApplication sharedApplication].statusBarFrame.size.height - self.navigationController.navigationBar.height)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    
    return _scrollView;
}

@end
