//
//  ICLeftMenuHeaderView.m
//  iCnblogs
//
//  Created by poloby on 16/3/10.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICLeftMenuHeaderView.h"

#import <Masonry/Masonry.h>

@implementation ICLeftMenuHeaderView

#pragma mark - init methods
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self addSubview:self.headImageView];
        [self addSubview:self.nameLabel];
        
        [self layoutSubHeaderViews];
    }
    
    return self;
}

- (void)layoutSubHeaderViews
{
    self.headImageView.frame = CGRectMake(ICDeviceWidth * 0.13, ICDeviceWidth * 0.1, ICDeviceWidth * 0.14, ICDeviceWidth * 0.14);
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headImageView.mas_centerX);
        make.top.mas_equalTo(self.headImageView.mas_bottom).offset(ICDeviceWidth * 0.03);
    }];
}

#pragma mark - getters and setters
- (UIImageView *)headImageView
{
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_avatar"]];
        _headImageView.backgroundColor = [UIColor colorWithWhite:28.0/255.0 alpha:1.0];
        _headImageView.layer.cornerRadius = ICDeviceWidth * 0.07;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.borderWidth = 3.0f;
        _headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    
    return _headImageView;
}

- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"点击登录";
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfiPhone4OrLessSize:10.0 iPhone5Size:12.0 iPhone6Or6SSize:14.0 iPhone6PlusOr6SPlusSize:16.0];
    }
    
    return _nameLabel;
}

@end
