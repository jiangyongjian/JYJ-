//
//  JYJTagTextField.h
//  JYJ不得姐
//
//  Created by JYJ on 16/5/30.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYJTagTextField : UITextField

/** 按了删除键后回调 */
@property (nonatomic, copy) void (^deleteBlock)();
@end
