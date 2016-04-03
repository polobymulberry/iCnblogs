//
//  ICNewsContentViewController.h
//  iCnblogs
//
//  Created by poloby on 16/2/9.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICNews;

@interface ICNewsContentViewController : UIViewController

@property (nonatomic, assign) NSInteger newsId;
@property (nonatomic, copy) NSString *newsTitle;
@property (nonatomic, copy) NSString *newsTime;
@property (nonatomic, assign) NSInteger pushedViewControllerId;

@end
