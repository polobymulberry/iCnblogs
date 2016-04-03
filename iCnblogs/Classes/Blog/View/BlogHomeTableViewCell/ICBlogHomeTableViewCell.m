//
//  ICBlogHomeTableViewCell.m
//  iCnblogs
//
//  Created by poloby on 16/1/3.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICBlogHomeTableViewCell.h"
#import "ICBlog.h"
#import "ICBlogHomeCellPanelView.h"

#import <Masonry/Masonry.h>

@interface ICBlogHomeTableViewCell ()

@property (nonatomic, strong) ICBlogHomeCellPanelView *blogHomeCellPanelView;

@end

@implementation ICBlogHomeTableViewCell

#pragma mark - life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = ICSilverColor;
        
        [self.contentView addSubview:self.blogHomeCellPanelView];
        
        [self layoutCellSubViews];
    }
    return self;
}

- (void)layoutCellSubViews
{    
    [self.blogHomeCellPanelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(10);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-10);
        make.top.mas_equalTo(self.contentView.mas_top).offset(5);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-5);
    }];
}

#pragma mark - override
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) {
        self.blogHomeCellPanelView.backgroundColor = ICSilverColor;
    } else {
        self.blogHomeCellPanelView.backgroundColor = [UIColor whiteColor];
    }
}

#pragma mark - getters and setters
- (ICBlogHomeCellPanelView *)blogHomeCellPanelView
{
    if (_blogHomeCellPanelView == nil) {
        _blogHomeCellPanelView = [[ICBlogHomeCellPanelView alloc] init];
        _blogHomeCellPanelView.backgroundColor = [UIColor whiteColor];
    }
    
    return _blogHomeCellPanelView;
}

- (void)setHomeBlog:(ICBlog *)homeBlog
{
    _homeBlog = homeBlog;
    
    self.blogHomeCellPanelView.blogHomeCellPanelModel = _homeBlog;
}

@end
