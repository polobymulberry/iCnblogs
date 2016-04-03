//
//  ICBlogPickedCollectionViewCell.m
//  iCnblogs
//
//  Created by poloby on 16/1/7.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICBlogPickedCollectionViewCell.h"
#import "ICBlog.h"
#import "ICBlogCardPanelView.h"

#import <Masonry/Masonry.h>

@interface ICBlogPickedCollectionViewCell ()

@property (nonatomic, strong) ICBlogCardPanelView *blogCardView;

@end

@implementation ICBlogPickedCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupCollectionCell];
        
        [self addSubview:self.blogCardView];
        
        [self layoutCellSubViews];
    }
    
    return self;
}

- (void)setupCollectionCell
{
    self.backgroundColor = [UIColor clearColor];
    self.layer.allowsEdgeAntialiasing = YES;
    self.layer.cornerRadius = 4.0;
    self.layer.masksToBounds = YES;
}

- (void)layoutCellSubViews
{
    [self.blogCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(10);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-10);
        make.top.mas_equalTo(self.contentView.mas_top).offset(5);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-5);
    }];
}

#pragma mark - getters and setters
- (ICBlogCardPanelView *)blogCardView
{
    if (_blogCardView == nil) {
        _blogCardView = [[ICBlogCardPanelView alloc] init];
        _blogCardView.backgroundColor = [UIColor clearColor];
        _blogCardView.layer.allowsEdgeAntialiasing = YES;
    }
    
    return _blogCardView;
}

- (void)setPickedBlog:(ICBlog *)pickedBlog
{
    _pickedBlog = pickedBlog;
    
    self.blogCardView.panelModel = _pickedBlog;
}


@end
