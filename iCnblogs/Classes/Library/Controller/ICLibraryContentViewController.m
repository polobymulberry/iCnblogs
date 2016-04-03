//
//  ICLibraryContentViewController.m
//  iCnblogs
//
//  Created by poloby on 16/3/13.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICLibraryContentViewController.h"
#import "ICClientCredentialsOAuthTool.h"
#import "ICClientCredentialsOAuth.h"
#import "ICNetworkTool.h"

#import <AFNetworking/AFNetworking.h>
#import <Masonry/Masonry.h>

// 获取request url
static NSString *libraryContentNetworkRequestURL(NSInteger libraryId)
{
    return [NSString stringWithFormat:@"http://api.cnblogs.com/api/kbarticles/%ld/body", libraryId];
}

@interface ICLibraryContentViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ICLibraryContentViewController

- (void)viewDidLoad
{
    self.navigationItem.title = @"文库";
    
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

        NSString *requestURL = libraryContentNetworkRequestURL(self.libraryId);
        [ICNetworkTool loadContentWithURL:requestURL success:^(id responseObject) {
            
            CGFloat     titleFontSize   = 24.0f;
            NSString    *titleFontColor = @"#000000";
            CGFloat     timeFontSize    = 16.0f;
            NSString    *timeFontColor  = @"#5F5F5F";
            CGFloat     bodyFontSize    = 16.0f;
            NSString    *bodyFontColor  = @"#3F3F3F";
            NSString    *title          = self.libraryTitle;
            NSString    *time           = self.libraryTime;
            NSString    *body           = responseObject;
            
            NSString *HTMLString = ContentHTMLTemplateWithArgs(titleFontSize, titleFontColor, timeFontSize, timeFontColor, bodyFontSize, bodyFontColor, title, time, body);
            [_webView loadHTMLString:HTMLString baseURL:nil];
        } failure:^(NSError *error) {
            ICLog(@"library content error: %@", error);
        }];
    }
    
    return _webView;
}

@end
