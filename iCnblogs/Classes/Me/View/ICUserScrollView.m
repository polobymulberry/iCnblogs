//
//  ICUserScrollView.m
//  iCnblogs
//
//  Created by poloby on 16/3/5.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICUserScrollView.h"
#import "ICUserBlogTableView.h"
#import "ICUserCollectionTableView.h"

#import <Masonry/Masonry.h>

#define USER_SEGMENT_COUNT 3

@interface ICUserScrollView ()

@end

@implementation ICUserScrollView

#pragma mark - init methods
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.contentSize = CGSizeMake(frame.size.width * USER_SEGMENT_COUNT, frame.size.height);
        
        [self addSubview:self.blogTableView];
        [self addSubview:self.collectionTableView];
        
        [self layoutScrollSubViews];
    }
    
    return self;
}

- (void)layoutScrollSubViews
{
    self.blogTableView.frame = CGRectMake(0, 0, self.width, self.height);
    self.collectionTableView.frame = CGRectMake(self.width, 0, self.width, self.height);
}

- (void)updateSubViews:(CGFloat)height
{
    self.blogTableView.height = height;
    self.collectionTableView.height = height;
}

- (ICUserBlogTableView *)blogTableView
{
    if (_blogTableView == nil) {
        _blogTableView = [[ICUserBlogTableView alloc] init];
    }
    
    return _blogTableView;
}

- (ICUserCollectionTableView *)collectionTableView
{
    if (_collectionTableView == nil) {
        _collectionTableView = [[ICUserCollectionTableView alloc] init];
    }
    
    return _collectionTableView;
}

@end
