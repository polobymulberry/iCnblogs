//
//  ICCollectionViewDataSource.m
//  iCnblogs
//
//  Created by poloby on 16/1/7.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICCollectionViewDataSource.h"

@interface ICCollectionViewDataSource () 

@property (nonatomic, assign) NSInteger numberOfSections;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) CollectionViewCellConfigureBlock configureCellBlock;

@end

@implementation ICCollectionViewDataSource

#pragma mark - public methods
- (instancetype)initWithItems:(NSMutableArray *)items cellIdentifier:(NSString *)cellIdentifier configureBlock:(CollectionViewCellConfigureBlock)configureCellBlock
{
    return [self initWithItems:items numberOfSections:1 cellIdentifier:cellIdentifier configureBlock:configureCellBlock];
}

- (instancetype)initWithItems:(NSMutableArray *)items numberOfSections:(NSInteger)numberOfSections cellIdentifier:(NSString *)cellIdentifier configureBlock:(CollectionViewCellConfigureBlock)configureCellBlock
{
    self = [super init];
    if (self) {
        self.items = items;
        self.numberOfSections = numberOfSections;
        self.cellIdentifier = cellIdentifier;
        self.configureCellBlock = configureCellBlock;
    }
    
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.items) {
        return self.items.count;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.numberOfSections;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    id item = [self itemAtIndexPath:collectionView indexPath:indexPath];
    
    if (self.configureCellBlock && cell && item) {
        self.configureCellBlock(cell, item);
    }
    
    return cell;
}

#pragma mark - private methods
- (id)itemAtIndexPath:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.section * collectionView.numberOfSections + indexPath.row;
   
    if (index > self.items.count - 1) {
        return nil;
    }
    
    return self.items[index];
}

@end
