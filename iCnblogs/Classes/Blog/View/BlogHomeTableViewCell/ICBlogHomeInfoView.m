//
//  ICBlogHomeInfoView.m
//  iCnblogs
//
//  Created by poloby on 16/1/3.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICBlogHomeInfoView.h"
#import "ICBlog.h"

#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface ICBlogHomeInfoView ()

// avatar
@property (nonatomic, strong) UIImageView *avatarImageView;
// name
@property (nonatomic, strong) UILabel *nameLabel;
// time
@property (nonatomic, strong) UILabel *timeLabel;

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

@implementation ICBlogHomeInfoView

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self addSubview:self.avatarImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.timeLabel];
        
        // diggs
        [self addSubview:self.diggsIcon];
        [self addSubview:self.diggsLabel];
        // views
        [self addSubview:self.viewsIcon];
        [self addSubview:self.viewsLabel];
        // comments
        [self addSubview:self.commentsIcon];
        [self addSubview:self.commentsLabel];
        
        [self layoutInfoSubViews];
    }
    
    return self;
}

- (void)layoutInfoSubViews
{
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.leading.mas_equalTo(self.mas_leading);
        make.top.mas_equalTo(self.mas_top);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.avatarImageView.mas_trailing).offset(10);
        make.trailing.mas_equalTo(self.diggsIcon.mas_leading);
        make.top.mas_equalTo(self.avatarImageView.mas_top);
        make.bottom.mas_equalTo(self.timeLabel.mas_top);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.avatarImageView.mas_trailing).offset(10);
        make.trailing.mas_equalTo(self.mas_trailing);
        make.top.mas_equalTo(self.nameLabel.mas_bottom);
        make.bottom.mas_equalTo(self.avatarImageView.mas_bottom);
    }];
    
    // 依次排列为diggsIcon-diggsLabel-viewsIcon-viewsLabel-commentsIcon-commentsLabel
    [self.diggsIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18, 18));
        make.trailing.mas_equalTo(self.viewsIcon.mas_leading).offset(-30);
        make.top.mas_equalTo(self.avatarImageView.mas_top);
    }];
    
    [self.diggsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.diggsIcon.mas_trailing).offset(5);
        make.bottom.mas_equalTo(self.diggsIcon.mas_bottom);
        make.width.mas_equalTo(self.diggsIcon.width);
    }];
    
    [self.viewsIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18, 18));
        make.trailing.mas_equalTo(self.commentsIcon.mas_leading).offset(-30);
        make.top.mas_equalTo(self.diggsIcon.mas_top);
    }];
    
    [self.viewsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.viewsIcon.mas_trailing).offset(5);
        make.bottom.mas_equalTo(self.viewsIcon.mas_bottom);
        make.width.mas_equalTo(self.viewsIcon.width);
    }];
    
    [self.commentsIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18, 18));
        make.trailing.mas_equalTo(self.mas_trailing).offset(-30);
        make.top.mas_equalTo(self.viewsIcon.mas_top);
    }];
    
    [self.commentsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.commentsIcon.mas_trailing).offset(5);
        make.bottom.mas_equalTo(self.commentsIcon.mas_bottom);
        make.width.mas_equalTo(self.commentsIcon.width);
    }];

}

#pragma mark - getters and setters
- (UIImageView *)avatarImageView
{
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.cornerRadius = 4.0;
    }
    
    return _avatarImageView;
}

- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:12];
    }
    
    return _nameLabel;
}

- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    }
    
    return _timeLabel;
}

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


- (void)setBlogHomeInfoModel:(ICBlog *)blogHomeInfoModel
{
    _blogHomeInfoModel = blogHomeInfoModel;
    
    [self.avatarImageView sd_setImageWithURL:_blogHomeInfoModel.avatarUrl placeholderImage:[UIImage imageNamed:@"icon_avatar"]];
    self.nameLabel.text = _blogHomeInfoModel.author;
    self.timeLabel.text = _blogHomeInfoModel.postDate;
    
    self.diggsLabel.text = _blogHomeInfoModel.diggCount;
    self.viewsLabel.text = _blogHomeInfoModel.viewCount;
    self.commentsLabel.text = _blogHomeInfoModel.commentCount;
}

@end
