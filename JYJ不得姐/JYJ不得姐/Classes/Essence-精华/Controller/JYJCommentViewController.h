//
//  JYJCommentViewController.h
//  JYJ不得姐
//
//  Created by JYJ on 16/5/25.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JYJTopic;

@interface JYJCommentViewController : UIViewController
/** 模型数据 */
@property (nonatomic, strong) JYJTopic *topic;
@end
