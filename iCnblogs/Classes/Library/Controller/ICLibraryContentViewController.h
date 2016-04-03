//
//  ICLibraryContentViewController.h
//  iCnblogs
//
//  Created by poloby on 16/3/13.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICLibraryContentViewController : UIViewController

@property (nonatomic, assign) NSInteger libraryId;
@property (nonatomic, copy) NSString *libraryTitle;
@property (nonatomic, copy) NSString *libraryTime;

@end
