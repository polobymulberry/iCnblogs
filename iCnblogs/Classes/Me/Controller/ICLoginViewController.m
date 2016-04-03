//
//  ICLoginViewController.m
//  iCnblogs
//
//  Created by poloby on 16/2/22.
//  Copyright © 2016年 poloby. All rights reserved.
//

#import "ICLoginViewController.h"
#import "ICBlogViewController.h"
#import "ICLeftSideMenu.h"
#import "ICMeViewController.h"
#import "ICNavigationController.h"
#import "ICInputTextField.h"
#import "ICOAuth.h"
#import "ICOAuthTool.h"
#import "BBRSACryptor.h"
#import "GTMBase64.h"

#import <RESideMenu/RESideMenu.h>
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>

#define kRSAPublickey \
@"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCp0wHYbg/NOPO3nzMD3dndwS0MccuMeXCHgVlGOoYyFwLdS24Im2e7YyhB0wrUsyYf0/nhzCzBK8ZC9eCWqd0aHbdgOQT6CuFQBMjbyGYvlVYU2ZP7kG9Ft6YV6oc9ambuO7nPZh+bvXH0zDKfi02prknrScAKC0XhadTHT3Al0QIDAQAB"

static BOOL hasKeyboardShow = NO;

@interface ICLoginViewController ()

@property (nonatomic, strong) ICInputTextField *usernameTextField;
@property (nonatomic, strong) ICInputTextField *passwordTextField;
@property (nonatomic, strong) UIImageView *blogImageView;
@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, strong) BBRSACryptor *rsaCryptor;

@end

@implementation ICLoginViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    self.view.backgroundColor = ICInkColor;
    
    [self.view addSubview:self.usernameTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.blogImageView];
    [self.view addSubview:self.loginButton];
    
    [self setupNavigationBar];
    
    UITapGestureRecognizer *viewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTappedView)];
    [self.view addGestureRecognizer:viewTapGestureRecognizer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)setupNavigationBar
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_close"] style:UIBarButtonItemStylePlain target:self action:@selector(closeLoginViewController)];
    self.navigationItem.title = @"登录";
}

#pragma mark - event response
- (void)closeLoginViewController
{
    ICLeftSideMenu *leftSideMenu = [[ICLeftSideMenu alloc] init];
    [self presentViewController:leftSideMenu animated:YES completion:nil];
}

- (void)didTappedView
{
    [self.view endEditing:YES];
}

- (void)didTappedLoginButton:(UIButton *)button
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"正在登录...";
    // 进行登录操作
    // 获取到用户名和密码
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    // 给用户名和密码使用openssl进行rsa加密
    self.rsaCryptor = [[BBRSACryptor alloc] init];
    // 导入公钥
    if (![self.rsaCryptor exportRSAPublicKey]) {
        BOOL importSuccess = [self.rsaCryptor importRSAPublicKeyBase64:kRSAPublickey];
        if (importSuccess) {
            ICLog(@"rsaCryptor success");
        } else {
            ICLog(@"rsaCryptor failure");
        }
    }
    // 用公钥加密
    NSData *usernameCipherData = [self.rsaCryptor encryptWithPublicKeyUsingPadding:RSA_PKCS1_PADDING plainData:[username dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *passwordCipherData = [self.rsaCryptor encryptWithPublicKeyUsingPadding:RSA_PKCS1_PADDING plainData:[password dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *usernameCipherString = [GTMBase64 stringByEncodingData:usernameCipherData];
    NSString *passwordCipherString = [GTMBase64 stringByEncodingData:passwordCipherData];
    
    ICLog(@"usernameCipherString: %@", usernameCipherString);
    ICLog(@"passwordCipherString: %@", passwordCipherString);
    
    [ICOAuthTool oauthWithUserName:usernameCipherString password:passwordCipherString success:^(id  _Nullable responseObject) {
        ICOAuth *oauth = [ICOAuth initWithAttribute:responseObject];
        [ICOAuthTool save:oauth];
        // 跳转到MeViewController
        [hud hide:YES];
        ICNavigationController *meNavigationController = [[ICNavigationController alloc] initWithRootViewController:[[ICMeViewController alloc] init]];
        ICLeftSideMenu *leftSideMenu = [[ICLeftSideMenu alloc] initWithContentViewController:meNavigationController];
        [self.navigationController presentViewController:leftSideMenu animated:YES completion:nil];
    } failure:^(NSError * _Nonnull error) {
        ICLog(@"failure: %@", error);
    }];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    if (!hasKeyboardShow) {
        NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        
//        CGRect keyboardBounds;
//        [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
//        keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
        
        // 重新计算textField位置
        [UIView animateWithDuration:[duration doubleValue] animations:^{
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:[duration doubleValue]];
            [UIView setAnimationCurve:[curve intValue]];
            
            self.usernameTextField.y -= ICDeviceHeight * 0.35;
            self.passwordTextField.y -= ICDeviceHeight * 0.35;
            self.blogImageView.y -= ICDeviceHeight;
            self.loginButton.y -= ICDeviceHeight * 0.35;
        }];
        
        hasKeyboardShow = YES;
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (hasKeyboardShow) {
        NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        
        [UIView animateWithDuration:[duration doubleValue] animations:^{
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:[duration doubleValue]];
            [UIView setAnimationCurve:[curve intValue]];
            
            self.usernameTextField.y = ICDeviceHeight * 0.5;
            self.passwordTextField.y = ICDeviceHeight * 0.5 + ICDeviceWidth * 0.15;
            self.blogImageView.y = ICDeviceHeight * 0.15;
            self.loginButton.y = ICDeviceHeight * 0.5 + ICDeviceWidth * 0.35;
        }];
        hasKeyboardShow = NO;
    }
}

#pragma mark - getters and setters
- (ICInputTextField *)usernameTextField
{
    if (_usernameTextField == nil) {
        _usernameTextField = [[ICInputTextField alloc] initWithPlaceholder:@"用户名" secureTextEntry:NO];
        _usernameTextField.frame = CGRectMake(ICDeviceWidth * 0.15, ICDeviceHeight * 0.5, ICDeviceWidth * 0.7, ICDeviceWidth * 0.1);
        [_usernameTextField setValue:[UIColor colorWithWhite:0.5 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    }
    
    return _usernameTextField;
}

- (ICInputTextField *)passwordTextField
{
    if (_passwordTextField == nil) {
        _passwordTextField = [[ICInputTextField alloc] initWithPlaceholder:@"密码" secureTextEntry:YES];
        _passwordTextField.frame = CGRectMake(ICDeviceWidth * 0.15, ICDeviceHeight * 0.5 + ICDeviceWidth * 0.15, ICDeviceWidth * 0.7, ICDeviceWidth * 0.1);
        
        [_passwordTextField setValue:[UIColor colorWithWhite:0.5 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    }
    
    return _passwordTextField;
}

- (UIImageView *)blogImageView
{
    if (_blogImageView == nil) {
        _blogImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_blog"]];
        _blogImageView.frame = CGRectMake(ICDeviceWidth * 0.3, ICDeviceHeight * 0.15, ICDeviceWidth * 0.4, ICDeviceWidth * 0.4 * 267.0 / 200.0);
    }
    
    return _blogImageView;
}

- (UIButton *)loginButton
{
    if (_loginButton == nil) {
        _loginButton = [[UIButton alloc] init];
        _loginButton.frame = CGRectMake(ICDeviceWidth * 0.15, ICDeviceHeight * 0.5 + ICDeviceWidth * 0.35, ICDeviceWidth * 0.7, ICDeviceWidth * 0.07);
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _loginButton.layer.cornerRadius = ICDeviceWidth * 0.02;
        _loginButton.backgroundColor = [UIColor clearColor];
        _loginButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _loginButton.layer.borderWidth = 1.0;
        
        [_loginButton addTarget:self action:@selector(didTappedLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _loginButton;
}

@end
