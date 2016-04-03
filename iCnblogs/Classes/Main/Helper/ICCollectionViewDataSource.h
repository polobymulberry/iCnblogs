//
//  ICCollectionViewDataSource.h
//  iCnblogs
//
//  Created by poloby on 16/1/7.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CollectionViewCellConfigureBlock)(id cell, id item);

@interface ICCollectionViewDataSource : NSObject <UICollectionViewDataSource>

@property (nonatomic, copy) NSMutableArray *items;

- (instancetype)initWithItems:(NSMutableArray *)items
               cellIdentifier:(NSString *)cellIdentifier
               configureBlock:(CollectionViewCellConfigureBlock)configureCellBlock;

- (instancetype)initWithItems:(NSMutableArray *)items
             numberOfSections:(NSInteger)numberOfSections
               cellIdentifier:(NSString *)cellIdentifier
               configureBlock:(CollectionViewCellConfigureBlock)configureCellBlock;

@end
