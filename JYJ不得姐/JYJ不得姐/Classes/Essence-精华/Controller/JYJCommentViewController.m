//
//  JYJCommentViewController.m
//  JYJ不得姐
//
//  Created by JYJ on 16/5/25.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJCommentViewController.h"
#import "JYJTopicCell.h"
#import "JYJTopic.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "JYJComment.h"
#import "MJExtension.h"
#import "JYJCommentHeaderView.h"
#import "JYJCommentCell.h"

static NSString * const JYJCommentId = @"comment";
@interface JYJCommentViewController ()<UITableViewDelegate, UITableViewDataSource>
/** 工具条底部间距 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSapce;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 最热评论 */
@property (nonatomic, strong) NSArray *hotComments;
/** 最新评论 */
@property (nonatomic, strong) NSMutableArray *latestComments;

/** 保存帖子的top_cmt */
@property (nonatomic, strong) JYJComment *saved_top_cmt;

/** 保存帖子的top_cmt */
@property (nonatomic, assign) NSUInteger page;

/** 管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation JYJCommentViewController

- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        self.manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBasic];
    
    [self setupHeader];
    
    [self setupRefresh];
    
}
- (void)setupRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
    self.tableView.mj_footer.hidden = YES;
}

- (void)loadNewComments {
    // 结束之前的所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];

    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"hot"] = @"1";
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            [self.tableView.mj_header endRefreshing];
            return;
        } // 说明没有评论数据
        
        // 最热评论
        self.hotComments = [JYJComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        
        // 最新评论
        self.latestComments = [JYJComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        // 保存页码
        self.page = 1;
        
        // 刷新数据
        [self.tableView reloadData];
        // 介绍刷新
        [self.tableView.mj_header endRefreshing];
        
        // 控制footer的状态
        NSUInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComments.count >= total) { // 全部加载完毕
            self.tableView.mj_footer.hidden = YES;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
    }];
}


- (void)loadMoreComments {
    // 结束之前的所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];

    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    // 页码
    NSInteger page = self.page + 1;
    params[@"page"] = @(page);
    JYJComment *cmt = [self.latestComments lastObject];
    params[@"lastcid"] = cmt.ID;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            [self.tableView.mj_header endRefreshing];
            return;
        } // 说明没有评论数据
        
        // 最热评论
        NSArray *newComments = [JYJComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [self.latestComments addObjectsFromArray:newComments];
        // 保存页码
        self.page = page;
        
        // 刷新数据
        [self.tableView reloadData];
        
        // 控制footer的状态
        NSUInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComments.count >= total) { // 全部加载完毕
            self.tableView.mj_footer.hidden = YES;
        } else {
            // 结束刷新状态
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
    }];

}

- (void)setupHeader {
    // 创建header
    UIView *header = [[UIView alloc] init];
    
    // 清空top_cmt
    if (self.topic.top_cmt) {
        self.saved_top_cmt = self.topic.top_cmt;
        self.topic.top_cmt = nil;
        [self.topic setValue:@0 forKey:@"cellHeight"];
    }
    
    // 添加cell
    JYJTopicCell *cell = [JYJTopicCell cell];
    cell.topic = self.topic;
    cell.size = CGSizeMake(JYJScreenW, self.topic.cellHeight);
    [header addSubview:cell];
    
    // header的高度
    header.height = self.topic.cellHeight + JYJTopicCellMargin;
    //设置header
    self.tableView.tableHeaderView = header;
}

- (void)setupBasic {
    self.title = @"评论";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@" comment_nav_item_share_icon" highImageName:@"comment_nav_item_share_icon_click" target:nil action:nil];
    [JYJNoteCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    self.tableView.backgroundColor = JYJGlobalBg;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // 设置cell的高度
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // 去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 内边距
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, JYJTopicCellMargin, 0);
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JYJCommentCell class]) bundle:nil] forCellReuseIdentifier:JYJCommentId];
}

- (void)keyboardWillChangeFrame:(NSNotification *)note {
    // 键盘显示\隐藏完毕的frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 修改底部约束
    self.bottomSapce.constant = JYJScreenH - frame.origin.y;
    // 动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 动画及时刷新
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}


- (void)dealloc {
    [JYJNoteCenter removeObserver:self];
    
    //恢复帖子的top_cmt
    if (self.saved_top_cmt) {
        self.topic.top_cmt = self.saved_top_cmt;
        [self.topic setValue:@0 forKey:@"cellHeight"];
    }
    
    // 取消所有任务
//    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    [self.manager invalidateSessionCancelingTasks:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - <UITableViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSUInteger hotCount = self.hotComments.count;
    NSUInteger latestCount = self.latestComments.count;
    // 隐藏尾部控件
    tableView.mj_footer.hidden = (latestCount == 0);
    
    if (hotCount) return 2; //有“最热评论” + “最新评论” 2组
    if (latestCount) return 1; // 有“最新评论” 1组
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger hotCount = self.hotComments.count;
    NSUInteger latestCount = self.latestComments.count;
    
    if (section == 0) {
        return hotCount ? hotCount : latestCount;
    }
    // 非第0组
    return latestCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JYJCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:JYJCommentId];
    
    cell.comment = [self commentInIndexPath:indexPath];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // 先从缓存池中找header
    JYJCommentHeaderView *header = [JYJCommentHeaderView headerViewWithTableView:tableView];
    
    // 设置label的数据
    NSInteger hotCount = self.hotComments.count;
    if (section == 0) {
        header.title = hotCount ? @"最热评论" : @"最新评论";
    } else {
        header.title = @"最新评论";
    }
    return header;
}


- (JYJComment *)commentInIndexPath:(NSIndexPath *)indexPath
{
    return [self commentsInSection:indexPath.section][indexPath.row];
}

/**
 * 返回第section组的所有评论数组
 */
- (NSArray *)commentsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.hotComments.count ? self.hotComments : self.latestComments;
    }
    return self.latestComments;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
    } else {
        // 被点击的cell
        JYJCommentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        // 出现第一响应者
        [cell becomeFirstResponder];
        
        // 显示MenuController
        UIMenuItem *ding = [[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)];
        UIMenuItem *replay = [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(replay:)];
        UIMenuItem *report = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(report:)];
        menu.menuItems = @[ding, replay, report];
        CGRect rect = CGRectMake(0, cell.height * 0.5, cell.width, cell.height * 0.5);
        [menu setTargetRect:rect inView:cell];
        [menu setMenuVisible:YES animated:YES];
    }
}

#pragma mark - MenuItem处理
- (void)ding:(UIMenuController *)menu
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"%s %@", __func__, [self commentInIndexPath:indexPath].content);
}

- (void)replay:(UIMenuController *)menu
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"%s %@", __func__, [self commentInIndexPath:indexPath].content);
}

- (void)report:(UIMenuController *)menu
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"%s %@", __func__, [self commentInIndexPath:indexPath].content);
}

@end
