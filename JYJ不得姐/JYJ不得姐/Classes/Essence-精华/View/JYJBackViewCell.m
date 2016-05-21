//
//  JYJBackViewCell.m
//  JYJInsurenceBroker
//
//  Created by JYJ on 16/3/28.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJBackViewCell.h"

@interface JYJBackViewCell ()
/** iconView */
@property (nonatomic, weak) UIImageView *iconView;
@end
@implementation JYJBackViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.contentMode = UIViewContentModeCenter;
    iconView.image = [UIImage imageNamed:@"service_loading_blankpage"];
    [self addSubview:iconView];
    self.iconView = iconView;
}

- (void)setShowsVc:(UIViewController *)showsVc {
    _showsVc = showsVc;
    [self addSubview:showsVc.view];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.iconView.width = 95;
    self.iconView.height = 60;
    self.iconView.x = (self.contentView.width - self.iconView.width) / 2;
    self.iconView.y = (self.contentView.height - self.iconView.height) / 2;
    
    self.showsVc.view.frame = self.contentView.bounds;
}

@end
