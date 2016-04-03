//
//  ICNavigationController.m
//  iCnblogs
//
//  Created by poloby on 16/1/2.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICNavigationController.h"

@implementation ICNavigationController

#pragma mark - life cycle

+ (void)initialize
{
    [self setupNavigationBarAttribute];
}

+ (void)setupNavigationBarAttribute
{
    UINavigationBar *appearance = [UINavigationBar appearance];
    
    NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
    textAttributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
    appearance.titleTextAttributes = textAttributes;
    appearance.barTintColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    appearance.tintColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)pushViewController:(UIViewController *)viewController items:(id)items animated:(BOOL)animated constructingBodyWithBlock:(void (^)(id, id))block
{
    if (block) {
        block(viewController, items);
    }
    
    [self pushViewController:viewController animated:animated];
}

@end
