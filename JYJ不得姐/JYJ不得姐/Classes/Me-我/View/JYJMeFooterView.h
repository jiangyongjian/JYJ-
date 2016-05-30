//
//  JYJMeFooterView.h
//  JYJ不得姐
//
//  Created by JYJ on 16/5/26.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JYJMeFooterView;
@protocol JYJMeFooterViewDelegate <NSObject>

@optional
- (void)meFooterViewDidLoadDate:(JYJMeFooterView *)meFooterView;

@end
@interface JYJMeFooterView : UIView
/** 代理 */
@property (nonatomic, weak) id<JYJMeFooterViewDelegate> delegate;
@end
