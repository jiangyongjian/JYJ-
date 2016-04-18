//
//  JYJRecommendCategoryCell.m
//  JYJ不得姐
//
//  Created by JYJ on 16/4/2.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJRecommendCategoryCell.h"
#import "JYJRecommendCategory.h"

@interface JYJRecommendCategoryCell ()
/**
 *  选中时显示的指示器控件
 */
@property (weak, nonatomic) IBOutlet UIView *selectedIndicator;

@end

@implementation JYJRecommendCategoryCell

- (void)awakeFromNib {
    self.backgroundColor = JYJColor(244, 244, 244);
    self.selectedIndicator.backgroundColor = JYJColor(219, 21, 26);
}

- (void)setCategory:(JYJRecommendCategory *)category {
    _category = category;
    self.textLabel.text = category.name;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 重新调整内部的textLabel的frame
    self.textLabel.y = 2;
    self.textLabel.height = self.contentView.height - 2 * self.textLabel.y;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectedIndicator.hidden = !selected;
    self.textLabel.textColor = selected ? self.selectedIndicator.backgroundColor : JYJColor(78, 78, 78);
}

@end
