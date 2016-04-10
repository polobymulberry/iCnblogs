//
//  ICSearchViewController.m
//  iCnblogs
//
//  Created by poloby on 16/4/8.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICSearchViewController.h"
#import "ICBlog.h"
#import "ICNews.h"
#import "ICLibrary.h"
#import "ICSearchTableViewCell.h"
#import "ICNetworkTool.h"
#import "ICSearchModel.h"
#import "ICNavigationController.h"
#import "ICLibraryContentViewController.h"
#import "ICNewsContentViewController.h"

#import <MJRefresh/MJRefresh.h>
#import <UITableView+FDTemplateLayoutCell.h>
#import <KINWebBrowser/KINWebBrowserViewController.h>

static int searchCurrentPageIndex = 0;
static const int searchPageSize = 20; // 每次分页请求的页面大小
// 获取搜索请求的url
static NSString *searchNetworkRequestURL(ICSearchType searchType)
{
    return [NSString stringWithFormat:@"http://api.cnblogs.com/api/ZzkDocuments/%ld", searchType];
}
static NSDictionary *searchNetworkRequestParameters(NSString *keyWords, NSInteger pageIndex)
{
    return @{@"keyWords" : keyWords, @"pageIndex" : [NSNumber numberWithInteger:pageIndex]};
}

@interface ICSearchViewController () 

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) ICTableViewDataSource *searchDataSource;

@end

@implementation ICSearchViewController
#pragma mark - init methods
- (instancetype)initWithStyle:(UITableViewStyle)style searchType:(ICSearchType)searchType
{
    self = [super initWithStyle:style];
    
    if (self) {
        _searchType = searchType;
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[ICSearchTableViewCell class] forCellReuseIdentifier:@"ICSearchTableViewCellIdentifier"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self.searchDataSource;
    [self setupSearchBarRefreshEvents];
}

#pragma mark - UITableViewDelegate
// 该方法会在UITableViewCell创建之前调用
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSInteger index = indexPath.section * tableView.numberOfSections + indexPath.row;
//    
//    CGFloat height = [tableView fd_heightForCellWithIdentifier:@"ICSearchTableViewCellIdentifier" cacheByIndexPath:indexPath configuration:^(ICSearchTableViewCell *cell) {
//        if (self.items.count > index) {
//            cell.searchModel = self.items[index];
//        }
//    }];
    
//    ICLog(@"search view controller height:%f", height);
    // 使用动态计算高度非常耗时，所以我此处直接使用固定高度，大家不介意吧
    return 130.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell = [tableView cellForRowAtIndexPath:indexPath];
    
    switch (self.searchType) {
        case ICSearchTypeBlog: {
            // web显示
            UINavigationController *webBrowserNavigationController = [KINWebBrowserViewController navigationControllerWithWebBrowser];
            [self presentViewController:webBrowserNavigationController animated:YES completion:nil];
            
            KINWebBrowserViewController *webBrowser = [webBrowserNavigationController rootWebBrowser];
            webBrowser.tintColor = [UIColor whiteColor];
            webBrowser.barTintColor = [UIColor blackColor];
            webBrowser.showsURLInNavigationBar = NO;
            webBrowser.showsPageTitleInNavigationBar = YES;
            
            ICSearchModel *item = ((ICSearchTableViewCell *)cell).searchModel;
            [webBrowser loadURL:item.url];
            break;
        }
        case ICSearchTypeNews: {
            // 手动显示
            ICNewsContentViewController *newsContentViewController = [[ICNewsContentViewController alloc] init];
            
            ICNavigationController *navigationController = [[ICNavigationController alloc] initWithRootViewController:newsContentViewController];
            newsContentViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btnBack"] style:UIBarButtonItemStylePlain target:newsContentViewController action:@selector(didTappedLeftBarButtonItem)];
            ICSearchModel *item = ((ICSearchTableViewCell *)cell).searchModel;
            newsContentViewController.newsId = [item.searchId integerValue];
            newsContentViewController.newsTitle = item.title;
            newsContentViewController.newsTime = item.publishTime;
            [self presentViewController:navigationController animated:YES completion:nil];
            break;
        }
        case ICSearchTypeLibrary: {
            // 手动显示
            ICLibraryContentViewController *libraryContentViewController = [[ICLibraryContentViewController alloc] init];
            
            ICNavigationController *navigationController = [[ICNavigationController alloc] initWithRootViewController:libraryContentViewController];
            libraryContentViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btnBack"] style:UIBarButtonItemStylePlain target:libraryContentViewController action:@selector(didTappedLeftBarButtonItem)];
            ICSearchModel *item = ((ICSearchTableViewCell *)cell).searchModel;
            libraryContentViewController.libraryId = [item.searchId integerValue];
            libraryContentViewController.libraryTitle = item.title;
            libraryContentViewController.libraryTime = item.publishTime;
            [self presentViewController:navigationController animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}

#pragma mark - private methods
- (void)setupSearchBarRefreshEvents
{
    __weak __typeof__(self) weakSelf = self;
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.tableView.mj_footer resetNoMoreData];
        
        searchCurrentPageIndex = 1;
        NSString *searchKeyWords = @"";
        if (![weakSelf.searchString isEqualToString:@""]) {
            searchKeyWords = weakSelf.searchString;
        }
        
        NSString *requestURL = searchNetworkRequestURL(weakSelf.searchType);
        NSDictionary *parameters = searchNetworkRequestParameters(searchKeyWords, searchCurrentPageIndex);
        [ICNetworkTool loadDataWithURL:requestURL parameters:parameters success:^(id responseObject) {
            // 因为是要请求新数据，所以先清除原始数据
            if (weakSelf.items.count > 0) {
                [weakSelf.items removeAllObjects];
            }
            // 对请求的JSON数据进行解析
            for (NSDictionary *result in responseObject) {
                ICSearchModel *library = [ICSearchModel initWithAttributes:result];
                [weakSelf.items addObject:library];
            }
            
            // 更新tableView视图
            weakSelf.searchDataSource.items = weakSelf.items;
            [weakSelf.tableView reloadData];
            // 结束下拉刷新
            [weakSelf.tableView.mj_header endRefreshing];
        } failure:^(NSError *error) {
            ICLog(@"library load new data failure:%@", error);
            [weakSelf.tableView.mj_header endRefreshing];
        }];
    }];
    
    // 上拉加载更多资源
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        searchCurrentPageIndex++;
        NSString *searchKeyWords = @"";
        if (![weakSelf.searchString isEqualToString:@""]) {
            searchKeyWords = weakSelf.searchString;
        }
        NSString *requestURL = searchNetworkRequestURL(weakSelf.searchType);
        NSDictionary *parameters = searchNetworkRequestParameters(searchKeyWords, searchCurrentPageIndex);
        [ICNetworkTool loadDataWithURL:requestURL parameters:parameters success:^(id responseObject) {
            // 对请求的JSON数据进行解析
            for (NSDictionary *result in responseObject) {
                ICSearchModel *library = [ICSearchModel initWithAttributes:result];
                [weakSelf.items addObject:library];
            }
            // 更新tableView视图
            weakSelf.searchDataSource.items = weakSelf.items;
            [weakSelf.tableView reloadData];
            // 如果此次获取的JSON数据大小小于pageSize，那说明当前页面为最后一页
            if ([(NSArray *)responseObject count] < searchPageSize) {
                searchCurrentPageIndex--;
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
        } failure:^(NSError *error) {
            ICLog(@"library load more data failure:%@", error);
            [weakSelf.tableView.mj_footer endRefreshing];
        }];
    }];
}

#pragma mark - getters and setters
- (NSMutableArray *)items
{
    if (_items == nil) {
        _items = [[NSMutableArray alloc] init];
    }
    
    return _items;
}

- (ICTableViewDataSource *)searchDataSource
{
    if (_searchDataSource == nil) {
        _searchDataSource = [[ICTableViewDataSource alloc] initWithItems:self.items cellIdentifier:@"ICSearchTableViewCellIdentifier" cellType:@"ICSearchTableViewCell" configureBlock:^(ICSearchTableViewCell *cell, ICSearchModel *item) {
            cell.searchModel = item;
        }];
    }
    
    return _searchDataSource;
}

@end
