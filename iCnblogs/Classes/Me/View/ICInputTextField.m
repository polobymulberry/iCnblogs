//
//  ICInputTextField.m
//  iCnblogs
//
//  Created by poloby on 16/2/28.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICInputTextField.h"

#import <Masonry/Masonry.h>

@interface ICInputTextField () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *underlineView;

@end

@implementation ICInputTextField

- (instancetype)initWithPlaceholder:(NSString *)placeholder secureTextEntry:(BOOL)secureTextEntry
{
    self = [super init];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.textColor = [UIColor whiteColor];
        
        self.placeholder = placeholder;
        
        // custom clear button
        // self.clearButtonMode = UITextFieldViewModeAlways;
        UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        clearButton.frame = CGRectMake(0, 0, 16, 16);
        [clearButton setImage:[UIImage imageNamed:@"icon_clearbutton"] forState:UIControlStateNormal];
        [clearButton addTarget:self action:@selector(clearAllInput) forControlEvents:UIControlEventTouchUpInside];
        self.rightView = clearButton;
        self.rightViewMode = UITextFieldViewModeWhileEditing;
        // 设置下划线
        [self addSubview:self.underlineView];
        if (secureTextEntry) {
            self.secureTextEntry = YES;
        }
        // delegate
        self.delegate = self;
        // KVO
        [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
    return self;
}

-(void)textFieldDidChange:(UITextField *)textField {
    if ([textField.text isEqualToString:@""]) {
        textField.rightView.hidden = YES;
    } else {
        textField.rightView.hidden = NO;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        textField.rightView.hidden = YES;
    } else {
        textField.rightView.hidden = NO;
    }
}

- (void)clearAllInput
{
    self.text = @"";
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.underlineView.frame = CGRectMake(0, frame.size.height - 1.0, frame.size.width, 1.0);
}

#pragma mark - getters and setters
- (UIView *)underlineView
{
    if (_underlineView == nil) {
        _underlineView = [[UIView alloc] init];
        
        _underlineView.backgroundColor = [UIColor whiteColor];
    }
    
    return _underlineView;
}

@end
