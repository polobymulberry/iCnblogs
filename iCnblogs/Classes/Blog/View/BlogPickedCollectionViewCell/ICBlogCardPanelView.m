//
//  ICBlogCardPanelView.m
//  iCnblogs
//
//  Created by poloby on 16/2/13.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICBlogCardPanelView.h"
#import "ICBlog.h"
#import "ICBlogCardStatusView.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/Masonry.h>

@interface ICBlogCardPanelView ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) ICBlogCardStatusView *blogCardStatusView;

@end

@implementation ICBlogCardPanelView

#pragma mark - init methods
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self addSubview:self.avatarImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.timeLabel];
        [self addSubview:self.titleLabel];
        [self addSubview:self.blogCardStatusView];
        
        [self layoutCellSubViews];
    }
    
    return self;
}

- (void)layoutCellSubViews
{
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.leading.mas_equalTo(self.mas_leading);
        make.top.mas_equalTo(self.mas_top);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.avatarImageView.mas_trailing).offset(10);
        make.trailing.mas_equalTo(self.mas_trailing);
        make.top.mas_equalTo(self.avatarImageView.mas_top);
        make.bottom.mas_equalTo(self.timeLabel.mas_top);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.avatarImageView.mas_trailing).offset(10);
        make.trailing.mas_equalTo(self.mas_trailing);
        make.top.mas_equalTo(self.nameLabel.mas_bottom);
        make.bottom.mas_equalTo(self.avatarImageView.mas_bottom);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.avatarImageView.mas_leading);
        make.trailing.mas_equalTo(self.mas_trailing);
        make.top.mas_equalTo(self.avatarImageView.mas_bottom).offset(5);
    }];
    
    [self.blogCardStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading);
        make.size.mas_equalTo(CGSizeMake(ICDeviceWidth * 0.5 + 18 * 3, 18));
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5);
    }];
}

#pragma mark - getters and setters
- (UIImageView *)avatarImageView
{
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.cornerRadius = 30 / 2;
    }
    
    return _avatarImageView;
}

- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        _nameLabel.font = [UIFont systemFontOfSize:12];
    }
    
    return _nameLabel;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    }
    
    return _titleLabel;
}

- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    }
    
    return _timeLabel;
}

- (ICBlogCardStatusView *)blogCardStatusView
{
    if (_blogCardStatusView == nil) {
        _blogCardStatusView = [[ICBlogCardStatusView alloc] init];
        _blogCardStatusView.backgroundColor = [UIColor clearColor];
    }
    
    return _blogCardStatusView;
}

- (void)setPanelModel:(ICBlog *)panelModel
{
    _panelModel = panelModel;
    
    [self.avatarImageView sd_setImageWithURL:_panelModel.avatarUrl placeholderImage:[UIImage imageNamed:@"icon_avatar"]];
    self.nameLabel.text = _panelModel.author;
    self.timeLabel.text = _panelModel.postDate;
    self.titleLabel.text = _panelModel.title;
    self.blogCardStatusView.blogCardStatus = panelModel;
}

@end
