//
//  JYJSquare.h
//  JYJ不得姐
//
//  Created by JYJ on 16/5/26.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYJSquare : NSObject
/** 图片 */
@property (nonatomic, copy) NSString *icon;
/** 标题文字 */
@property (nonatomic, copy) NSString *name;
/** 链接 */
@property (nonatomic, copy) NSString *url;

/** id */
@property (nonatomic, assign) NSInteger ID;
@end
