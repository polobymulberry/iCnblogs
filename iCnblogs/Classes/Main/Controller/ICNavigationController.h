//
//  ICNavigationController.h
//  iCnblogs
//
//  Created by poloby on 16/1/2.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICNavigationController : UINavigationController

/**
 *  封装NavigationController本身的pushViewController方法
 *
 *  @param viewController 需要push的viewController
 *  @param items          需要往viewController上添加的属性
 *  @param animated
 *  @param block          根据items来配置viewController
 */
- (void)pushViewController:(UIViewController *)viewController items:(id)items animated:(BOOL)animated constructingBodyWithBlock:(void (^)(id viewController, id items))block;

@end
