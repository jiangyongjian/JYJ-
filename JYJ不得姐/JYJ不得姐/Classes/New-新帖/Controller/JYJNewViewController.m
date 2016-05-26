//
//  JYJNewViewController.m
//  JYJ不得姐
//
//  Created by JYJ on 16/3/30.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJNewViewController.h"

@interface JYJNewViewController ()

@end

@implementation JYJNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置导航栏标题
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    // 设置导航栏左边的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"MainTagSubIcon" highImageName:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
    // 设置背景色
    self.view.backgroundColor = JYJGlobalBg;
}

- (void)tagClick
{
    JYJLog(@"111");
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
