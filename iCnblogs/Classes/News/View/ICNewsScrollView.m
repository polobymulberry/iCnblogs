//
//  ICNewsScrollView.m
//  iCnblogs
//
//  Created by poloby on 16/1/9.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICNewsScrollView.h"
#import "ICNewsNewestTableView.h"
#import "ICNewsRecommendTableView.h"
#import "ICNewsHotTableView.h"

#import <Masonry/Masonry.h>

#define SEGMENT_COUNT 3

@interface ICNewsScrollView ()

@property (nonatomic, strong) ICNewsNewestTableView *newestTableView;
@property (nonatomic, strong) ICNewsRecommendTableView *recommendTableView;
@property (nonatomic, strong) ICNewsHotTableView *hotTableView;

@end

@implementation ICNewsScrollView

#pragma mark - init methods
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.contentSize = CGSizeMake(frame.size.width * SEGMENT_COUNT, frame.size.height);
        
        [self addSubview:self.newestTableView];
        [self addSubview:self.recommendTableView];
        [self addSubview:self.hotTableView];
        
        [self layoutScrollSubViews];
    }
    
    
    return self;
}

- (void)layoutScrollSubViews
{
    [self.newestTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.size);
        make.leading.mas_equalTo(self.mas_leading);
        make.top.mas_equalTo(self.mas_top);
    }];
    
    [self.recommendTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.size);
        make.leading.mas_equalTo(self.newestTableView.mas_trailing);
        make.top.mas_equalTo(self.mas_top);
    }];
    
    [self.hotTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.size);
        make.leading.mas_equalTo(self.recommendTableView.mas_trailing);
        make.top.mas_equalTo(self.mas_top);
    }];
}

#pragma mark - getters and setters
- (ICNewsNewestTableView *)newestTableView
{
    if (_newestTableView == nil) {
        _newestTableView = [[ICNewsNewestTableView alloc] init];
    }
    
    return _newestTableView;
}

- (ICNewsRecommendTableView *)recommendTableView
{
    if (_recommendTableView == nil) {
        _recommendTableView = [[ICNewsRecommendTableView alloc] init];
    }
    
    return _recommendTableView;
}

- (ICNewsHotTableView *)hotTableView
{
    if (_hotTableView == nil) {
        _hotTableView = [[ICNewsHotTableView alloc] init];
    }
    
    return _hotTableView;
}

@end
