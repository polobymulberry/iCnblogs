//
//  ICBlogHomeCellPanelView.m
//  iCnblogs
//
//  Created by poloby on 16/1/7.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICBlogHomeCellPanelView.h"
#import "ICBlogHomeInfoView.h"
#import "ICBlogHomeContentView.h"
#import "ICBlog.h"

#import <Masonry/Masonry.h>

@interface ICBlogHomeCellPanelView ()

@property (nonatomic, strong) ICBlogHomeInfoView *blogHomeInfoView;
@property (nonatomic, strong) ICBlogHomeContentView *blogHomeContentView;

@end

@implementation ICBlogHomeCellPanelView

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        [self addSubview:self.blogHomeInfoView];
        [self addSubview:self.blogHomeContentView];
        
        [self layoutCellPanelSubViews];
    }
    
    return self;
}

- (void)layoutCellPanelSubViews
{
    [self.blogHomeInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(10);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-10);
        make.top.mas_equalTo(self.mas_top).offset(5);
        make.height.mas_equalTo(30);
    }];
    
    [self.blogHomeContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(10);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-10);
        make.top.mas_equalTo(self.blogHomeInfoView.mas_bottom).offset(10);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
    }];
}

#pragma mark- getters and setters
- (ICBlogHomeInfoView *)blogHomeInfoView
{
    if (_blogHomeInfoView == nil) {
        _blogHomeInfoView = [[ICBlogHomeInfoView alloc] init];
    }
    
    return _blogHomeInfoView;
}

- (ICBlogHomeContentView *)blogHomeContentView
{
    if (_blogHomeContentView == nil) {
        _blogHomeContentView = [[ICBlogHomeContentView alloc] init];
    }
    
    return _blogHomeContentView;
}

- (void)setBlogHomeCellPanelModel:(ICBlog *)blogHomeCellPanelModel
{
    _blogHomeCellPanelModel = blogHomeCellPanelModel;
    
    self.blogHomeInfoView.blogHomeInfoModel = _blogHomeCellPanelModel;
    self.blogHomeContentView.blogHomeContentModel = _blogHomeCellPanelModel;
}

@end
