//
//  ICBlogHomeContentView.h
//  iCnblogs
//
//  Created by poloby on 16/1/3.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICBlog;

@interface ICBlogHomeContentView : UIView

@property (nonatomic, strong) ICBlog *blogHomeContentModel;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *summaryLabel;

@end
