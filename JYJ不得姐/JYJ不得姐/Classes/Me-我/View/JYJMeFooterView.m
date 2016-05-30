//
//  JYJMeFooterView.m
//  JYJ不得姐
//
//  Created by JYJ on 16/5/26.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJMeFooterView.h"
#import "AFNetworking.h"
#import "JYJSquare.h"
#import "JYJSquareButton.h"
#import "MJExtension.h"
#import "JYJWebViewController.h"

@implementation JYJMeFooterView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        // 参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"a"] = @"square";
        params[@"c"] = @"topic";
        
        // 发送请求
        [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *squares = [JYJSquare mj_objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
            NSMutableDictionary *dicts = [[NSMutableDictionary alloc] init];
            for (JYJSquare *square in squares) {
                [dicts setObject:square forKey:square.name];
            }
            
           
            NSMutableArray *keys = [NSMutableArray arrayWithArray:dicts.allValues];
            [keys sortUsingComparator:^NSComparisonResult(JYJSquare *obj1, JYJSquare *obj2) {
                return obj2.ID - obj1.ID;
            }];

            squares = keys;
            // 创建方块
            [self createSquares:squares];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    return self;
}

/**
 *  创建方块
 */
- (void)createSquares:(NSArray *)suqares {
    
    // 一行最多4列
    int maxCols = 4;
    
    // 宽度和高度
    CGFloat buttonW = JYJScreenW / maxCols;
    CGFloat buttonH = buttonW;
    
    for (int i = 0; i < suqares.count; i++) {
//        JYJLog(@"%@",[suqares[i] name]);
        
        // 创建按钮
        JYJSquareButton *button = [JYJSquareButton buttonWithType:UIButtonTypeCustom];
        // 监听按钮点击
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        // 传递模型
        button.suqare = suqares[i];
        [self addSubview:button];
        
        // 计算frame
        int col = i % maxCols;
        int row = i / maxCols;
        
        button.x = col * buttonW;
        button.y = row * buttonH;
        button.width = buttonW;
        button.height = buttonH;
    }
    
    // 总页数 = (总个数 + 每页的最大数 - 1) / 每页最大数
    NSUInteger rows = (suqares.count + maxCols - 1) / maxCols;
    
    // 计算footer的高度
    self.height = rows * buttonH;
    [self setNeedsLayout];
    if ([self.delegate respondsToSelector:@selector(meFooterViewDidLoadDate:)]) {
        [self.delegate meFooterViewDidLoadDate:self];
    }
}

- (void)buttonClick:(JYJSquareButton *)button {
    if (![button.suqare.url hasPrefix:@"http"]) return;
    
    JYJWebViewController *web = [[JYJWebViewController alloc] init];
    web.url = button.suqare.url;
    web.title = button.suqare.name;
    
    // 取出导航控制器
    UITabBarController *tabar = JYJRootTabBarController;
    [(UINavigationController *)tabar.selectedViewController pushViewController:web animated:YES];
}

@end
