//
//  ICBlogCardStatusView.m
//  iCnblogs
//
//  Created by poloby on 16/2/13.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICBlogCardStatusView.h"
#import "ICBlog.h"

#import <Masonry/Masonry.h>

@interface ICBlogCardStatusView ()

// diggs
@property (nonatomic, strong) UIImageView *diggsIcon;
@property (nonatomic, strong) UILabel *diggsLabel;
// views
@property (nonatomic, strong) UIImageView *viewsIcon;
@property (nonatomic, strong) UILabel *viewsLabel;
// comments
@property (nonatomic, strong) UIImageView *commentsIcon;
@property (nonatomic, strong) UILabel *commentsLabel;

@end

@implementation ICBlogCardStatusView

#pragma mark - init methods
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self addSubview:self.diggsIcon];
        [self addSubview:self.diggsLabel];
        [self addSubview:self.viewsIcon];
        [self addSubview:self.viewsLabel];
        [self addSubview:self.commentsIcon];
        [self addSubview:self.commentsLabel];
        
        [self layoutCardStatusSubViews];
    }
    
    return self;
}

- (void)layoutCardStatusSubViews
{
    // 依次排列为diggsIcon-diggsLabel-viewsIcon-viewsLabel-commentsIcon-commentsLabel
    [self.diggsIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18, 18));
        make.leading.mas_equalTo(self.mas_leading);
        make.top.mas_equalTo(self.mas_top);
    }];
    
    [self.diggsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.diggsIcon.mas_trailing).offset(5);
        make.bottom.mas_equalTo(self.diggsIcon.mas_bottom);
        make.width.mas_equalTo(self.diggsIcon.width);
    }];
    
    [self.viewsIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18, 18));
        make.leading.mas_equalTo(self.diggsIcon.mas_trailing).offset(ICDeviceWidth * 0.2);
        make.top.mas_equalTo(self.diggsIcon.mas_top);
    }];
    
    [self.viewsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.viewsIcon.mas_trailing).offset(5);
        make.bottom.mas_equalTo(self.viewsIcon.mas_bottom);
        make.width.mas_equalTo(self.viewsIcon.width);
    }];
    
    [self.commentsIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18, 18));
        make.leading.mas_equalTo(self.viewsIcon.mas_trailing).offset(ICDeviceWidth * 0.2);
        make.top.mas_equalTo(self.viewsIcon.mas_top);
    }];
    
    [self.commentsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.commentsIcon.mas_trailing).offset(5);
        make.bottom.mas_equalTo(self.commentsIcon.mas_bottom);
        make.width.mas_equalTo(self.commentsIcon.width);
    }];
}

#pragma mark - getters and setters
- (UIImageView *)diggsIcon
{
    if (_diggsIcon == nil) {
        _diggsIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_diggs"]];
    }
    
    return _diggsIcon;
}

- (UILabel *)diggsLabel
{
    if (_diggsLabel == nil) {
        _diggsLabel = [[UILabel alloc] init];
        _diggsLabel.font = [UIFont systemFontOfSize:11];
        _diggsLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    }
    
    return _diggsLabel;
}

- (UIImageView *)viewsIcon
{
    if (_viewsIcon == nil) {
        _viewsIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_views"]];
    }
    
    return _viewsIcon;
}

- (UILabel *)viewsLabel
{
    if (_viewsLabel == nil) {
        _viewsLabel = [[UILabel alloc] init];
        _viewsLabel.font = [UIFont systemFontOfSize:11];
        _viewsLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    }
    
    return _viewsLabel;
}

- (UIImageView *)commentsIcon
{
    if (_commentsIcon == nil) {
        _commentsIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_comments"]];
    }
    
    return _commentsIcon;
}

- (UILabel *)commentsLabel
{
    if (_commentsLabel == nil) {
        _commentsLabel = [[UILabel alloc] init];
        _commentsLabel.font = [UIFont systemFontOfSize:11];
        _commentsLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    }
    
    return _commentsLabel;
}

- (void)setBlogCardStatus:(ICBlog *)blogCardStatus
{
    _blogCardStatus = blogCardStatus;
    
    self.diggsLabel.text = blogCardStatus.diggCount;
    self.viewsLabel.text = blogCardStatus.viewCount;
    self.commentsLabel.text = blogCardStatus.commentCount;
}

@end
