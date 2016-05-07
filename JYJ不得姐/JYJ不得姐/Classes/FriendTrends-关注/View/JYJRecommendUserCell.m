//
//  JYJRecommendUserCell.m
//  JYJ不得姐
//
//  Created by JYJ on 16/4/18.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJRecommendUserCell.h"
#import "JYJRecommendUser.h"
#import "UIImageView+WebCache.h"

@interface JYJRecommendUserCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;

@end

@implementation JYJRecommendUserCell

- (void)awakeFromNib {
    
}

- (void)setUser:(JYJRecommendUser *)user {
    _user = user;
    self.screenNameLabel.text = user.screen_name;
    
    NSString *fansCount = nil;
    if (user.fans_count < 10000) {
        fansCount = [NSString stringWithFormat:@"%zd人关注", user.fans_count];
    } else { // 大于等于10000
        fansCount = [NSString stringWithFormat:@"%.1f万人关注", user.fans_count / 10000.0];
    }
    self.fansCountLabel.text = fansCount;
    
    [self.headerImageView setHeader:user.header];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
