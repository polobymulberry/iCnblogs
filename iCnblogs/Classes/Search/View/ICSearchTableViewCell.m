//
//  ICSearchTableViewCell.m
//  iCnblogs
//
//  Created by poloby on 16/4/9.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICSearchTableViewCell.h"
#import "ICSearchModel.h"

#import <Masonry/Masonry.h>

@interface ICSearchTableViewCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
// time
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation ICSearchTableViewCell

#pragma mark - init methods
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.timeLabel];
        
        [self layoutSubCellViews];
    }
    
    return self;
}

- (void)layoutSubCellViews
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(20);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-20); // 不能正顶格，标题的话，最好限制
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.bottom.mas_equalTo(self.contentLabel.mas_top).offset(-10);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.titleLabel.mas_leading);
        make.trailing.mas_equalTo(self.titleLabel.mas_trailing);
        make.top.mas_equalTo(self.contentLabel.mas_top);
        make.bottom.mas_equalTo(self.timeLabel.mas_top).offset(-10);
    }];
    
    // time
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentLabel.mas_leading);
        make.trailing.mas_equalTo(self.contentLabel.mas_trailing);
        make.top.mas_equalTo(self.timeLabel.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
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

- (UILabel *)contentLabel
{
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        _contentLabel.numberOfLines = 3;
        _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    
    return _contentLabel;
}

- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:13.0];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.numberOfLines = 1;
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    
    return _timeLabel;
}

- (void)setSearchModel:(ICSearchModel *)searchModel
{
    _searchModel = searchModel;
    
//    // 使用Timer Profiler分析，此处解析html竟然很耗时，所以此处我已不处理html解析部分
//    // 不过异步会有些问题，界面刷新滞后，所以弃之
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSString *titleString = searchModel.title;
//        titleString = SearchContentHTMLTemplateWithArgs(16.0, @"#000000", 16.0, @"#FF0000", titleString);
//        NSMutableAttributedString *titleAttributedString = [[NSMutableAttributedString alloc] initWithData:[titleString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error:nil];
//        
//        NSString *contentString = searchModel.content;
//        contentString = SearchContentHTMLTemplateWithArgs(14.0, @"3F3F3F", 14.0, @"FF0000", contentString);
//        NSMutableAttributedString *contentAttributedString = [[NSMutableAttributedString alloc] initWithData:[contentString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error:nil];
//        [contentAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, contentAttributedString.length)];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.titleLabel.attributedText = titleAttributedString;
//            self.contentLabel.attributedText = contentAttributedString;
//            self.timeLabel.text = searchModel.publishTime;
//        });
//    });
    
    NSString *titleString = searchModel.title;
    titleString = SearchContentHTMLTemplateWithArgs(16.0, @"#000000", 16.0, @"#FF0000", titleString);
    NSMutableAttributedString *titleAttributedString = [[NSMutableAttributedString alloc] initWithData:[titleString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error:nil];

    NSString *contentString = searchModel.content;
    contentString = SearchContentHTMLTemplateWithArgs(14.0, @"3F3F3F", 14.0, @"FF0000", contentString);
    NSMutableAttributedString *contentAttributedString = [[NSMutableAttributedString alloc] initWithData:[contentString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    [contentAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, contentAttributedString.length)];
    self.titleLabel.attributedText = titleAttributedString;
    self.contentLabel.attributedText = contentAttributedString;
    self.timeLabel.text = searchModel.publishTime;
}

@end
