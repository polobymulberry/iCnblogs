//
//  ICRippleButton.m
//  iCnblogs
//
//  Created by poloby on 16/1/30.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICRippleButton.h"

#define DefaultRippleColor [UIColor whiteColor]

@interface ICRippleButton ()

@property (nonatomic, strong) UIImageView       *imageView;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) SEL               methodName;
@property (nonatomic, strong) id                superSender;
@property (nonatomic, assign) BOOL              isRippleOn;

@end

@implementation ICRippleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _rippleColor = DefaultRippleColor;
        _repeatCount = -1;
        _repeatInterval = 0.5;
        _isRippleOn = NO;
    }
    
    return self;
}

- (void)initWithImage:(UIImage *)image frame:(CGRect)frame {
    
    [self setupRippleButtonWithFrame:frame];
    
    [self setupImageView:image frame:frame];
    
    [self setupRippleTimer];
    
    [self setupTapGesture];
}

- (void)createRippleEffect
{
    // accounts for left/right offset and contentOffset of scroll view
    CGPoint shapePosition = [self convertPoint:self.center fromView:nil];
    
    CAShapeLayer *circleShape = [CAShapeLayer layer];
    CGRect pathFrame = CGRectMake(-CGRectGetMidX(self.bounds), -CGRectGetMidY(self.bounds), self.width, self.height);
    // CGRect pathFrame = CGRectMake(0, 0, self.width, self.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:self.layer.cornerRadius];
    circleShape.path = path.CGPath;
    circleShape.position = shapePosition;
    circleShape.fillColor = [UIColor clearColor].CGColor;
    circleShape.opacity = 0;
    circleShape.strokeColor = self.rippleColor.CGColor;
    circleShape.lineWidth = 3;
    
    [self.layer addSublayer:circleShape];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.5, 2.5, 1)];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1;
    alphaAnimation.toValue = @0;
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[scaleAnimation, alphaAnimation];
    animation.duration = 1.0f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [circleShape addAnimation:animation forKey:nil];
}

-(instancetype)initWithImage:(UIImage *)image
                       frame:(CGRect)frame
                      target:(SEL)action
                      sender:(id)sender {
    self = [self initWithFrame:frame];
    
    if(self){
        [self initWithImage:image frame:frame];
        self.methodName = action;
        self.superSender = sender;
    }
    
    return self;
}

-(void)handleButtonTap:(id)sender {
    [UIView animateWithDuration:0.1 animations:^{
        self.imageView.alpha = 0.4;
        self.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.9].CGColor;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.imageView.alpha = 1;
            self.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:0.9].CGColor;
        }completion:^(BOOL finished) {
            if([self.superSender respondsToSelector:self.methodName]){
                [self.superSender performSelectorOnMainThread:self.methodName withObject:nil waitUntilDone:NO];
            }
        }];
        
    }];
}

#pragma mark - public methods
- (void)startRippleEffect
{
    //NSAssert(self.timer, @"timer can not be nil");
    if (self.timer && !self.isRippleOn) {
        self.isRippleOn = YES;
        dispatch_resume(self.timer);
    }
}

- (void)stopRippleEffect
{
    //NSAssert(self.timer, @"timer can not be nil");
    if (self.timer && self.isRippleOn) {
        self.isRippleOn = NO;
        dispatch_suspend(self.timer);
    }
}

- (void)killRippleEffect
{
    if (self.timer) {
        dispatch_cancel(self.timer);
    }
}

#pragma mark - getters and setters
- (void)setupRippleButtonWithFrame:(CGRect)frame
{
    self.frame = frame;
    self.layer.borderColor = self.rippleColor.CGColor;
    self.layer.cornerRadius = self.height/2;
    self.layer.borderWidth = 5;
}

- (void)setupImageView:(UIImage *)image frame:(CGRect)frame
{
    self.imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView.frame = CGRectMake(0, 0, frame.size.width-5, frame.size.height-5);
    self.imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.imageView.layer.borderColor = [UIColor clearColor].CGColor;
    self.imageView.layer.borderWidth = 3;
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = self.imageView.frame.size.height/2;
    self.imageView.layer.masksToBounds = YES;
    
    [self addSubview:self.imageView];
}

- (void)setupRippleTimer
{
    __weak __typeof__(self) weakSelf = self;
    NSTimeInterval repeatInterval = self.repeatInterval;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, repeatInterval * NSEC_PER_SEC, 0);
    
    __block NSInteger count = 0;
    dispatch_source_set_event_handler(self.timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            count ++;
            if (self.repeatCount != -1 && count > weakSelf.repeatCount) {
                [weakSelf stopRippleEffect];
                return;
            }
            [weakSelf createRippleEffect];
        });
    });
}



// 主要负责响应自定义的tap事件
- (void)setupTapGesture
{
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleButtonTap:)];
    [self addGestureRecognizer:gesture];
}

@end
