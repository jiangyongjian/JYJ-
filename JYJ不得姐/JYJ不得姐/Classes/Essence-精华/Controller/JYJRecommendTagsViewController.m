//
//  JYJRecommendTagsViewController.m
//  JYJ不得姐
//
//  Created by JYJ on 16/5/7.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJRecommendTagsViewController.h"
#import "JYJRecommendTag.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "MJExtension.h"
#import "JYJRecommendTagCell.h"

static NSString * const JYJTagsId = @"tag";
@interface JYJRecommendTagsViewController () <UITableViewDelegate, UITableViewDataSource>
/** 标签数据 */
@property (nonatomic, strong) NSArray *tags;
@end

@implementation JYJRecommendTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化
    [self setupTableView];
    // 加载数据
    [self loadTags];
}

- (void)loadTags {
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"tag_recommend";
    params[@"action"] = @"sub";
    params[@"c"] = @"topic";
    
    // 发送请求
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.tags = [JYJRecommendTag mj_objectArrayWithKeyValuesArray:responseObject];
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载数据失败!"];
    }];
}

- (void)setupTableView {
    self.title = @"推荐标签";
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JYJRecommendTagCell class]) bundle:nil] forCellReuseIdentifier:JYJTagsId];
    self.tableView.rowHeight = 70;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor= JYJGlobalBg;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JYJRecommendTagCell *cell = [tableView dequeueReusableCellWithIdentifier:JYJTagsId];
    cell.recommendTag = self.tags[indexPath.row];
    
    return cell;
}


@end
