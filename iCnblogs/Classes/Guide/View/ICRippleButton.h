//
//  ICRippleButton.h
//  iCnblogs
//
//  Created by poloby on 16/1/30.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICRippleButton : UIView

@property (nonatomic, strong) UIColor *rippleColor;

// repeatCount为-1表示一直重复，默认为-1
@property (nonatomic, assign) NSInteger repeatCount;
// repeatInterval表示重复的间隔时间（默认为0.5）
@property (nonatomic, assign) NSTimeInterval repeatInterval;

// init method
-(instancetype)initWithImage:(UIImage *)image frame:(CGRect)frame target:(SEL)action sender:(id)sender;

// control method
- (void)startRippleEffect;
- (void)stopRippleEffect;
- (void)killRippleEffect; // 清除timer
@end
