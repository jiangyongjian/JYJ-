//
//  JYJEssenceViewController.m
//  JYJ不得姐
//
//  Created by JYJ on 16/3/30.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJEssenceViewController.h"
#import "JYJRecommendTagsViewController.h"
#import "JYJBackViewCell.h"
#import "JYJAllViewController.h"
#import "JYJVideoViewController.h"
#import "JYJVoiceViewController.h"
#import "JYJPictureViewController.h"
#import "JYJWordViewController.h"

@interface JYJEssenceViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
/** 标签栏底部的红色指示器 */
@property (nonatomic, weak) UIView *indicatorView;
/** 当前选择的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;
/** 顶部的所有标签 */
@property (nonatomic, weak) UIView *titlesView;
/** collectionView */
@property (nonatomic, weak) UICollectionView *collectionView;
/** 标题数组 */
@property (nonatomic, strong) NSArray *titlesArray;
/** 控制器对应的字典 */
@property (nonatomic, strong) NSMutableDictionary *controllersDict;
/** 控制器缓存池 */
@property (nonatomic, strong) NSMutableDictionary *controllerCache;
@end

@implementation JYJEssenceViewController
/** 重用cell ID */
static NSString *const CollectionCell = @"CollectionCell";

- (NSMutableDictionary *)controllerCache {
    if (_controllerCache == nil) {
        _controllerCache = [[NSMutableDictionary alloc] init];
    }
    return _controllerCache;
}

- (NSMutableDictionary *)controllersDict {
    if (_controllersDict == nil) {
        NSMutableArray *objectsArray = [[NSMutableArray alloc] initWithObjects:[JYJAllViewController class], [JYJVideoViewController class], [JYJVoiceViewController class], [JYJPictureViewController class], [JYJWordViewController class], nil];
        NSMutableArray *keysArray = [[NSMutableArray alloc] initWithObjects:@"全部全部", @"视频", @"声音", @"图片", @"段子", nil];
        _controllersDict = [[NSMutableDictionary alloc] initWithObjects:objectsArray forKeys:keysArray];
    }
    return _controllersDict;
}

/**
 *  标题数组
 */
- (NSArray *)titlesArray {
    if (!_titlesArray) {
        self.titlesArray = @[@"全部全部", @"视频", @"声音", @"图片", @"段子"];
    }
    return _titlesArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航栏
    [self setupNav];
    
    // 设置顶部的标签栏
    [self setupTitlesView];
    
    // 创建底部scrollView
    [self setupContentView];
}

/**
 *  设置顶部的标签栏
 */
- (void)setupTitlesView {
    // 标签栏整体
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    titlesView.frame = CGRectMake(0, JYJNavigationBarH, JYJScreenW, JYJTitilesViewH);
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;

    // 底部的红色指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [UIColor redColor];
    indicatorView.height = 2;
    indicatorView.y = titlesView.height - indicatorView.height;
    self.indicatorView = indicatorView;
    
    CGFloat width = titlesView.width / self.titlesArray.count;
    CGFloat height = titlesView.height;
    for (int i = 0; i < self.titlesArray.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.height = height;
        button.width = width;
        button.x = i * width;
        [button setTitle:self.titlesArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:button];
        
        if (i == 0) {
            button.enabled = NO;
            self.selectedButton = button;
            
            // 让按钮内部的label根据文字内容来计算尺寸
            [button.titleLabel sizeToFit];
            self.indicatorView.width = button.titleLabel.width;
            self.indicatorView.centerX = button.centerX;
        }
    }
    [titlesView addSubview:indicatorView];
}


/**
 *  设置导航栏
 */
- (void)setupNav {
    // 设置导航栏标题
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    // 设置导航栏左边的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"MainTagSubIcon" highImageName:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
    
    // 设置背景色
    self.view.backgroundColor = JYJGlobalBg;
}

#pragma mark - 私有方法
/**
 *  标签点击
 */
- (void)tagClick
{
    JYJRecommendTagsViewController *tags = [[JYJRecommendTagsViewController alloc] init];
    [self.navigationController pushViewController:tags animated:YES];
}

/**
 *  按钮点击
 */
- (void)titleClick:(UIButton *)button {
    // 修改按钮状态
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    
    NSUInteger index = [self.titlesArray indexOfObject:button.titleLabel.text];
    // 让底部的内容scrollView滚动到对应位置
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    [self scrollViewDidEndScrollingAnimation:self.collectionView];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.width = button.titleLabel.width;
        self.indicatorView.centerX = button.centerX;
    }];
}

/**
 *  底部的scrollView
 */
- (void)setupContentView {
    self.automaticallyAdjustsScrollViewInsets = NO;

    // 创建一个流水布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //cell间距
    flowLayout.minimumInteritemSpacing = 0;
    //cell行距
    flowLayout.minimumLineSpacing = 0;
    // 修改属性
    flowLayout.itemSize = self.view.bounds.size;
    // 创建collectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    // 注册一个cell
    [collectionView registerClass:[JYJBackViewCell class] forCellWithReuseIdentifier:CollectionCell];
    collectionView.backgroundColor = JYJGlobalBg;
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    // 设置数据源对象
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view insertSubview:collectionView atIndex:0];
    self.collectionView = collectionView;
}

#pragma mark --- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titlesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 1. 创建一个Cell
    JYJBackViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionCell forIndexPath:indexPath];
    cell.backgroundColor = JYJGlobalBg;
    
    // 将上一个控制器的view移除
    [cell.showsVc.view removeFromSuperview];
    // 根据标题去缓存池获得对应的需要显示控制器
    UITableViewController *showsVc = [self showsVc:self.titlesArray[indexPath.item]];
    cell.showsVc = showsVc;
    // 2. 返回一个Cell
    return cell;
}

/**
 *  根据文字获得对应的需要显示控制器
 */
- (UITableViewController *)showsVc:(NSString *)titile {
    UITableViewController *showsVc = self.controllerCache[titile];
    if (showsVc == nil) {
        // 创建控制器
        // 所有
        UITableViewController *typeVc = [[[self.controllersDict objectForKey:titile] alloc] init];
        // 将产品列表控制器添加到缓冲池中
        [self.controllerCache setObject:typeVc forKey:titile];
        return typeVc;
    }
    return showsVc;
}


#pragma mark - UIScrollViewDelegate
/**
 * scrollView结束了滚动动画以后就会调用这个方法（比如- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;方法执行的动画完毕后）
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
//    // 一些临时变量
//    CGFloat width = self.collectionView.frame.size.width;
//    CGFloat offsetX = self.collectionView.contentOffset.x;
//    
//    // 当前位置需要显示的控制器的索引
//    NSInteger index = offsetX / width;    
}

/**
 * 手指松开scrollView后，scrollView停止减速完毕就会调用这个
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
    // 一些临时变量
    CGFloat width = self.collectionView.frame.size.width;
    CGFloat offsetX = self.collectionView.contentOffset.x;
    
    // 当前位置需要显示的控制器的索引
    NSInteger index = offsetX / width;
    
    // 选中滚动结束的按钮
    UIButton *titleButton = self.titlesView.subviews[index];
    if (titleButton == self.selectedButton) {
        return;
    }
    [self titleClick:titleButton];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = scrollView.frame.size.width;
    CGFloat offsetX = scrollView.contentOffset.x;
    // 当前位置需要显示的控制器的索引
    NSInteger index = offsetX / width;
    JYJLog(@"%zd", index);
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
