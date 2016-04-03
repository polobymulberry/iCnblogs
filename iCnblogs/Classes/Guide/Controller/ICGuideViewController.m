//
//  ICGuideViewController.m
//  iCnblogs
//
//  Created by poloby on 15/12/29.
//  Copyright © 2015年 poloby. All rights reserved.
//

#import "ICGuideViewController.h"
#import "ICRippleButton.h"
#import "ICLeftSideMenu.h"

#define ICNewfeatureImageCount 3

@interface ICGuideViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ICRippleButton *rippleButton;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation ICGuideViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int pageIndex = (int)(scrollView.contentOffset.x / ICDeviceWidth + 0.5);
    
    self.pageControl.currentPage = pageIndex;
    
    // 只有当前page为lastPage时，才会显示rippleButton，另外还需要lastPage的80%都显示了，才显示
    BOOL isCurrentLastPage = scrollView.contentOffset.x == ICDeviceWidth * (ICNewfeatureImageCount - 1) ? YES : NO;
    if (isCurrentLastPage) {
        [self.rippleButton startRippleEffect];
    } else {
        [self.rippleButton stopRippleEffect];
    }
}

#pragma mark - event response
- (void)rippleButtonDidTapped
{
    [self.rippleButton killRippleEffect];
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(enterTabbarController) userInfo:nil repeats:NO];
}

- (void)enterTabbarController
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[ICLeftSideMenu alloc] init];
}

#pragma mark - private methods
- (void)setupLastImageView:(UIImageView *)lastImageView
{
    lastImageView.userInteractionEnabled = YES;
    
    [lastImageView addSubview:self.rippleButton];
}

#pragma mark - getters and setters
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        
        for (int i = 0; i < ICNewfeatureImageCount; i++) {
            NSString *imageName = [NSString stringWithFormat:@"image_guildview%d", i+1];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
            imageView.frame = self.view.frame;
            imageView.x = i * ICDeviceWidth;
            [_scrollView addSubview:imageView];
            
            if (i == ICNewfeatureImageCount - 1) {
                [self setupLastImageView:imageView];
            }
        }
        
        _scrollView.contentSize = CGSizeMake(ICNewfeatureImageCount * ICDeviceWidth, ICDeviceHeight);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = ICNewfeatureImageCount;
        _pageControl.centerX = ICDeviceWidth * 0.5;
        _pageControl.centerY = ICDeviceHeight * 0.95;
    }
    
    return _pageControl;
}

- (ICRippleButton *)rippleButton
{
    if (_rippleButton == nil) {
        
        int offset = 0;
        if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5) {
            offset = 24;
        } else if (IS_IPHONE_6 || IS_IPHONE_6S) {
            offset = 28;
        } else {
            offset = 32;
        }
        
        _rippleButton = [[ICRippleButton alloc] initWithImage:[UIImage imageNamed:@"guildview3_button"]
                                                            frame:CGRectMake(ICDeviceWidth * 0.5 - offset, ICDeviceHeight * 0.8 - offset, offset * 2, offset * 2)
                                                           target:@selector(rippleButtonDidTapped)
                                                           sender:self];
        _rippleButton.rippleColor = [UIColor colorWithRed:129/255.f green:199/255.f blue:212/255.f alpha:1];
    }
    
    return _rippleButton;
}

@end
