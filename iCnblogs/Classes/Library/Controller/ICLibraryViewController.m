//
//  ICLibraryViewController.m
//  iCnblogs
//
//  Created by poloby on 16/3/11.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICLibraryViewController.h"
#import "ICTableViewDataSource.h"
#import "ICLibrary.h"
#import "ICClientCredentialsOAuthTool.h"
#import "ICClientCredentialsOAuth.h"
#import "ICLibraryTableViewCell.h"
#import "ICLibraryContentViewController.h"
#import "ICSearchViewController.h"
#import "ICNavigationController.h"
#import "ICNetworkTool.h"
#import "ICSearchModel.h"
#import "ICSearchTableViewCell.h"

#import <RESideMenu/RESideMenu.h>
#import <MJRefresh/MJRefresh.h>
#import <AFNetworking/AFNetworking.h>
#import <Masonry/Masonry.h>
#import <UITableView+FDTemplateLayoutCell.h>

static int libraryCurrentPageIndex = 0; // 当前分页请求的页面号
static const int libraryPageSize = 10; // 每次分页请求的页面大小
// 获取request url
static NSString *libraryNetworkRequestURL(int pageIndex, int pageSize)
{
    return [NSString stringWithFormat:@"http://api.cnblogs.com/api/KbArticles?pageIndex=%d&pageSize=%d", pageIndex, pageSize];
}

@interface ICLibraryViewController () <UITableViewDelegate, UISearchBarDelegate>//, UISearchResultsUpdating>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ICTableViewDataSource *libraryDataSource;
@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) UISearchController *librarySearchController;

@end

@implementation ICLibraryViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [self setupNavigationBar];
    
    [self.view addSubview:self.tableView];
    
    [self layoutSubPageViews];
}

- (void)setupNavigationBar
{
    self.navigationItem.title = @"文库";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_left_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftSideMenuViewController)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btnSearch"] style:UIBarButtonItemStylePlain target:self action:@selector(didTappedSearchBarButton)];
}

- (void)layoutSubPageViews
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark - UITableViewDelegte
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ICDeviceWidth * 0.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ICLibraryTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (cell) {
        ICLibraryContentViewController *libraryContentViewController = [[ICLibraryContentViewController alloc] init];
        
        // 自定义返回图片<
        [self.navigationController.navigationBar setBackIndicatorImage:[UIImage imageNamed:@"btnBack"]];
        [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"btnBack"]];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = backItem;
        
        [(ICNavigationController *)self.navigationController pushViewController:libraryContentViewController items:cell.library animated:YES constructingBodyWithBlock:^(ICLibraryContentViewController *viewController, ICLibrary *items) {
            viewController.libraryId = items.libraryId;
            viewController.libraryTitle = items.title;
            viewController.libraryTime = items.dateAdded;
        }];
    }
}

//#pragma mark - UISearchResultsUpdating
//- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
//{
//    ICSearchViewController *searchViewController = (ICSearchViewController *)self.librarySearchController.searchResultsController;
//    searchViewController.searchString = self.librarySearchController.searchBar.text;
//    UITableView *librarySearchTableView = searchViewController.tableView;
//    [librarySearchTableView.mj_header beginRefreshing];
//}
#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    ICSearchViewController *searchViewController = (ICSearchViewController *)self.librarySearchController.searchResultsController;
    searchViewController.searchString = self.librarySearchController.searchBar.text;
    UITableView *librarySearchTableView = searchViewController.tableView;
    [librarySearchTableView.mj_header beginRefreshing];
}

#pragma mark - event response
- (void)presentLeftSideMenuViewController
{
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (void)didTappedSearchBarButton
{
    ICLog(@"didTappedSearchBarButton");
    [self.navigationController presentViewController:self.librarySearchController animated:YES completion:nil];
}

#pragma mark - private methods
- (void)setupTableViewRefreshEvents
{
    __weak __typeof__(self) weakSelf = self;
    // 下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_tableView.mj_footer resetNoMoreData];
        
        libraryCurrentPageIndex = 1;
        NSString *requestURL = libraryNetworkRequestURL(libraryCurrentPageIndex, libraryPageSize);
        [ICNetworkTool loadDataWithURL:requestURL success:^(id responseObject) {
            // 因为是要请求新数据，所以先清除原始数据
            if (weakSelf.items.count > 0) {
                [weakSelf.items removeAllObjects];
            }
            // 对请求的JSON数据进行解析
            for (NSDictionary *result in responseObject) {
                ICLibrary *library = [ICLibrary initWithAttributes:result];
                [weakSelf.items addObject:library];
            }
            
            // 更新tableView视图
            weakSelf.libraryDataSource.items = weakSelf.items;
            [_tableView reloadData];
            // 结束下拉刷新
            [_tableView.mj_header endRefreshing];
        } failure:^(NSError *error) {
            ICLog(@"library load new data failure:%@", error);
            [_tableView.mj_header endRefreshing];
        }];
    }];
    
    // 上拉加载更多资源
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        libraryCurrentPageIndex++;
        NSString *requestURL = libraryNetworkRequestURL(libraryCurrentPageIndex, libraryPageSize);
        [ICNetworkTool loadDataWithURL:requestURL success:^(id responseObject) {
            // 对请求的JSON数据进行解析
            for (NSDictionary *result in responseObject) {
                ICLibrary *library = [ICLibrary initWithAttributes:result];
                [weakSelf.items addObject:library];
            }
            // 更新tableView视图
            weakSelf.libraryDataSource.items = weakSelf.items;
            [_tableView reloadData];
            // 如果此次获取的JSON数据大小小于pageSize，那说明当前页面为最后一页
            if ([(NSArray *)responseObject count] < libraryPageSize) {
                libraryCurrentPageIndex--;
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [_tableView.mj_footer endRefreshing];
            }
        } failure:^(NSError *error) {
            ICLog(@"library load more data failure:%@", error);
            [_tableView.mj_footer endRefreshing];
        }];
    }];
    
    [_tableView.mj_header beginRefreshing];
}



#pragma mark - getters and setters
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = ICInkColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self.libraryDataSource;
        
        [self setupTableViewRefreshEvents];
    }
    
    return _tableView;
}

- (ICTableViewDataSource *)libraryDataSource
{
    if (_libraryDataSource == nil) {
        _libraryDataSource = [[ICTableViewDataSource alloc] initWithItems:self.items cellIdentifier:@"ICLibraryTableViewCellIdentifier" cellType:@"ICLibraryTableViewCell" configureBlock:^(ICLibraryTableViewCell *cell, ICLibrary *item) {
            cell.library = item;
            cell.backgroundColor = [UIColor blackColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }];
    }
    
    return _libraryDataSource;
}

- (NSMutableArray *)items
{
    if (_items == nil) {
        _items = [[NSMutableArray alloc] init];
    }
    
    return _items;
}

- (UISearchController *)librarySearchController
{
    if (_librarySearchController == nil) {
        // 设置resultsViewController
        ICSearchViewController *resultsViewController = [[ICSearchViewController alloc] initWithStyle:UITableViewStylePlain searchType:ICSearchTypeLibrary];

        _librarySearchController = [[UISearchController alloc] initWithSearchResultsController:resultsViewController];
        //_librarySearchController.searchResultsUpdater = self;
        _librarySearchController.searchBar.placeholder = @"输入您要搜索的文库";
        _librarySearchController.searchBar.tintColor = [UIColor whiteColor];
        _librarySearchController.searchBar.barTintColor = [UIColor blackColor];
        _librarySearchController.searchBar.delegate = self;
    }
    return _librarySearchController;
}

@end
