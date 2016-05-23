//
//  JYJRecommendViewController.m
//  JYJ不得姐
//
//  Created by JYJ on 16/4/2.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJRecommendViewController.h"
#import "JYJRecommendCategoryCell.h"
#import "JYJRecommendUserCell.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "JYJRecommendCategory.h"
#import "JYJRecommendUser.h"
#import "MJExtension.h"
#import "MJRefresh.h"

#define JYJSelectedCategory self.categories[self.categoryTableView.indexPathForSelectedRow.row]

@interface JYJRecommendViewController () <UITableViewDataSource, UITableViewDelegate>
/** 左边的类别数据 */
@property (nonatomic, strong) NSArray *categories;
///** 右边的用户数据 */
//@property (nonatomic, strong) NSArray *users;

/** 左边的类别表格 */
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
/** 右边的用户表格 */
@property (weak, nonatomic) IBOutlet UITableView *userTableView;
/** AFN请求管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;

/** 请求参数 */
@property (nonatomic, strong) NSMutableDictionary *params;
@end

@implementation JYJRecommendViewController
static NSString * const JYJCategoryId = @"category";
static NSString * const JYJUserId = @"user";


- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 控制器初始化
    [self setupTabelView];
    
    // 添加刷新控件
    [self setupRefresh];
    
    // 加载左侧的类别数据
    [self loadCategories];
}

/**
 *  初始化
 */
- (void)setupTabelView {
    // 注册cell
    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([JYJRecommendCategoryCell class]) bundle:nil] forCellReuseIdentifier:JYJCategoryId];
    [self.userTableView registerNib:[UINib nibWithNibName:NSStringFromClass([JYJRecommendUserCell class]) bundle:nil] forCellReuseIdentifier:JYJUserId];
    // 设置tableViewInsert
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.categoryTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.userTableView.contentInset = self.categoryTableView.contentInset;
    self.userTableView.rowHeight = 70;
    
    // 设置标题
    self.title = @"推荐关注";
    
    // 设置背景色
    self.view.backgroundColor = JYJGlobalBg;
}

/**
 * 加载左侧的类别数据
 */
- (void)loadCategories {
    // 显示指示器
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    // 发送请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"category";
    params[@"c"] = @"subscribe";
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 隐藏指示器
        [SVProgressHUD dismiss];
        // 服务器返回的Json数据
        self.categories = [JYJRecommendCategory mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        JYJLog(@"%zd", self.categories.count);
        // 刷新表格
        [self.categoryTableView reloadData];
        
        // 默认选中首行
        [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        
        //让用户表格进入下拉刷新状态
        [self.userTableView.mj_header beginRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 隐藏指示器
        //        [SVProgressHUD showErrorWithStatus:@"加载推荐信息失败!"];
        // 显示失败信息
        [SVProgressHUD showErrorWithStatus:@"加载推荐信息失败!"];
    }];
}
/**
 * 添加刷新控件
 */
- (void)setupRefresh {
    self.userTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUsers)];
    self.userTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];
}

#pragma mark -- 加载用户数据
- (void)loadNewUsers {
    JYJRecommendCategory *rc = JYJSelectedCategory;
    // 设置当前页码为1
    rc.currentPage = 1;
    
    // 发送请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(rc.ID);
    params[@"page"] = @(rc.currentPage);
    self.params = params;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        // 字典转模型
        NSArray *users = [JYJRecommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 清楚所有旧数据
        [rc.users removeAllObjects];
        
        // 添加当前类别到对应的数组中
        [rc.users addObjectsFromArray:users];
        
        // 保存总数
        rc.total = [responseObject[@"total"] integerValue];
        
        
        // 不是最后一次请求
        if (self.params != params) return;
        
        // 刷新右边表格
        [self.userTableView reloadData];
        
        // 结束刷新
        [self.userTableView.mj_header endRefreshing];
        
        // 让底部控件结束刷新
        [self checkFooterState];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.params != params) return;
        // 隐藏指示器
//        [SVProgressHUD showErrorWithStatus:@"加载推荐信息失败!"];
        // 显示失败信息
        [SVProgressHUD showErrorWithStatus:@"加载推荐信息失败!"];
        // 结束刷新
        [self.userTableView.mj_header endRefreshing];
    }];

}

- (void)loadMoreUsers {
    JYJRecommendCategory *category = JYJSelectedCategory;
    
    // 发送请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(category.ID);
    params[@"page"] = @(++category.currentPage);
    JYJLog(@"%@", params[@"page"]);
    self.params = params;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 字典转模型
        NSArray *users = [JYJRecommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 添加到当前类别对应的用户数组中
        [category.users addObjectsFromArray:users];
        
        // 不是最后一次请求
        if (self.params != params) return;
        
        // 刷新右边表格
        [self.userTableView reloadData];
        
        // 让底部控件结束刷新
        [self checkFooterState];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.params != params) return;
        --category.currentPage;
        // 显示失败信息
        [SVProgressHUD showErrorWithStatus:@"加载推荐信息失败!"];
        // 结束刷新
        [self.userTableView.mj_footer endRefreshing];
        
    }];
}

/**
 *  时刻监测footer的状态
 */
- (void)checkFooterState {
    JYJRecommendCategory *rc = JYJSelectedCategory;
    
    // 每次刷新右边数据时，都控制footer显示或者隐藏
    self.userTableView.mj_footer.hidden = (rc.users.count == 0);
    
    // 让底部控件结束刷新
    if (rc.users.count == rc.total) { // 全部数据已经加载完毕
        [self.userTableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.userTableView.mj_footer endRefreshing];
    }
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.categoryTableView) { // 左边的类别表格
        return self.categories.count;
    } else { // 右边的用户表格
        // 监测footer的状态
        [self checkFooterState];
        return [JYJSelectedCategory users].count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.categoryTableView) { // 左边的类别表格
        JYJRecommendCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:JYJCategoryId];
        cell.category = self.categories[indexPath.row];
        return cell;
    } else { // 右边的用户表格
        JYJRecommendUserCell *cell = [tableView dequeueReusableCellWithIdentifier:JYJUserId];
//        JYJLog(@"%@", [[JYJSelectedCategory users][indexPath.row] screen_name]);
        cell.user = [JYJSelectedCategory users][indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 结束刷新
    [self.userTableView.mj_header endRefreshing];
    [self.userTableView.mj_footer endRefreshing];
    
    if (tableView == self.categoryTableView) { // 左边的类别表格
        JYJRecommendCategory *c = self.categories[indexPath.row];
        
        if (c.users.count) {
            // 显示曾经的数据
            [self.userTableView reloadData];
        } else {
            // 赶紧刷新表格，目的是:马上显示当前的category的用户数据，不让用户看见上有个category的残留数据
            [self.userTableView reloadData];
            
            // 进入下拉刷新状态
            [self.userTableView.mj_header beginRefreshing];
        }
    }
}

#pragma mark - 控制器的销毁
- (void)dealloc
{
    // 停止所有操作
    [self.manager.operationQueue cancelAllOperations];
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
