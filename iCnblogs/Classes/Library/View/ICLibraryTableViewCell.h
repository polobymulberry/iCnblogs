//
//  ICLibraryTableViewCell.h
//  iCnblogs
//
//  Created by poloby on 16/3/12.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICLibrary;

@interface ICLibraryTableViewCell : UITableViewCell
// Controller调用setLibrary:来设置ICLibraryTableViewCell
@property (nonatomic, strong) ICLibrary *library;

@end
