//
//  JYJRecommendViewController.m
//  JYJ不得姐
//
//  Created by JYJ on 16/4/2.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJRecommendViewController.h"
#import "JYJRecommendCategoryCell.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import "JYJRecommendCategory.h"
#import <MJExtension.h>

@interface JYJRecommendViewController () <UITableViewDataSource, UITableViewDelegate>
/** 左边的类别数据 */
@property (nonatomic, strong) NSArray *categories;
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@end

@implementation JYJRecommendViewController
static NSString * const JYJCategoryId = @"category";

- (void)viewDidLoad {
    [super viewDidLoad];
    // 注册cell
    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([JYJRecommendCategoryCell class]) bundle:nil] forCellReuseIdentifier:JYJCategoryId];
    
    self.title = @"推荐关注";
    
    // 设置背景色
    self.view.backgroundColor = JYJGlobalBg;
    
    // 显示指示器
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    // 发送请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"category";
    params[@"c"] = @"subscribe";
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 隐藏指示器
        [SVProgressHUD dismiss];
        // 服务器返回的Json数据
        self.categories = [JYJRecommendCategory mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        JYJLog(@"%zd", self.categories.count);
        // 刷新表格
        [self.categoryTableView reloadData];

        // 默认选中首行
        [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 隐藏指示器
//        [SVProgressHUD showErrorWithStatus:@"加载推荐信息失败!"];
        // 显示失败信息
        [SVProgressHUD showErrorWithStatus:@"加载推荐信息失败!"];
    }];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JYJRecommendCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:JYJCategoryId];
    cell.category = self.categories[indexPath.row];
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
