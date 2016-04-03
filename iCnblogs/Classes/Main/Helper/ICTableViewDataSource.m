//
//  ICTableViewDataSource.m
//  iCnblogs
//
//  Created by poloby on 15/12/29.
//  Copyright © 2015年 poloby. All rights reserved.
//

#import "ICTableViewDataSource.h"

@interface ICTableViewDataSource () 

@property (nonatomic, assign) NSInteger numberOfSections;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) NSString *cellType;
@property (nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;

@end

@implementation ICTableViewDataSource

#pragma mark - life cycle
- (instancetype)initWithItems:(NSMutableArray *)items cellIdentifier:(NSString *)cellIdentifier cellType:(NSString *)cellType configureBlock:(TableViewCellConfigureBlock)configureCellBlock
{
    return [self initWithItems:items numberOfSections:1 cellIdentifier:cellIdentifier cellType:cellType configureBlock:configureCellBlock];
}

- (instancetype)initWithItems:(NSMutableArray *)items numberOfSections:(NSInteger)numberOfSections cellIdentifier:(NSString *)cellIdentifier cellType:(NSString *)cellType configureBlock:(TableViewCellConfigureBlock)configureCellBlock
{
    self = [super init];
    if (self) {
        self.items = items;
        self.numberOfSections = numberOfSections;
        self.cellIdentifier = cellIdentifier;
        self.cellType = cellType;
        self.configureCellBlock = configureCellBlock;
    }
    
    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 没有利用到section这个参数
    if (self.numberOfSections == 1) {
        if (self.items) {
            return self.items.count;
        }
    } else {
        if (self.items[section]) {
            return [self.items[section] count];
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class cellType = NSClassFromString(self.cellType);
    
    id cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    
    if (cell == nil) {
        cell = [[cellType alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
    }
    
    id item = [self itemAtIndexPath:tableView indexPath:indexPath];
    if (self.configureCellBlock && cell && item) {
        self.configureCellBlock(cell, item);
    }
    return cell;
}

#pragma mark - private methods
- (id)itemAtIndexPath:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    
    if (self.numberOfSections == 1) {
        NSInteger index = indexPath.row;
        if (index < self.items.count) {
            return self.items[index];
        }
        return nil;
    } else {
        if (indexPath.section < self.numberOfSections && indexPath.row < [self.items[indexPath.section] count]) {
            return self.items[indexPath.section][indexPath.row];
        }
        return nil;
    }
}

@end
