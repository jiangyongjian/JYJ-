//
//  JYJTextView.h
//  BaoXianDaiDai
//
//  Created by JYJ on 15/9/10.
//  Copyright (c) 2015年 baobeikeji.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYJTextView : UITextView
/** 占位文字 */
@property (nonatomic, copy) NSString *placehoder;
/** 占位文字的颜色 */
@property (nonatomic, strong) UIColor *placehoderColor;
@end
