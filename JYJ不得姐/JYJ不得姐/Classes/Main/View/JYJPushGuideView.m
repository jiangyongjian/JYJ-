//
//  JYJPushGuideView.m
//  JYJ不得姐
//
//  Created by JYJ on 16/5/16.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJPushGuideView.h"


@interface JYJPushGuideView ()

@end
@implementation JYJPushGuideView

+ (instancetype)guideView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

+ (void)show {
    NSString *key = @"CFBundleShortVersionString";
    // 获取当前软件版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    // 获取沙盒中存储的版本号
    NSString *sanboxVersion = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    if (![currentVersion isEqualToString:sanboxVersion]) {
        UIWindow *window = JYJKeyWindow;
        JYJPushGuideView *guideView = [JYJPushGuideView guideView];
        guideView.frame = window.bounds;
        [window addSubview:guideView];
        
        // 存储版本号
        [JYJUserDefaults setObject:currentVersion forKey:key];
        [JYJUserDefaults synchronize];
    }
}

- (IBAction)close {
    [self removeFromSuperview];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
