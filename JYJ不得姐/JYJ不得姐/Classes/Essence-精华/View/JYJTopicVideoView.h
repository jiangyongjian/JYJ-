//
//  JYJTopicVideoView.h
//  JYJ不得姐
//
//  Created by JYJ on 16/5/24.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JYJTopic;
@interface JYJTopicVideoView : UIView
/** 视频模型数据 */
@property (nonatomic, strong) JYJTopic *topic;
+ (instancetype)videoView;
@end
