//
//  JYJMeViewController.m
//  JYJ不得姐
//
//  Created by JYJ on 16/3/30.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJMeViewController.h"

@interface JYJMeViewController ()

@end

@implementation JYJMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航栏标题
    self.navigationItem.title = @"我的";
    
    // 设置导航栏右边的按钮
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImageName:@"mine-setting-icon" highImageName:@"mine-setting-icon-click" target:self action:@selector(settingClick)];

    UIBarButtonItem *moonItem = [UIBarButtonItem itemWithImageName:@"mine-moon-icon" highImageName:@"mine-moon-icon-click" target:self action:@selector(moonClick)];
    
    self.navigationItem.rightBarButtonItems = @[settingItem, moonItem];
    // 设置背景色
    self.view.backgroundColor = JYJGlobalBg;
}

- (void)settingClick
{
    JYJLog(@"---");
}

- (void)moonClick
{
    JYJLog(@"---");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
