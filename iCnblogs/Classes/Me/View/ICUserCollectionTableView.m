//
//  ICUserCollectionTableView.m
//  iCnblogs
//
//  Created by poloby on 16/3/5.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICUserCollectionTableView.h"
#import "ICTableViewDataSource.h"
#import "ICOAuth.h"
#import "ICOAuthTool.h"
#import "ICNavigationController.h"
#import "ICCollection.h"
#import "ICNetworkTool.h"

#import <AFNetworking/AFNetworking.h>
#import <MJRefresh/MJRefresh.h>
#import <KINWebBrowser/KINWebBrowserViewController.h>

static int collectionCurrentPageIndex = 0; // 当前分页请求的页面号
static const int collectionPageSize = 10; // 每次分页请求的页面大小
// 获取request url
static NSString *collectionNetworkRequestURL(int pageIndex, int pageSize)
{
    return [NSString stringWithFormat:@"http://api.cnblogs.com/api/Bookmarks?pageIndex=%d&pageSize=%d", pageIndex, pageSize];
}

@interface ICUserCollectionTableView () <UITableViewDelegate>

@property (nonatomic, strong) ICTableViewDataSource *collectionDataSource;
@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation ICUserCollectionTableView

#pragma mark - init methods
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:28.0/255.0 alpha:1.0];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.delegate = self;
        self.dataSource = self.collectionDataSource;
        [self setupTableViewRefreshEvents];
    }
    
    return self;
}

- (void)setupTableViewRefreshEvents
{
    __weak __typeof__(self) weakSelf = self;
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.mj_footer resetNoMoreData];
        
        if ([ICOAuthTool isOAuthInfoExistedInStoredData]) {
            collectionCurrentPageIndex = 1;
            NSString *requestURL = collectionNetworkRequestURL(collectionCurrentPageIndex, collectionPageSize);
            
            [ICNetworkTool loadUserInfoWithURL:requestURL success:^(id responseObject) {
                // 因为是要请求新数据，所以先清除原始数据
                if (weakSelf.items.count > 0) {
                    [weakSelf.items removeAllObjects];
                }
                // 对请求的JSON数据进行解析
                for (NSDictionary *result in responseObject) {
                    ICCollection *collection = [[ICCollection alloc] initWithAttributes:result];
                    [weakSelf.items addObject:collection];
                }
                
                // 更新tableView视图
                weakSelf.collectionDataSource.items = weakSelf.items;
                [weakSelf reloadData];
                // 结束下拉刷新
                [weakSelf.mj_header endRefreshing];
            } failure:^(NSError *error) {
                ICLog(@"collection load new data failure: %@", error);
                [weakSelf.mj_header endRefreshing];
            }];
        }
    }];
    
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if ([ICOAuthTool isOAuthInfoExistedInStoredData]) {
            collectionCurrentPageIndex++;
            NSString *requestURL = collectionNetworkRequestURL(collectionCurrentPageIndex, collectionPageSize);
            
            [ICNetworkTool loadDataWithURL:requestURL success:^(id responseObject) {
                // 对请求的JSON数据进行解析
                for (NSDictionary *result in responseObject) {
                    ICCollection *collection = [[ICCollection alloc] initWithAttributes:result];
                    [weakSelf.items addObject:collection];
                }
                // 更新tableView视图
                weakSelf.collectionDataSource.items = weakSelf.items;
                [weakSelf reloadData];
                // 如果此次获取的JSON数据大小小于pageSize，那说明当前页面为最后一页
                if ([(NSArray *)responseObject count] < collectionPageSize) {
                    collectionCurrentPageIndex--;
                    [weakSelf.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [weakSelf.mj_footer endRefreshing];
                }
            } failure:^(NSError *error) {
                ICLog(@"library load more data failure:%@", error);
                [weakSelf.mj_footer endRefreshing];
            }];
        }
    }];
    
    [self.mj_header beginRefreshing];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (cell) {
        UINavigationController *webBrowserNavigationController = [KINWebBrowserViewController navigationControllerWithWebBrowser];
        [[self findViewController] presentViewController:webBrowserNavigationController animated:YES completion:nil];
        
        KINWebBrowserViewController *webBrowser = [webBrowserNavigationController rootWebBrowser];
        webBrowser.tintColor = [UIColor whiteColor];
        webBrowser.barTintColor = [UIColor blackColor];
        webBrowser.showsURLInNavigationBar = NO;
        webBrowser.showsPageTitleInNavigationBar = YES;
        
        [webBrowser loadURL:((ICCollection *)self.items[indexPath.row]).linkUrl];
    }
}

#pragma mark - getters and setters
- (NSMutableArray *)items
{
    if (_items == nil) {
        _items = [[NSMutableArray alloc] init];
    }
    
    return _items;
}

- (ICTableViewDataSource *)collectionDataSource
{
    if (_collectionDataSource == nil) {
        _collectionDataSource = [[ICTableViewDataSource alloc] initWithItems:self.items cellIdentifier:@"UITableViewCellIdentifier" cellType:@"UITableViewCell" configureBlock:^(UITableViewCell *cell, ICCollection *item) {
            cell.textLabel.text = item.title;
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.font = [UIFont systemFontOfiPhone4OrLessSize:12.0 iPhone5Size:12.0 iPhone6Or6SSize:14.0 iPhone6PlusOr6SPlusSize:16.0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithWhite:28.0/255.0 alpha:1.0];
        }];
    }
    
    return _collectionDataSource;
}

@end
