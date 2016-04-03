//
//  UIImage+Extension.m
//  iCnblogs
//
//  Created by poloby on 15/12/30.
//  Copyright © 2015年 poloby. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+ (UIImage *)imageNamed:(NSString *)name withRenderingMode:(UIImageRenderingMode)renderingMode
{
    UIImage *image = [UIImage imageNamed:name];
    
    if (image != nil) {
        image = [image imageWithRenderingMode:renderingMode];
    }
    
    return image;
}

@end
