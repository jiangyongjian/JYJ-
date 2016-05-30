//
//  JYJTopWindow.m
//  JYJ不得姐
//
//  Created by JYJ on 16/5/26.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJTopWindow.h"

@implementation JYJTopWindow

/** 20的窗口 */
static UIWindow *window_;
+ (void)initialize {
    window_ = [[UIWindow alloc] init];
    window_.backgroundColor = [UIColor clearColor];
    window_.frame = CGRectMake(0, 0, JYJScreenW, 20);
    window_.windowLevel = UIWindowLevelAlert;
    [window_ addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(windowClick)]];
}


+ (void)show {
    window_.hidden = NO;
}

+ (void)hide {
    window_.hidden = YES;
}

/**
 *  监听窗口的点击
 */
+ (void)windowClick {
    [self searchScrollViewInView:JYJKeyWindow];
}

+ (void)searchScrollViewInView:(UIView *)superView {
    for (UIScrollView *subView in superView.subviews) {
        // 如果是scrollView, 滚动最顶部
        if ([subView isKindOfClass:[UIScrollView class]] && subView.isShowingOnKeyWindow) {
            CGPoint offset = subView.contentOffset;
            offset.y = - subView.contentInset.top;
            [subView setContentOffset:offset animated:YES];
        }
        // 继续查找子控件
        [self searchScrollViewInView:subView];
    }
}
@end
