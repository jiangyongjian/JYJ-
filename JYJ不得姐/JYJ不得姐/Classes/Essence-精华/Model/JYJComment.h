//
//  JYJComment.h
//  JYJ不得姐
//
//  Created by JYJ on 16/5/25.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JYJUser;
@interface JYJComment : NSObject
/** id */
@property (nonatomic, copy) NSString *ID;
/** 音频文件的时长 */
@property (nonatomic, assign) NSInteger voicetime;
/** 音频文件的路径 */
@property (nonatomic, copy) NSString *voiceuri;
/** 评论的文字内容 */
@property (nonatomic, copy) NSString *content;
/** 被点赞的数量 */
@property (nonatomic, assign) NSInteger like_count;
/** 用户 */
@property (nonatomic, strong) JYJUser *user;
@end
