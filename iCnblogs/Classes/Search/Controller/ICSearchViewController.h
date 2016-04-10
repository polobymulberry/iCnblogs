//
//  ICSearchViewController.h
//  iCnblogs
//
//  Created by poloby on 16/4/8.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICTableViewDataSource.h"

typedef NS_ENUM(NSUInteger, ICSearchType) {
    ICSearchTypeBlog = 1,
    ICSearchTypeNews = 2,
    ICSearchTypeLibrary = 4
};

@interface ICSearchViewController : UITableViewController

@property (nonatomic, assign) ICSearchType searchType;
@property (nonatomic, copy) NSString *searchString;

- (instancetype)initWithStyle:(UITableViewStyle)style searchType:(ICSearchType)searchType;

@end
