//
//  JYJLoginRegisterViewController.m
//  JYJ不得姐
//
//  Created by JYJ on 16/5/11.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJLoginRegisterViewController.h"

@interface JYJLoginRegisterViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewLeftMargin;
@end

@implementation JYJLoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (IBAction)back {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)showLoginOrRegister:(UIButton *)sender {
    // 退出键盘
    [self.view endEditing:YES];
    
    if (self.loginViewLeftMargin.constant == 0) { // 显示注册界面
        self.loginViewLeftMargin.constant = - self.view.width;
        sender.selected = YES;
    } else { // 显示登录界面
        self.loginViewLeftMargin.constant = 0;
        sender.selected = NO;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}
//
///**
// *  让当前控制器对应的状态栏是白色
// */
//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}


@end
