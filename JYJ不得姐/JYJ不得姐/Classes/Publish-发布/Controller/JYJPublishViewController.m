//
//  JYJPublishViewController.m
//  JYJ不得姐
//
//  Created by JYJ on 16/5/24.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJPublishViewController.h"
#import "JYJVerticalButton.h"
#import "POP.h"
#import "JYJPostWordViewController.h"
#import "JYJNavigationController.h"

@interface JYJPublishViewController ()

@end

@implementation JYJPublishViewController

static CGFloat const JYJAnimationDelay = 0.1;
static CGFloat const JYJSpringFactor = 10;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.userInteractionEnabled = NO;
    
    // 添加标语
    UIImageView *sloganView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    [self.view addSubview:sloganView];
    
    // 数据
    NSArray *images = @[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review", @"publish-offline"];
    NSArray *titles = @[@"发视频", @"发图片", @"发段子", @"发声音", @"审帖", @"离线下载"];
    
    // 添加中间6个按钮
    int maxCols = 3;
    CGFloat buttonW = 72;
    CGFloat buttonH = buttonW + 30;
    CGFloat buttonStartY = (JYJScreenH - 2 * buttonH) * 0.5;
    CGFloat buttonStartX = 20;
    CGFloat xMargin = (JYJScreenW - 2 * buttonStartX - maxCols * buttonW) / (maxCols - 1);
    for (int i = 0; i < images.count; i++) {
        JYJVerticalButton *button = [[JYJVerticalButton alloc] init];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        // 设置按钮内容
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        
        // 设置按钮frame
        int row = i / maxCols;
        int col = i % maxCols;
        CGFloat buttonX = buttonStartX + col * (xMargin + buttonW);
        CGFloat buttonEndY = buttonStartY + row * buttonH;
        CGFloat buttonBeginY = buttonEndY - JYJScreenH;
        button.frame = CGRectMake(buttonX, buttonBeginY, buttonW, buttonH);
        // 按钮动画
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.fromValue = [NSValue valueWithCGRect:button.frame];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonEndY, buttonW, buttonH)];
        anim.springSpeed = JYJSpringFactor;
        anim.springBounciness = JYJSpringFactor;
        anim.beginTime = CACurrentMediaTime() + JYJAnimationDelay * i;
        [button pop_addAnimation:anim forKey:nil];
    }
    
    // 添加标语动画
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    CGFloat centerX = JYJScreenW * 0.5;
    CGFloat centerEndY = JYJScreenH * 0.2;
    CGFloat centerBeginY = centerEndY - JYJScreenH;
    sloganView.center = CGPointMake(centerX, centerBeginY);
    anim.fromValue = [NSValue valueWithCGPoint:sloganView.center];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerEndY)];
    anim.beginTime = CACurrentMediaTime() + JYJAnimationDelay * images.count;
    anim.springSpeed = JYJSpringFactor;
    anim.springBounciness = JYJSpringFactor;
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        // 标语动画执行完毕，恢复点击事件
        self.view.userInteractionEnabled = YES;
    }];
    [sloganView pop_addAnimation:anim forKey:nil];
}



- (IBAction)cancel {
    [self cancelWithCompletetionBlock:nil];
}




- (void)buttonClick:(UIButton *)button {
    [self cancelWithCompletetionBlock:^{
        if (button.tag == 0) {
            JYJLog(@"发视频");
        } else if (button.tag == 1) {
            JYJLog(@"发图片");
        } else if (button.tag == 2) {
            JYJPostWordViewController *postWord = [[JYJPostWordViewController alloc] init];
            JYJNavigationController *nav = [[JYJNavigationController alloc] initWithRootViewController:postWord];
            [JYJKeyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
        }
    }];
}

/**
 *  先执行退去动画，动画完毕后执行completionBlock
 */
- (void)cancelWithCompletetionBlock:(void(^)())completionBloack {
    // 让控制器的view不能被点击
    self.view.userInteractionEnabled = NO;
    
    int beginIndex = 2;
    NSUInteger count = self.view.subviews.count;
    for (int i = beginIndex; i < count; i++) {
        UIView *subView = self.view.subviews[count - i + 1];
        JYJLog(@"%@", subView);
        
        // 基本动画
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        CGFloat centerY = subView.centerY + JYJScreenH;
        
        // 动画的执行节奏（一开始很慢，后面很快）
//        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(subView.centerX, centerY)];
        anim.beginTime = CACurrentMediaTime() + (i - beginIndex) * JYJAnimationDelay;
        [subView pop_addAnimation:anim forKey:nil];
        
        // 监听最后一个动画
        if (beginIndex == count - i + 1) {
            [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                [self dismissViewControllerAnimated:NO completion:nil];
                // 执行传进来的completionBloack参数
//                if (completionBloack) {
//                    completionBloack();
//                }
                !completionBloack ? : completionBloack();
            }];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self cancelWithCompletetionBlock:nil];
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
