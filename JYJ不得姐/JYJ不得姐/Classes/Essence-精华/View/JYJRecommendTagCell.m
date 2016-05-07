//
//  JYJRecommendTagCell.m
//  JYJ不得姐
//
//  Created by JYJ on 16/5/7.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJRecommendTagCell.h"
#import "JYJRecommendTag.h"
#import "UIImageView+WebCache.h"

@interface JYJRecommendTagCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageListImageView;
@property (weak, nonatomic) IBOutlet UILabel *themeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subNumberLabel;

@end

@implementation JYJRecommendTagCell

- (void)setRecommendTag:(JYJRecommendTag *)recommendTag {
    _recommendTag = recommendTag;
    
//    [self.imageListImageView sd_setImageWithURL:[NSURL URLWithString:recommendTag.image_list] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    [self.imageListImageView setHeader:recommendTag.image_list];
    self.themeNameLabel.text = recommendTag.theme_name;
    
    JYJLog(@"%zd", recommendTag.sub_number);
    NSString *subNumber = nil;
    if (recommendTag.sub_number < 10000) {
        subNumber = [NSString stringWithFormat:@"%zd人订阅", recommendTag.sub_number];
    } else {
        subNumber = [NSString stringWithFormat:@"%.1f万人订阅", recommendTag.sub_number / 10000.0];
    }
    self.subNumberLabel.text = subNumber;
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x = 5;
    frame.size.width -= 2 * frame.origin.x;
    frame.size.height -= 1;
    [super setFrame:frame];
}

@end
