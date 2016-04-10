//
//  ICNewsViewController.m
//  iCnblogs
//
//  Created by poloby on 15/12/29.
//  Copyright © 2015年 poloby. All rights reserved.
//

#import "ICNewsViewController.h"
#import "ICNewsScrollView.h"
#import "ICSearchViewController.h"

#import <HMSegmentedControl/HMSegmentedControl.h>
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>
#import <RESideMenu/RESideMenu.h>

#define ICNewsSegmentCotrolHeight 36
#define ICNewsSegmentColor [UIColor colorWithRed:234/255.0 green:234/255.0 blue:239/255.0 alpha:0.3]

@interface ICNewsViewController () <UIScrollViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) ICNewsScrollView *scrollView;

@property (nonatomic, strong) UISearchController *newsSearchController;

@end

@implementation ICNewsViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    
    self.view.backgroundColor = ICInkColor;
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.scrollView];
    
    [self layoutPageSubViews];
}

- (void)setupNavigationBar
{
    self.navigationItem.title = @"新闻";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_left_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftSideMenuViewController)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btnSearch"] style:UIBarButtonItemStylePlain target:self action:@selector(didTappedSearchBarButton)];
}

- (void)layoutPageSubViews
{
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_leading);
        make.trailing.mas_equalTo(self.view.mas_trailing);
        make.top.mas_equalTo(self.view.mas_top).offset(self.navigationController.navigationBar.height + [UIApplication sharedApplication].statusBarFrame.size.height);
        make.height.mas_equalTo(ICNewsSegmentCotrolHeight);
    }];
}

#pragma mark - event response
- (void)presentLeftSideMenuViewController
{
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (void)didTappedSearchBarButton
{
    ICLog(@"didTappedSearchBarButton");
    [self.navigationController presentViewController:self.newsSearchController animated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate
// 横向滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.view.width;
    NSInteger pageIndex = (NSInteger)(scrollView.contentOffset.x / pageWidth);
    self.segmentedControl.selectedSegmentIndex = pageIndex;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    ICSearchViewController *searchViewController = (ICSearchViewController *)self.newsSearchController.searchResultsController;
    searchViewController.searchString = self.newsSearchController.searchBar.text;
    UITableView *newsSearchTableView = searchViewController.tableView;
    [newsSearchTableView.mj_header beginRefreshing];
}

#pragma mark - getters and setters
- (HMSegmentedControl *)segmentedControl
{
    if (_segmentedControl == nil) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"最新",@"推荐",@"热门"]];
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _segmentedControl.selectionIndicatorColor = [UIColor blackColor];
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.selectionIndicatorHeight = 0.0;
        _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:20.0]};
        _segmentedControl.backgroundColor = ICNewsSegmentColor;
        _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
        
        __weak __typeof__(self) weakSelf = self;
        [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
            [weakSelf.scrollView scrollRectToVisible:CGRectMake(self.view.width * index, 0, weakSelf.view.width, weakSelf.view.height) animated:YES];
        }];
    }
    
    return _segmentedControl;
}

- (ICNewsScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[ICNewsScrollView alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.height + ICNewsSegmentCotrolHeight, self.view.width, self.view.height - self.navigationController.navigationBar.height - [UIApplication sharedApplication].statusBarFrame.size.height - ICNewsSegmentCotrolHeight - self.tabBarController.tabBar.height)];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    
    return _scrollView;
}

- (UISearchController *)newsSearchController
{
    if (_newsSearchController == nil) {
        // 设置resultsViewController
        ICSearchViewController *resultsViewController = [[ICSearchViewController alloc] initWithStyle:UITableViewStylePlain searchType:ICSearchTypeNews];
        
        _newsSearchController = [[UISearchController alloc] initWithSearchResultsController:resultsViewController];
        //_librarySearchController.searchResultsUpdater = self;
        _newsSearchController.searchBar.placeholder = @"输入您要搜索的新闻";
        _newsSearchController.searchBar.tintColor = [UIColor whiteColor];
        _newsSearchController.searchBar.barTintColor = [UIColor blackColor];
        _newsSearchController.searchBar.delegate = self;
    }
    return _newsSearchController;
}

@end
