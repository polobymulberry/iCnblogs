//
//  ICUserBlogTableView.m
//  iCnblogs
//
//  Created by poloby on 16/3/5.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICUserBlogTableView.h"
#import "ICTableViewDataSource.h"
#import "ICUser.h"
#import "ICClientCredentialsOAuth.h"
#import "ICClientCredentialsOAuthTool.h"
#import "ICBlog.h"
#import "ICNavigationController.h"
#import "ICNetworkTool.h"

#import <AFNetworking/AFNetworking.h>
#import <MJRefresh/MJRefresh.h>
#import <KINWebBrowser/KINWebBrowserViewController.h>

static int userBlogCurrentPageIndex = 0;
static const int userBlogPageSize = 10;
// 获取request url
static NSString *userBlogNetworkRequestURL(NSString *blogApp ,int pageIndex)
{
    return [NSString stringWithFormat:@"http://api.cnblogs.com/api/blogs/%@/posts?pageIndex=%d", blogApp, pageIndex];
}

@interface ICUserBlogTableView () <UITableViewDelegate>

@property (nonatomic, strong) ICTableViewDataSource *blogDataSource;
@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation ICUserBlogTableView

#pragma mark - init methods
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:28.0/255.0 alpha:1.0];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.delegate = self;
        self.dataSource = self.blogDataSource;
        [self setupTableViewRefreshEvents];
    }
    
    return self;
}

- (void)setupTableViewRefreshEvents
{
    __weak __typeof__(self) weakSelf = self;
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.mj_footer resetNoMoreData];
        if ([ICUser user].blogApp && [ICClientCredentialsOAuthTool isOAuthInfoExistedInStoredData]) {
            userBlogCurrentPageIndex = 1;
            NSString *requestURL = userBlogNetworkRequestURL([ICUser user].blogApp, userBlogCurrentPageIndex);
            
            [ICNetworkTool loadDataWithURL:requestURL success:^(id responseObject) {
                // 因为是要请求新数据，所以先清除原始数据
                if (weakSelf.items.count > 0) {
                    [weakSelf.items removeAllObjects];
                }
                // 对请求的JSON数据进行解析
                for (NSDictionary *result in responseObject) {
                    ICBlog *blog = [ICBlog initWithAttributes:result];
                    [weakSelf.items addObject:blog];
                }
                
                // 更新tableView视图
                weakSelf.blogDataSource.items = weakSelf.items;
                [weakSelf reloadData];
                // 结束下拉刷新
                [weakSelf.mj_header endRefreshing];
            } failure:^(NSError *error) {
                ICLog(@"user blog load new data failure: %@", error);
                [weakSelf.mj_header endRefreshing];
            }];
        }
     }];
    
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if ([ICUser user].blogApp && [ICClientCredentialsOAuthTool isOAuthInfoExistedInStoredData]) {
            userBlogCurrentPageIndex++;
            NSString *requestURL = userBlogNetworkRequestURL([ICUser user].blogApp, userBlogCurrentPageIndex);
            [ICNetworkTool loadDataWithURL:requestURL success:^(id responseObject) {
                // 对请求的JSON数据进行解析
                for (NSDictionary *result in responseObject) {
                    ICBlog *blog = [ICBlog initWithAttributes:result];
                    [weakSelf.items addObject:blog];
                }
                
                // 更新tableView视图
                weakSelf.blogDataSource.items = weakSelf.items;
                [weakSelf reloadData];
                // 如果此次获取的JSON数据大小小于pageSize，那说明当前页面为最后一页
                if ([(NSArray *)responseObject count] < userBlogPageSize) {
                    userBlogCurrentPageIndex--;
                    [weakSelf.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [weakSelf.mj_footer endRefreshing];
                }
            } failure:^(NSError *error) {
                ICLog(@"user blog load more data failure: %@", error);
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
    
    NSInteger index = indexPath.row;
    if (cell) {
        UINavigationController *webBrowserNavigationController = [KINWebBrowserViewController navigationControllerWithWebBrowser];
        [[self findViewController] presentViewController:webBrowserNavigationController animated:YES completion:nil];
        
        KINWebBrowserViewController *webBrowser = [webBrowserNavigationController rootWebBrowser];
        webBrowser.tintColor = [UIColor whiteColor];
        webBrowser.barTintColor = [UIColor blackColor];
        webBrowser.showsURLInNavigationBar = NO;
        webBrowser.showsPageTitleInNavigationBar = YES;
        
        ICBlog *blog = self.items[index];
        [webBrowser loadURL:blog.url];
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

- (ICTableViewDataSource *)blogDataSource
{
    if (_blogDataSource == nil) {
        _blogDataSource = [[ICTableViewDataSource alloc] initWithItems:self.items cellIdentifier:@"UITableViewCellIdentifier" cellType:@"UITableViewCell" configureBlock:^(UITableViewCell *cell, ICBlog *item) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = item.title;
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.font = [UIFont systemFontOfiPhone4OrLessSize:12.0 iPhone5Size:12.0 iPhone6Or6SSize:14.0 iPhone6PlusOr6SPlusSize:16.0];
            cell.backgroundColor = ICInkColor;
        }];
    }
    
    return _blogDataSource;
}

@end
