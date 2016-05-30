//
//  JYJTagButton.m
//  JYJ不得姐
//
//  Created by JYJ on 16/5/30.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJTagButton.h"

@implementation JYJTagButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
        self.backgroundColor = JYJTagBg;
        self.titleLabel.font = JYJTagFont;
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    [self sizeToFit];
    
    self.width += 3 * JYJTagMargin;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.x = JYJTagMargin;
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + JYJTagMargin;
}


@end
