//
//  JYJTabBar.m
//  JYJ不得姐
//
//  Created by JYJ on 16/3/31.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJTabBar.h"
#import "JYJPublishViewController.h"
#import "JYJPublishView.h"

@interface JYJTabBar ()
/** 发布按钮 */
@property (nonatomic, weak) UIButton *publishButton;
@end

@implementation JYJTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 设置tabBar的背景图片
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
        
        UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        [publishButton addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
        publishButton.size = publishButton.currentBackgroundImage.size;
        [self addSubview:publishButton];
        self.publishButton = publishButton;
    }
    return self;
}

- (void)publishClick {
//    JYJPublishViewController *publish = [[JYJPublishViewController alloc] init];
//    [JYJKeyWindow.rootViewController presentViewController:publish animated:NO completion:nil];
//    JYJPublishView *publish = [JYJPublishView publishView];
//    publish.frame = JYJKeyWindow.bounds;
//    [JYJKeyWindow addSubview:publish];
    [JYJPublishView show];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 标记是否已经添加过监听器
    // 静态变量 后面改了前面也会改，只分配一个内存
    static BOOL added = NO;
    
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    // 设置发布按钮的frame
    self.publishButton.center = CGPointMake(width * 0.5, height * 0.5);
    
    // 设置其他UITabBarButton的frame
    CGFloat buttonY = 0;
    CGFloat buttonW = width / 5;
    CGFloat buttonH = height;
    NSInteger index = 0;
    for (UIControl *button in self.subviews) {
        if (![button isKindOfClass:[UIControl class]] || button == self.publishButton) continue;
        // 计算按钮的X值
        CGFloat buttonX = buttonW * ((index > 1)?(index + 1):index);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        // 增加索引
        index++;
        
        if (added == NO) {
            // 监听按钮点击
            [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    added = YES;
}

- (void)buttonClick {
    // 发出一个通知
    [JYJNoteCenter postNotificationName:JYJTabBarDidSelectNotification object:nil userInfo:nil];
}

@end
