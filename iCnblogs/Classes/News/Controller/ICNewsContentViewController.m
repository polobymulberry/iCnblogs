//
//  ICNewsContentViewController.m
//  iCnblogs
//
//  Created by poloby on 16/2/9.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICNewsContentViewController.h"
#import "ICNews.h"
#import "ICClientCredentialsOAuthTool.h"
#import "ICClientCredentialsOAuth.h"
#import "ICNetworkTool.h"

#import <AFNetworking/AFNetworking.h>
#import <Masonry/Masonry.h>

// 获取request url
static NSString *newsContentNetworkRequestURL(NSInteger newsId)
{
    return [NSString stringWithFormat:@"http://api.cnblogs.com/api/newsitems/%ld/body", newsId];
}

@interface ICNewsContentViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ICNewsContentViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    NSString *title = @"新闻";
    switch (self.pushedViewControllerId) {
        case 0:
            title = @"最新";
            break;
        case 1:
            title = @"推荐";
            break;
        case 2:
            title = @"热门";
            break;
        default:
            break;
    }
    self.navigationItem.title = title;
    
    [self.view addSubview:self.webView];
    
    [self layoutSubPageViews];
}

- (void)layoutSubPageViews
{
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark - getters and setters
- (UIWebView *)webView
{
    if (_webView == nil) {
        
        _webView = [[UIWebView alloc] init];
        
        NSString *requestURL = newsContentNetworkRequestURL(self.newsId);
        
        [ICNetworkTool loadContentWithURL:requestURL success:^(id responseObject) {
            
            CGFloat     titleFontSize   = 24.0f;
            NSString    *titleFontColor = @"#000000";
            CGFloat     timeFontSize    = 16.0f;
            NSString    *timeFontColor  = @"#5F5F5F";
            CGFloat     bodyFontSize    = 16.0f;
            NSString    *bodyFontColor  = @"#3F3F3F";
            NSString    *title          = self.newsTitle;
            NSString    *time           = self.newsTime;
            NSString    *body           = responseObject;
            
            NSString *HTMLString = ContentHTMLTemplateWithArgs(titleFontSize, titleFontColor, timeFontSize, timeFontColor, bodyFontSize, bodyFontColor, title, time, body);
            [_webView loadHTMLString:HTMLString baseURL:nil];
        } failure:^(NSError *error) {
            ICLog(@"news content error: %@", error);
        }];
    }
    
    return _webView;
}

@end
