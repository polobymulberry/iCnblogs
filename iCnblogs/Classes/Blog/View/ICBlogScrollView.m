//
//  ICBlogScrollView.m
//  iCnblogs
//
//  Created by poloby on 16/3/11.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICBlogScrollView.h"
#import "ICBlogHomeTableViewCell.h"
#import "ICBlogHomeCellPanelView.h"
#import "ICBlogPickedCollectionViewLayout.h"
#import "ICTableViewDataSource.h"
#import "ICCollectionViewDataSource.h"
#import "ICBlogPickedCollectionViewCell.h"
#import "ICClientCredentialsOAuthTool.h"
#import "ICClientCredentialsOAuth.h"
#import "ICBlog.h"
#import "ICNetworkTool.h"

#import <AFNetworking/AFNetworking.h>
#import <MJRefresh/MJRefresh.h>
#import <Masonry/Masonry.h>
#import <UITableView+FDTemplateLayoutCell.h>
#import <KINWebBrowser/KINWebBrowserViewController.h>

static int homeBlogCurrentPageIndex = 0; // 当前分页请求的页面号
static const int homeBlogPageSize = 10; // 每次分页请求的页面大小
static int pickedBlogCurrentPageIndex = 0; // 同上
static const int pickedBlogPageSize = 10; // 同上

static NSString* homeBlogNetworkRequestURL(int pageIndex, int pageSize)
{
    return [NSString stringWithFormat:@"http://api.cnblogs.com/api/blogposts/@sitehome?pageIndex=%d&pageSize=%d", pageIndex, pageSize];
}

static NSString* pickedBlogNetworkRequestURL(int pageIndex, int pageSize)
{
    return [NSString stringWithFormat:@"http://api.cnblogs.com/api/blogposts/@picked?pageIndex=%d&pageSize=%d", pageIndex, pageSize];
}

@interface ICBlogScrollView() <UICollectionViewDelegate, UITableViewDelegate>
// 首页
@property (nonatomic, strong) NSMutableArray *homeBlogItems;
@property (nonatomic, strong) UITableView *homeTableView;
@property (nonatomic, strong) ICTableViewDataSource *tableViewDataSource;
// 精选
@property (nonatomic, strong) NSMutableArray *pickedBlogItems;
@property (nonatomic, strong) UICollectionView *pickedCollectionView;
@property (nonatomic, strong) ICBlogPickedCollectionViewLayout *collectionViewLayout;
@property (nonatomic, strong) ICCollectionViewDataSource *collectionViewDataSource;

@end

@implementation ICBlogScrollView

#pragma mark - init methods
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.contentSize = CGSizeMake(frame.size.width * 2, frame.size.height);
        
        [self addSubview:self.homeTableView];
        [self addSubview:self.pickedCollectionView];
    }
    
    return self;
}

#pragma mark - UITableViewDelegate
// 该方法会在UITableViewCell创建之前调用
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.section * tableView.numberOfSections + indexPath.row;
    
    return [tableView fd_heightForCellWithIdentifier:@"ICBlogHomeTableViewCellIdentifier" configuration:^(ICBlogHomeTableViewCell *cell) {
        if (self.homeBlogItems.count > index) {
            cell.homeBlog = self.homeBlogItems[index];
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UINavigationController *webBrowserNavigationController = [KINWebBrowserViewController navigationControllerWithWebBrowser];
    [[self findViewController] presentViewController:webBrowserNavigationController animated:YES completion:nil];
    
    KINWebBrowserViewController *webBrowser = [webBrowserNavigationController rootWebBrowser];
    webBrowser.tintColor = [UIColor whiteColor];
    webBrowser.barTintColor = [UIColor blackColor];
    webBrowser.showsURLInNavigationBar = NO;
    webBrowser.showsPageTitleInNavigationBar = YES;
    
    ICBlog *blog = self.homeBlogItems[indexPath.row];
    [webBrowser loadURL:blog.url];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UINavigationController *webBrowserNavigationController = [KINWebBrowserViewController navigationControllerWithWebBrowser];
    [[self findViewController] presentViewController:webBrowserNavigationController animated:YES completion:nil];
    
    KINWebBrowserViewController *webBrowser = [webBrowserNavigationController rootWebBrowser];
    webBrowser.tintColor = [UIColor whiteColor];
    webBrowser.barTintColor = [UIColor blackColor];
    webBrowser.showsURLInNavigationBar = NO;
    webBrowser.showsPageTitleInNavigationBar = YES;
    
    ICBlog *blog = self.pickedBlogItems[indexPath.row];
    [webBrowser loadURL:blog.url];
}

#pragma mark - private methods
- (void)setupHomeBlogTableViewRefreshEvents
{
    __weak __typeof__(self) weakSelf = self;
    
    // 下拉刷新
    _homeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_homeTableView.mj_footer resetNoMoreData];
        
        homeBlogCurrentPageIndex = 1;
        NSString *requestURL = homeBlogNetworkRequestURL(homeBlogCurrentPageIndex, homeBlogPageSize);
        [ICNetworkTool loadDataWithURL:requestURL success:^(id responseObject) {
            // 因为是要请求新数据，所以先清除原始数据
            if (weakSelf.homeBlogItems.count > 0) {
                [weakSelf.homeBlogItems removeAllObjects];
            }
            // 对请求的JSON数据进行解析
            for (NSDictionary *result in responseObject) {
                ICBlog *blog = [ICBlog initWithAttributes:result];
                [weakSelf.homeBlogItems addObject:blog];
            }
            
            // 更新tableView视图
            weakSelf.tableViewDataSource.items = weakSelf.homeBlogItems;
            [_homeTableView reloadData];
            // 结束下拉刷新
            [_homeTableView.mj_header endRefreshing];
        } failure:^(NSError *error) {
            ICLog(@"home blog load new data failure:%@", error);
            [_homeTableView.mj_header endRefreshing];
        }];
    }];
    
    // 上拉加载更多资源
    _homeTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        homeBlogCurrentPageIndex++;
        NSString *requestURL = homeBlogNetworkRequestURL(homeBlogCurrentPageIndex, homeBlogPageSize);
        [ICNetworkTool loadDataWithURL:requestURL success:^(id responseObject) {
            // 对请求的JSON数据进行解析
            for (NSDictionary *result in responseObject) {
                ICBlog *blog = [ICBlog initWithAttributes:result];
                [weakSelf.homeBlogItems addObject:blog];
            }
            // 更新tableView视图
            weakSelf.tableViewDataSource.items = weakSelf.homeBlogItems;
            [_homeTableView reloadData];
            // 如果此次获取的JSON数据大小小于pageSize，那说明当前页面为最后一页
            if ([(NSArray *)responseObject count] < homeBlogPageSize) {
                homeBlogCurrentPageIndex--;
                [_homeTableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [_homeTableView.mj_footer endRefreshing];
            }
        } failure:^(NSError *error) {
            ICLog(@"home blog load more data failure:%@", error);
            [_homeTableView.mj_footer endRefreshing];
        }];
    }];
    
    [_homeTableView.mj_header beginRefreshing];
}

- (void)setupPickedBlogCollectionViewRefreshEvents
{
    __weak __typeof__(self) weakSelf = self;
    
    _pickedCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_pickedCollectionView.mj_footer resetNoMoreData];
        
        pickedBlogCurrentPageIndex = 1;
        NSString *requestURL = pickedBlogNetworkRequestURL(pickedBlogCurrentPageIndex, pickedBlogPageSize);
        [ICNetworkTool loadDataWithURL:requestURL success:^(id responseObject) {
            // 因为是要请求新数据，所以先清除原始数据
            if (weakSelf.pickedBlogItems.count > 0) {
                [weakSelf.pickedBlogItems removeAllObjects];
            }
            // 对请求的JSON数据进行解析
            for (NSDictionary *result in responseObject) {
                ICBlog *blog = [ICBlog initWithAttributes:result];
                [weakSelf.pickedBlogItems addObject:blog];
            }
            
            // 更新tableView视图
            weakSelf.collectionViewDataSource.items = weakSelf.pickedBlogItems;
            [_pickedCollectionView reloadData];
            // 结束下拉刷新
            [_pickedCollectionView.mj_header endRefreshing];
        } failure:^(NSError *error) {
            ICLog(@"picked blog load new data failure:%@", error);
            [_pickedCollectionView.mj_header endRefreshing];
        }];
    }];
    
    _pickedCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        pickedBlogCurrentPageIndex++;
        NSString *requestURL = pickedBlogNetworkRequestURL(pickedBlogCurrentPageIndex, pickedBlogPageSize);
        [ICNetworkTool loadDataWithURL:requestURL success:^(id responseObject) {
            // 对请求的JSON数据进行解析
            for (NSDictionary *result in responseObject) {
                ICBlog *blog = [ICBlog initWithAttributes:result];
                [weakSelf.pickedBlogItems addObject:blog];
            }
            // 更新tableView视图
            weakSelf.collectionViewDataSource.items = weakSelf.pickedBlogItems;
            [_pickedCollectionView reloadData];
            // 如果此次获取的JSON数据大小小于pageSize，那说明当前页面为最后一页
            if ([(NSArray *)responseObject count] < homeBlogPageSize) {
                pickedBlogCurrentPageIndex--;
                [_pickedCollectionView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [_pickedCollectionView.mj_footer endRefreshing];
            }
        } failure:^(NSError *error) {
            ICLog(@"picked blog load more data failure:%@", error);
            [_pickedCollectionView.mj_footer endRefreshing];
        }];
    }];

    [_pickedCollectionView.mj_header beginRefreshing];
}
    
#pragma mark - getters and setters
- (UITableView *)homeTableView
{
    if (_homeTableView == nil) {
        //self.tableView.fd_debugLogEnabled = YES;
        _homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        // 使用fd这个库所需步骤
        [_homeTableView registerClass:[ICBlogHomeTableViewCell class] forCellReuseIdentifier:@"ICBlogHomeTableViewCellIdentifier"];
        _homeTableView.backgroundColor = ICSilverColor;
        _homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _homeTableView.showsVerticalScrollIndicator = NO;
        _homeTableView.delegate = self;
        _homeTableView.dataSource = self.tableViewDataSource;
        [self setupHomeBlogTableViewRefreshEvents];
    }
    
    return _homeTableView;
}

- (ICTableViewDataSource *)tableViewDataSource
{
    if (_tableViewDataSource == nil) {
        _tableViewDataSource = [[ICTableViewDataSource alloc] initWithItems:self.homeBlogItems cellIdentifier:@"ICBlogHomeTableViewCellIdentifier" cellType:@"ICBlogHomeTableViewCell" configureBlock:^(ICBlogHomeTableViewCell *cell, ICBlog *item) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.homeBlog = item;
        }];
    }
    
    return _tableViewDataSource;
}

- (NSMutableArray *)homeBlogItems
{
    if (_homeBlogItems == nil) {
        _homeBlogItems = [NSMutableArray array];
    }
    
    return _homeBlogItems;
}

- (UICollectionView *)pickedCollectionView
{
    if (_pickedCollectionView == nil) {
        _pickedCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.size.width, 0, self.size.width, self.size.height) collectionViewLayout:self.collectionViewLayout];
        [_pickedCollectionView registerClass:[ICBlogPickedCollectionViewCell class] forCellWithReuseIdentifier:@"ICBlogPickedCollectionViewCellIdentifier"];
        _pickedCollectionView.backgroundColor = ICInkColor;
        _pickedCollectionView.delegate = self;
        _pickedCollectionView.dataSource = self.collectionViewDataSource;
        [self setupPickedBlogCollectionViewRefreshEvents];
    }
    
    return _pickedCollectionView;
}

- (ICBlogPickedCollectionViewLayout *)collectionViewLayout
{
    if (_collectionViewLayout == nil) {
        
        CGFloat radius = ICDeviceWidth * 0.7;
        CGFloat angularSpacing = 20;
        CGFloat xOffset = ICDeviceWidth * 0.2;
        CGFloat cell_width = ICDeviceWidth * 0.7;
        CGFloat cell_height = ICDeviceWidth * 0.3;
        
        _collectionViewLayout = [[ICBlogPickedCollectionViewLayout alloc] initWithRadius:radius angularSpacing:angularSpacing cellSize:CGSizeMake(cell_width, cell_height) anligment:WheetAlignmentTypeLeft itemHeight:cell_height xOffset:xOffset];
    }
    
    return _collectionViewLayout;
}

- (ICCollectionViewDataSource *)collectionViewDataSource
{
    if (_collectionViewDataSource == nil) {
        _collectionViewDataSource = [[ICCollectionViewDataSource alloc] initWithItems:self.pickedBlogItems cellIdentifier:@"ICBlogPickedCollectionViewCellIdentifier" configureBlock:^(ICBlogPickedCollectionViewCell *cell, ICBlog *item) {
            cell.pickedBlog = item;
        }];
    }
    
    return _collectionViewDataSource;
}

- (NSMutableArray *)pickedBlogItems
{
    if (_pickedBlogItems == nil) {
        _pickedBlogItems = [[NSMutableArray alloc] init];
    }
    
    return _pickedBlogItems;
}

@end
