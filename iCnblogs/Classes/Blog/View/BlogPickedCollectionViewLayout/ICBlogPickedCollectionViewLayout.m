//
//  ICBlogPickedCollectionViewLayout.m
//  iCnblogs
//
//  Created by poloby on 16/1/7.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICBlogPickedCollectionViewLayout.h"

@interface ICBlogPickedCollectionViewLayout ()

@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, assign) CGFloat radius; // 布局圆的半径
@property (nonatomic, assign) CGFloat angularSpacing; // 因为此处的布局是一个圆，所以angularSpacing表示的是每个cell所占的角度
@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, assign) WheetAlignmentType wheetAlignmentType;
@property (nonatomic, assign) CGFloat itemHeight; // itemHeight与cellSize.height的区别在于itemHeight还要加上两个cell的间距
@property (nonatomic, assign) CGFloat xOffset;
@property (nonatomic, assign) NSInteger cellCount;

@end

@implementation ICBlogPickedCollectionViewLayout

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _offset = 0.0;
    }
    
    return self;
}

- (instancetype)initWithRadius:(CGFloat)radius angularSpacing:(CGFloat)angularSpacing cellSize:(CGSize)cellSize anligment:(WheetAlignmentType)wheetAlignmentType itemHeight:(CGFloat)itemHeight xOffset:(CGFloat)xOffset
{
    self = [super init];
    
    if (self) {
        _offset = 0.0;
        
        _radius = radius;
        _angularSpacing = angularSpacing;
        _cellSize = cellSize;
        _wheetAlignmentType = wheetAlignmentType;
        _itemHeight = itemHeight;
        _xOffset = xOffset;
    }
    
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    self.cellCount = (NSInteger)[self.collectionView numberOfItemsInSection:0];
    self.offset = -self.collectionView.contentOffset.y / self.itemHeight;
}

// 返回collectionView的ContentSize，而非size
- (CGSize)collectionViewContentSize
{
    CGFloat width = self.collectionView.width;
    NSInteger maxVisiableOnScreeen = 180 / self.angularSpacing - 2;
    CGFloat height = (self.cellCount + 1 - maxVisiableOnScreeen / 2) * self.itemHeight + self.collectionView.height;
    //CGFloat height = self.cellCount * self.itemHeight;
    return CGSizeMake(width, height);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

// 在rect这个区域内有几个cell，每个cell的位置怎么样
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    
    CGFloat minY = CGRectGetMinY(rect);
    CGFloat maxY = CGRectGetMaxY(rect);
    // 获取到rect这个区域的cells的firstIndex和lastIndex，这两个没啥用，主要是为了获取activeIndex
    NSInteger firstIndex = floorf(minY / self.itemHeight);
    NSInteger lastIndex = floorf(maxY / self.itemHeight);
    NSInteger activeIndex = (firstIndex + lastIndex) / 2; // 中间那个cell设为active
    
    NSInteger maxVisiableOnScreeen = 180 / self.angularSpacing + 2;
    
    NSInteger firstItem = fmax(0, activeIndex - (NSInteger)maxVisiableOnScreeen/2);
    NSInteger lastItem = fmin(self.cellCount, activeIndex + (NSInteger)maxVisiableOnScreeen/2);
    if (lastItem == self.cellCount) {
        firstItem = fmax(0, self.cellCount - (NSInteger)maxVisiableOnScreeen);
    }
    
    for (NSInteger i = firstItem; i < lastItem; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes= [self layoutAttributesForItemAtIndexPath:indexPath];
        [layoutAttributes addObject:attributes];
    }
    
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat newIndex = (indexPath.item + self.offset);
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    attributes.size = self.cellSize;
    
    CGFloat scaleFactor, deltaX;
    CGAffineTransform translationT;
    CGAffineTransform rotationT;
    
    switch (self.wheetAlignmentType) {
        case WheetAlignmentTypeLeft:
            scaleFactor = fmax(0.6, 1 - fabs(newIndex * 0.25));
            deltaX = self.cellSize.width / 2;
            attributes.center = CGPointMake(-self.radius + self.xOffset, self.collectionView.height/2+self.collectionView.contentOffset.y);
            rotationT = CGAffineTransformMakeRotation(self.angularSpacing * newIndex * M_PI / 180);
            translationT = CGAffineTransformMakeTranslation(self.radius + deltaX * scaleFactor, 0);
            break;
        case WheetAlignmentTypeRight:
            scaleFactor = fmax(0.6, 1 - fabs(newIndex * 0.25));
            deltaX = self.cellSize.width / 2;
            attributes.center = CGPointMake(self.radius - self.xOffset  + ICDeviceWidth, self.collectionView.height/2+self.collectionView.contentOffset.y);
            rotationT = CGAffineTransformMakeRotation(-self.angularSpacing * newIndex * M_PI / 180);
            translationT = CGAffineTransformMakeTranslation(- self.radius - deltaX * scaleFactor, 0);
            break;
        case WheetAlignmentTypeCenter:
            // 待实现
            break;
        default:
            break;
    }
    
    CGAffineTransform scaleT = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
    attributes.alpha = scaleFactor;
    
    attributes.transform = CGAffineTransformConcat(scaleT, CGAffineTransformConcat(translationT, rotationT));
    attributes.zIndex = indexPath.item;
    
    return attributes;
}

@end
