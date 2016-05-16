//
//  JYJFriendTrendsViewController.m
//  JYJ不得姐
//
//  Created by JYJ on 16/3/30.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJFriendTrendsViewController.h"
#import "JYJRecommendViewController.h"
#import "JYJLoginRegisterViewController.h"

@interface JYJFriendTrendsViewController ()

@end

@implementation JYJFriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航栏标题
    self.navigationItem.title = @"我的关注";
    
    // 设置导航栏左边的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"friendsRecommentIcon" highImageName:@"friendsRecommentIcon-click" target:self action:@selector(friendsClick)];
    // 设置背景色
    self.view.backgroundColor = JYJGlobalBg;
}

- (void)friendsClick
{
    JYJRecommendViewController *vc = [[JYJRecommendViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)loginRegister {
    JYJLoginRegisterViewController *login = [[JYJLoginRegisterViewController alloc] init];
    [self presentViewController:login animated:YES completion:nil];
    
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
