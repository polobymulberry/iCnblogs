//
//  ICUserTableHeaderView.m
//  iCnblogs
//
//  Created by poloby on 16/3/3.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICUserTableHeaderView.h"

#import <Masonry/Masonry.h>

@implementation ICUserTableHeaderView

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self addSubview:self.headImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.seniorityLabel];
        
        [self layoutSubHeaderViews];
    }
    
    return self;
}

- (void)layoutSubHeaderViews
{
    self.headImageView.frame = CGRectMake(ICDeviceWidth * 0.4, ICDeviceWidth * 0.1, ICDeviceWidth * 0.2, ICDeviceWidth * 0.2);
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headImageView.mas_centerX);
        make.top.mas_equalTo(self.headImageView.mas_bottom).offset(ICDeviceWidth * 0.03);
    }];
    [self.seniorityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.nameLabel.mas_centerX);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(ICDeviceWidth * 0.02);
    }];
}

#pragma mark - getters and setters
- (UIImageView *)headImageView
{
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_avatar"]];
        _headImageView.backgroundColor = [UIColor colorWithWhite:28.0/255.0 alpha:1.0];
        _headImageView.layer.cornerRadius = ICDeviceWidth * 0.1;
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
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfiPhone4OrLessSize:10.0 iPhone5Size:12.0 iPhone6Or6SSize:14.0 iPhone6PlusOr6SPlusSize:16.0];
    }
    
    return _nameLabel;
}

- (UILabel *)seniorityLabel
{
    if (_seniorityLabel == nil) {
        _seniorityLabel = [[UILabel alloc] init];
        _seniorityLabel.textColor = [UIColor colorWithWhite:0.7 alpha:1.0];
        _seniorityLabel.font = [UIFont systemFontOfiPhone4OrLessSize:8.0 iPhone5Size:10.0 iPhone6Or6SSize:12.0 iPhone6PlusOr6SPlusSize:14.0];
    }
    
    return _seniorityLabel;
}

@end
