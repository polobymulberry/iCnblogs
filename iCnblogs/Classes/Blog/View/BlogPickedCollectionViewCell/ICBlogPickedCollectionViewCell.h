//
//  ICBlogPickedCollectionViewCell.h
//  iCnblogs
//
//  Created by poloby on 16/1/7.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICBlog;

@interface ICBlogPickedCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) ICBlog *pickedBlog;

@end
