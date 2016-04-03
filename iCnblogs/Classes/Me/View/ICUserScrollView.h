//
//  ICUserScrollView.h
//  iCnblogs
//
//  Created by poloby on 16/3/5.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICUserBlogTableView, ICUserCollectionTableView, ICUserSettingTableView;

@interface ICUserScrollView : UIScrollView

@property (nonatomic, strong) ICUserBlogTableView *blogTableView;
@property (nonatomic, strong) ICUserCollectionTableView *collectionTableView;
@property (nonatomic, strong) ICUserSettingTableView *settingTableView;

- (void)updateSubViews:(CGFloat)height;

@end
