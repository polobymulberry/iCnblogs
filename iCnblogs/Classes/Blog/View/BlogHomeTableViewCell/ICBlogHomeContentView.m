//
//  ICBlogHomeContentView.m
//  iCnblogs
//
//  Created by poloby on 16/1/3.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICBlogHomeContentView.h"
#import "ICBlog.h"

#import <Masonry/Masonry.h>

@interface ICBlogHomeContentView ()

@end

@implementation ICBlogHomeContentView

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.summaryLabel];
        
        [self layoutContentSubViews];
    }
    
    return self;
}

- (void)layoutContentSubViews
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-20); // 不能正顶格，标题的话，最好限制
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.summaryLabel.mas_top).offset(-10);
    }];
    
    [self.summaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading);
        make.trailing.mas_equalTo(self.mas_trailing);
        make.top.mas_equalTo(self.summaryLabel.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}

#pragma mark - getters and setters
- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.numberOfLines = 1;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    
    return _titleLabel;
}

- (UILabel *)summaryLabel
{
    if (_summaryLabel == nil) {
        _summaryLabel = [[UILabel alloc] init];
        _summaryLabel.font = [UIFont systemFontOfSize:14];
        _summaryLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        _summaryLabel.numberOfLines = 3;
        _summaryLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    
    return _summaryLabel;
}

- (void)setBlogHomeContentModel:(ICBlog *)blogHomeContentModel
{
    _blogHomeContentModel = blogHomeContentModel;
    
    self.titleLabel.text = _blogHomeContentModel.title;
    self.summaryLabel.text = _blogHomeContentModel.blogDescription;
}

@end
