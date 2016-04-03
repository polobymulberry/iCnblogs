//
//  ICBlogPickedCollectionViewLayout.h
//  iCnblogs
//
//  Created by poloby on 16/1/7.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WheetAlignmentType) {
    WheetAlignmentTypeLeft,
    WheetAlignmentTypeRight,
    WheetAlignmentTypeCenter
};

@interface ICBlogPickedCollectionViewLayout : UICollectionViewLayout

/**
 * @param radius 表示圆弧的半径
 * @param spacing 表示每个多少角度放一个cell
 * @param cellSize 每个cell的size
 * @param alignment 圆弧的摆放方式，有圆心靠左(WheetAlignmentTypeLeft)，圆心靠右(WheetAlignmentTypeRight)，垂直正中(未实现)
 * @param itemHeight itemHeight与cellSize.height的区别在于itemHeight还要加上两个cell的间距
 * @param xOffset 用来确定圆心的位置
 */
- (instancetype)initWithRadius:(CGFloat)radius
                angularSpacing:(CGFloat)spacing
                      cellSize:(CGSize)cellSize
                     anligment:(WheetAlignmentType)alignment
                    itemHeight:(CGFloat)itemHeight
                       xOffset:(CGFloat)xOffset;

@end
