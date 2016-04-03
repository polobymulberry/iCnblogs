//
//  ICTableViewDataSource.h
//  iCnblogs
//
//  Created by poloby on 15/12/29.
//  Copyright © 2015年 poloby. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TableViewCellConfigureBlock)(id cell, id item);

@interface ICTableViewDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, copy) NSMutableArray *items;

/**
 * numberOfSections default 1
 */
- (instancetype)initWithItems:(NSMutableArray *)items
               cellIdentifier:(NSString *)cellIdentifier
                     cellType:(NSString *)cellType
               configureBlock:(TableViewCellConfigureBlock)configureCellBlock;

- (instancetype)initWithItems:(NSMutableArray *)items
             numberOfSections:(NSInteger)numberOfSections
               cellIdentifier:(NSString *)cellIdentifier
                     cellType:(NSString *)cellType
               configureBlock:(TableViewCellConfigureBlock)configureCellBlock;

@end
