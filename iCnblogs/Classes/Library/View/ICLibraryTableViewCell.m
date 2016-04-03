//
//  ICLibraryTableViewCell.m
//  iCnblogs
//
//  Created by poloby on 16/3/12.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICLibraryTableViewCell.h"
#import "ICLibrary.h"

#import <Masonry/Masonry.h>

@interface ICLibraryTableViewCell ()

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIImageView *iconDigg;
@property (nonatomic, strong) UILabel *viewCountLabel;
@property (nonatomic, strong) UILabel *diggCountLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation ICLibraryTableViewCell

#pragma mark - init methods
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self.contentView addSubview:self.titleView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.iconDigg];
        [self.contentView addSubview:self.viewCountLabel];
        [self.contentView addSubview:self.diggCountLabel];
        [self.contentView addSubview:self.timeLabel];
        
        [self layoutCellSubViews];
    }
    
    return self;
}

- (void)layoutCellSubViews
{
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ICDeviceWidth * 0.8, ICDeviceWidth * 0.35));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(ICDeviceWidth * 0.05);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ICDeviceWidth*0.5);
        make.center.equalTo(self.titleView);
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.titleView.mas_leading);
        make.top.mas_equalTo(self.titleView.mas_bottom).offset(10);
        make.size.mas_equalTo(ICDeviceWidth * 0.05);
    }];
    
    [self.viewCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconView.mas_trailing).offset(5);
        make.bottom.mas_equalTo(self.iconView.mas_bottom);
    }];
    
    [self.iconDigg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconView.mas_trailing).offset(ICDeviceWidth * 0.1);
        make.top.mas_equalTo(self.iconView.mas_top);
        make.size.mas_equalTo(ICDeviceWidth * 0.05);
    }];
    
    [self.diggCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconDigg.mas_trailing).offset(5);
        make.bottom.mas_equalTo(self.iconDigg.mas_bottom);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.titleView.mas_trailing);
        make.bottom.mas_equalTo(self.diggCountLabel.mas_bottom);
    }];
}

#pragma mark - override methods
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) {
        self.titleView.backgroundColor = [UIColor blackColor];
    } else {
        self.titleView.backgroundColor = ICInkColor;
    }
}

#pragma mark - getters and setters
- (void)setLibrary:(ICLibrary *)library
{
    _library = library;
    
    self.titleLabel.text = _library.title;
    self.viewCountLabel.text = _library.viewCount;
    self.diggCountLabel.text = _library.diggCount;
    self.timeLabel.text = _library.dateAdded;
}

- (UIView *)titleView
{
    if (_titleView == nil) {
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = ICInkColor;
        _titleView.layer.cornerRadius = ICDeviceWidth * 0.02;
    }
    
    return _titleView;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfiPhone4OrLessSize:16.0 iPhone5Size:16.0 iPhone6Or6SSize:18.0 iPhone6PlusOr6SPlusSize:20.0];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 3;
    }
    
    return _titleLabel;
}

- (UIImageView *)iconView
{
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_views"]];
    }
    
    return _iconView;
}

- (UIImageView *)iconDigg
{
    if (_iconDigg == nil) {
        _iconDigg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_diggs"]];
    }
    
    return _iconDigg;
}

- (UILabel *)viewCountLabel
{
    if (_viewCountLabel == nil) {
        _viewCountLabel = [[UILabel alloc] init];
        
        _viewCountLabel.font = [UIFont boldSystemFontOfiPhone4OrLessSize:12.0 iPhone5Size:12.0 iPhone6Or6SSize:14.0 iPhone6PlusOr6SPlusSize:16.0];
        _viewCountLabel.textColor = [UIColor lightGrayColor];
    }
    
    return _viewCountLabel;
}

- (UILabel *)diggCountLabel
{
    if (_diggCountLabel == nil) {
        _diggCountLabel = [[UILabel alloc] init];
        _diggCountLabel.font = [UIFont boldSystemFontOfiPhone4OrLessSize:12.0 iPhone5Size:12.0 iPhone6Or6SSize:14.0 iPhone6PlusOr6SPlusSize:16.0];
        _diggCountLabel.textColor = [UIColor lightGrayColor];
    }
    
    return _diggCountLabel;
}

- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont boldSystemFontOfiPhone4OrLessSize:12.0 iPhone5Size:12.0 iPhone6Or6SSize:14.0 iPhone6PlusOr6SPlusSize:16.0];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.numberOfLines = 1;
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    
    return _timeLabel;
}

@end
