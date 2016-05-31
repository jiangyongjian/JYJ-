//
//  JYJMeViewController.m
//  JYJ不得姐
//
//  Created by JYJ on 16/3/30.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJMeViewController.h"
#import "JYJMeCell.h"
#import "JYJMeFooterView.h"
#import "JYJSettingViewController.h"


static NSString *JYJMeId = @"me";
@interface JYJMeViewController () <JYJMeFooterViewDelegate>

@end

@implementation JYJMeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupTabelView];
}

- (void)setupNav {
    // 设置导航栏标题
    self.navigationItem.title = @"我的";
    
    // 设置导航栏右边的按钮
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImageName:@"mine-setting-icon" highImageName:@"mine-setting-icon-click" target:self action:@selector(settingClick)];
    
    UIBarButtonItem *moonItem = [UIBarButtonItem itemWithImageName:@"mine-moon-icon" highImageName:@"mine-moon-icon-click" target:self action:@selector(moonClick)];
    
    self.navigationItem.rightBarButtonItems = @[settingItem, moonItem];

}

- (void)setupTabelView {
    // 设置背景颜色
    self.tableView.backgroundColor = JYJGlobalBg;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.tableView registerClass:[JYJMeCell class] forCellReuseIdentifier:JYJMeId];
    
    // 调整header和footer
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = JYJTopicCellMargin;
    
    //设置footerView
    JYJMeFooterView *meFooterView = [[JYJMeFooterView alloc] init];
    meFooterView.delegate = self;
    self.tableView.tableFooterView = meFooterView;
    self.tableView.contentInset = UIEdgeInsetsMake(JYJTopicCellMargin - 35, 0, 0, 0);
}

- (void)settingClick
{
    [self.navigationController pushViewController:[[JYJSettingViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
}

- (void)moonClick
{
    JYJLog(@"---");
}

- (void)meFooterViewDidLoadDate:(JYJMeFooterView *)meFooterView{
    self.tableView.contentInset = UIEdgeInsetsMake(64 + JYJTopicCellMargin - 35, 0, meFooterView.height + 35, 0);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JYJMeCell *cell = [tableView dequeueReusableCellWithIdentifier:JYJMeId];
    
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"mine-icon-nearby"];
        cell.textLabel.text = @"登录/注册";
    } else if (indexPath.section == 1){
        cell.textLabel.text = @"离线下载";
    }
    
    return cell;
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
