//
//  ICNewsTableViewCell.m
//  iCnblogs
//
//  Created by poloby on 16/1/10.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICNewsTableViewCell.h"
#import "ICNews.h"

#import <Masonry/Masonry.h>

@interface ICNewsTableViewCell ()

@property (nonatomic, strong) UIView *panelView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *timeIcon;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation ICNewsTableViewCell

#pragma mark - init methods
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self.contentView addSubview:self.panelView];
        
        [self layoutCellSubViews];
    }
    
    return self;
}

- (void)layoutCellSubViews
{
    [self.panelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading);
        make.trailing.mas_equalTo(self.contentView.mas_trailing);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.panelView.mas_leading).offset(self.contentView.width * 0.3);
        make.trailing.mas_equalTo(self.panelView.mas_trailing).offset(-self.contentView.width * 0.3);
        make.top.mas_equalTo(self.panelView.mas_top);
        make.bottom.mas_equalTo(self.panelView.mas_bottom);
    }];
    
    [self.timeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.timeLabel.mas_leading).offset(-10);
        make.bottom.mas_equalTo(self.timeLabel.mas_bottom);
        if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5) {
            make.size.mas_equalTo(CGSizeMake(14, 14));
        } else if (IS_IPHONE_6 || IS_IPHONE_6S) {
            make.size.mas_equalTo(CGSizeMake(16, 16));
        } else {
            make.size.mas_equalTo(CGSizeMake(18, 18));
        }
    }];
    
    [self.timeLabel sizeToFit];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.panelView.mas_trailing).offset(-20);
        make.bottom.mas_equalTo(self.panelView.mas_bottom).offset(-14);
    }];
}

#pragma mark - override methods
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) {
        self.panelView.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor blackColor];
        self.timeIcon.image = [UIImage imageNamed:@"icon_time_selected"];
        self.timeLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
    } else {
        self.panelView.backgroundColor = ICInkColor;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.timeIcon.image = [UIImage imageNamed:@"icon_time"];
        self.timeLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    }
}

#pragma mark - getters and setters
- (UIView *)panelView
{
    if (_panelView == nil) {
        _panelView = [[UIView alloc] init];
        _panelView.backgroundColor = ICInkColor;
        [_panelView addSubview:self.titleLabel];
        [_panelView addSubview:self.timeIcon];
        [_panelView addSubview:self.timeLabel];
    }
    
    return _panelView;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 3;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfiPhone4OrLessSize:15.0 iPhone5Size:15.0 iPhone6Or6SSize:18.0 iPhone6PlusOr6SPlusSize:20.0];
    }
    
    return _titleLabel;
}

- (UIImageView *)timeIcon
{
    if (_timeIcon == nil) {
        _timeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_time"]];
    }
    return _timeIcon;
}

- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont boldSystemFontOfiPhone4OrLessSize:12.0 iPhone5Size:12.0 iPhone6Or6SSize:13.0 iPhone6PlusOr6SPlusSize:14.0];
        _timeLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    }
    
    return _timeLabel;
}

- (void)setNews:(ICNews *)news
{
    _news = news;
    
    _titleLabel.text = news.title;
    _timeLabel.text = news.dateAdded;
}

@end
