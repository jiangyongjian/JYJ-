//
//  JYJRecommendCategory.m
//  JYJ不得姐
//
//  Created by JYJ on 16/4/2.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJRecommendCategory.h"

@implementation JYJRecommendCategory
- (NSMutableArray *)users
{
    if (!_users) {
        _users = [NSMutableArray array];
    }
    return _users;
}
@end
