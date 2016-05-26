//
//  JYJTopicViewController.m
//  JYJ不得姐
//
//  Created by JYJ on 16/5/23.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJTopicViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "JYJTopic.h"
#import "JYJTopicCell.h"
#import "JYJCommentViewController.h"
#import "JYJNewViewController.h"

@interface JYJTopicViewController ()
/** 帖子数据 */
@property (nonatomic, strong) NSMutableArray *topics;
/** 当前页码 */
@property (nonatomic, assign) NSInteger page;
/** 当加载下一页数据时需要这个参数 */
@property (nonatomic, copy) NSString *maxtime;
/** 上一次的请求参数 */
@property (nonatomic, strong) NSDictionary *params;

/** 上次选中的索引 */
@property (nonatomic, assign) NSUInteger lastSelectedIndex;
@end

@implementation JYJTopicViewController
#pragma mark - 仅仅是为了消除编译器发出的警告 : type方法没有实现
- (JYJTopicType)type {
    return 0;
}

- (NSMutableArray *)topics {
    if (!_topics) {
        self.topics = [NSMutableArray array];
    }
    return _topics;
}
static NSString *const JYJTopicCellId = @"topic";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(JYJNavigationBarH + JYJTitilesViewH, 0, JYJTabBarH, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];

    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JYJTopicCell class]) bundle:nil] forCellReuseIdentifier:JYJTopicCellId];
    
    // 添加刷新控件
    [self setupRefresh];
    
    //监听tabBar按钮重复点击的通知
    [JYJNoteCenter addObserver:self selector:@selector(tabBarSelect) name:JYJTabBarDidSelectNotification object:nil];
}

/**
 *  tabBar按钮重复点击
 */
- (void)tabBarSelect {
    // 如果是联系选中2次，直接刷新
    UITabBarController *tabBarVc = JYJRootTabBarController;
    if (self.lastSelectedIndex == tabBarVc.selectedIndex && self.view.isShowingOnKeyWindow) {
        [self.tableView.mj_header beginRefreshing];
    }
    // 记录这一次选中的索引
    self.lastSelectedIndex = tabBarVc.selectedIndex;
}

/**
 *  刷新控件
 */
- (void)setupRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    // 自动改变透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}

#pragma mark - a 参数
- (NSString *)a {
    UITabBarController *tabBarVc = JYJRootTabBarController;
    return  tabBarVc.selectedIndex == 1 ? @"newlist" : @"list";
}

#pragma makr - 数据处理
/**
 *  加载新的帖子数据
 */
- (void)loadNewTopics {
    // 结束上啦
    [self.tableView.mj_footer endRefreshing];
    
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = self.a;
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    self.params = params;
    
    // 发送请求
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.params != params) return;
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 字典转模型
        self.topics = [JYJTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        
        // 清空页码
        self.page = 0;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.params != params) return;
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        [self.tableView.mj_header endRefreshing];
    }];
}

/**
 *  加载更多的帖子数据
 */
- (void)loadMoreTopics {
    // 结束下拉
    [self.tableView.mj_header endRefreshing];
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = self.a;
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    NSInteger page = self.page + 1;
    params[@"page"] = @(page);
    params[@"maxtime"] = self.maxtime;
    self.params = params;
    
    // 发送请求
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.params != params) return;
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 字典转模型
        NSArray *newTopics = [JYJTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.topics addObjectsFromArray:newTopics];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        // 设置页码
        self.page = page;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.params != params) return;
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.mj_footer.hidden = (self.topics.count == 0);
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JYJTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:JYJTopicCellId];
    
    cell.topic = self.topics[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 200;
//}

#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取出帖子模型
    JYJTopic *topic = self.topics[indexPath.row];
    // 返回这个模型对应的cell高度
    return topic.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JYJCommentViewController *commentVc = [[JYJCommentViewController alloc] init];
    commentVc.topic = self.topics[indexPath.row];
    
//    UITabBarController *tabBarVc = (UITabBarController *)JYJKeyWindow.rootViewController;
//    [(UINavigationController *)tabBarVc.selectedViewController pushViewController:commentVc animated:YES];
    UITabBarController *tabBarVc = JYJRootTabBarController;
    UINavigationController *nav = (UINavigationController *)tabBarVc.selectedViewController;
    [nav pushViewController:commentVc animated:YES];
}

@end
