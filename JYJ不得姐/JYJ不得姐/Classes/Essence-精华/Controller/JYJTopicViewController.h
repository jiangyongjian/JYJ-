//
//  JYJTopicViewController.h
//  JYJ不得姐
//
//  Created by JYJ on 16/5/23.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYJTopic.h"

@interface JYJTopicViewController : UITableViewController

- (JYJTopicType)type;

/** 是否是最新控制器 */
@property (nonatomic, assign, getter=isNewVc) BOOL newVc;
@end
