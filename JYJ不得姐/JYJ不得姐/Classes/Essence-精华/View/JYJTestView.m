//
//  JYJTestView.m
//  JYJ不得姐
//
//  Created by JYJ on 16/5/7.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJTestView.h"

@implementation JYJTestView

+ (instancetype)testView {
    return [[self alloc] init];
}

- (void)setFrame:(CGRect)frame {
    frame.size = CGSizeMake(100, 100);
    [super setFrame:frame];
}

- (void)setBounds:(CGRect)bounds {
    bounds.size = CGSizeMake(100, 100);
    [super setFrame:bounds];
}

@end
