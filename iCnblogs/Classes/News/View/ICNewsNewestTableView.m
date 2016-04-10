//
//  ICNewsNewestTableView.m
//  iCnblogs
//
//  Created by poloby on 16/1/9.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICNewsNewestTableView.h"
#import "ICNavigationController.h"
#import "ICNewsContentViewController.h"
#import "ICTableViewDataSource.h"
#import "ICNewsTableViewCell.h"
#import "ICNews.h"
#import "ICClientCredentialsOAuthTool.h"
#import "ICClientCredentialsOAuth.h"
#import "ICNetworkTool.h"

#import <MJRefresh/MJRefresh.h>
#import <AFNetworking/AFNetworking.h>

static int newestNewsCurrentPageIndex = 0; // 当前分页请求的页面号
static const int newestNewsPageSize = 10; // 每次分页请求的页面大小
// 获取request url
static NSString* newestNewsNetworkRequestURL(int pageIndex, int pageSize)
{
    return [NSString stringWithFormat:@"http://api.cnblogs.com/api/NewsItems?pageIndex=%d&pageSize=%d", newestNewsCurrentPageIndex, newestNewsPageSize];
}

@interface ICNewsNewestTableView () <UITableViewDelegate>

@property (nonatomic, strong) ICTableViewDataSource *newestNewsDataSource;
@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation ICNewsNewestTableView

#pragma mark - init methods
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.backgroundColor = ICSilverColor;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.delegate = self;
        self.dataSource = self.newestNewsDataSource;
        // 我也不知道为什么把网络请求放在这，明明应该是Controller做的事。希
        // 希望大家可以给我提提意见，这个问题我想了很久了
        [self setupTableViewRefreshEvents];
    }
    
    return self;
}

- (void)setupTableViewRefreshEvents
{
    __weak __typeof__(self) weakSelf = self;
    // 下拉刷新
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.mj_footer resetNoMoreData];
        
        newestNewsCurrentPageIndex = 1;
        NSString *requestURL = newestNewsNetworkRequestURL(newestNewsCurrentPageIndex, newestNewsPageSize);
        [ICNetworkTool loadDataWithURL:requestURL success:^(id responseObject) {
            // 因为是要请求新数据，所以先清除原始数据
            if (weakSelf.items.count > 0) {
                [weakSelf.items removeAllObjects];
            }
            // 对请求的JSON数据进行解析
            for (NSDictionary *result in responseObject) {
                ICNews *news = [ICNews initWithAttributes:result];
                [weakSelf.items addObject:news];
            }
            
            // 更新tableView视图
            weakSelf.newestNewsDataSource.items = weakSelf.items;
            [weakSelf reloadData];
            // 结束下拉刷新
            [weakSelf.mj_header endRefreshing];
        } failure:^(NSError *error) {
            ICLog(@"newest news load new data failure:%@", error);
            [weakSelf.mj_header endRefreshing];
        }];
    }];
    
    // 上拉加载更多资源
    self.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        newestNewsCurrentPageIndex++;
        NSString *requestURL = newestNewsNetworkRequestURL(newestNewsCurrentPageIndex, newestNewsPageSize);
        [ICNetworkTool loadDataWithURL:requestURL success:^(id responseObject) {
            // 对请求的JSON数据进行解析
            for (NSDictionary *result in responseObject) {
                ICNews *news = [ICNews initWithAttributes:result];
                [weakSelf.items addObject:news];
            }
            // 更新tableView视图
            weakSelf.newestNewsDataSource.items = weakSelf.items;
            [weakSelf reloadData];
            // 如果此次获取的JSON数据大小小于pageSize，那说明当前页面为最后一页
            if ([(NSArray *)responseObject count] < newestNewsPageSize) {
                newestNewsCurrentPageIndex--;
                [weakSelf.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakSelf.mj_footer endRefreshing];
            }
        } failure:^(NSError *error) {
            ICLog(@"newest news load more data failure:%@", error);
            [weakSelf.mj_footer endRefreshing];
        }];
    }];
    
    [self.mj_header beginRefreshing];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ICDeviceWidth * 0.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ICNewsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    ICNewsContentViewController *newsContentViewController = [[ICNewsContentViewController alloc] init];
    UIViewController *viewController = [self findViewController];
    ICNavigationController *navigationController = (ICNavigationController *)viewController.navigationController;
    
    // 自定义newsContentViewController的返回图片<
    [navigationController.navigationBar setBackIndicatorImage:[UIImage imageNamed:@"btnBack"]];
    [navigationController.navigationBar setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"btnBack"]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    viewController.navigationItem.backBarButtonItem = backItem;
    
    // 跳转到newsContentViewController
    newsContentViewController.pushedViewControllerId = 0;
    [navigationController pushViewController:newsContentViewController items:cell.news animated:YES constructingBodyWithBlock:^(ICNewsContentViewController *viewController, ICNews *items) {
        viewController.newsId = items.newsId;
        viewController.newsTitle = items.title;
        viewController.newsTime = items.dateAdded;
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

- (ICTableViewDataSource *)newestNewsDataSource
{
    if (_newestNewsDataSource == nil) {
        _newestNewsDataSource = [[ICTableViewDataSource alloc] initWithItems:self.items cellIdentifier:@"ICNewsTableViewCellIdentifier" cellType:@"ICNewsTableViewCell" configureBlock:^(ICNewsTableViewCell *cell, ICNews *item) {
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.news = item;
        }];
    }
    
    return _newestNewsDataSource;
}

@end
