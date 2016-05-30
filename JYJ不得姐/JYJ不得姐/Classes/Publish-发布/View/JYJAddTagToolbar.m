//
//  JYJAddTagToolbar.m
//  JYJ不得姐
//
//  Created by JYJ on 16/5/27.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJAddTagToolbar.h"
#import "JYJAddTagViewController.h"

@interface JYJAddTagToolbar ()
/** 顶部控件 */
@property (weak, nonatomic) IBOutlet UIView *topView;
/** 添加按钮 */
@property (nonatomic, weak) UIButton *addButton;
/** 存放所有的标签Label */
@property (nonatomic, strong) NSMutableArray *tagLabels;
@end

@implementation JYJAddTagToolbar

- (NSMutableArray *)tagLabels {
    if (!_tagLabels) {
        _tagLabels = [NSMutableArray array];
    }
    return _tagLabels;
}

- (void)awakeFromNib {
    // 添加一个加号按钮
    UIButton *addButton = [[UIButton alloc] init];
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [addButton setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
    addButton.size = addButton.currentImage.size;
    addButton.x = JYJTagMargin;
    [self.topView addSubview:addButton];
    self.addButton = addButton;
    
    // 默认就拥有2个标签
    [self createTagLabels:@[@"吐槽", @"糗事"]];
}

- (void)addButtonClick {
    JYJAddTagViewController *vc = [[JYJAddTagViewController alloc] init];
    JYJWeakSelf;
    [vc setTagsBlock:^(NSArray *tags) {
        [weakSelf createTagLabels:tags];
    }];
    vc.tags = [self.tagLabels valueForKeyPath:@"text"];
    [(UINavigationController *)JYJKeyWindow.rootViewController.presentedViewController pushViewController:vc animated:YES];
}

/**
 *  创建标签
 */
- (void)createTagLabels:(NSArray *)tags {
    // 为了不重复
    [self.tagLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tagLabels removeAllObjects];
    
    for (int i = 0; i < tags.count; i++) {
        UILabel *tagLabel = [[UILabel alloc] init];
        [self.tagLabels addObject:tagLabel];
        tagLabel.backgroundColor = JYJTagBg;
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.text = tags[i];
        tagLabel.font = JYJTagFont;
        // 应该要先设置文字很字体后，在进行计算
        [tagLabel sizeToFit];
        tagLabel.width += 2 * JYJTagMargin;
        tagLabel.height = JYJTagH;
        tagLabel.textColor = [UIColor whiteColor];
        [self.topView addSubview:tagLabel];
    }
    // 重新布局子控件
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (int i = 0; i < self.tagLabels.count; i++) {
        UILabel *tagLabel = self.tagLabels[i];
        
        // 设置位置
        if (i == 0) { // 最前面的标签
            tagLabel.x = 0;
            tagLabel.y = 0;
        } else { // 其他标签
            UILabel *lastTagLabel = self.tagLabels[i - 1];
            // 计算当前行左边的宽度
            CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame) + JYJTagMargin;
            // 计算当前行右边的宽度
            CGFloat rightWidth = self.topView.width - leftWidth;
            if (rightWidth >= tagLabel.width) { // 按钮显示在当前行
                tagLabel.y = lastTagLabel.y;
                tagLabel.x = leftWidth;
            } else { // 按钮显示在下一行
                tagLabel.x = 0;
                tagLabel.y = CGRectGetMaxY(lastTagLabel.frame) + JYJTagMargin;
            }
        }
    }
    
    // 最后一个标签
    UILabel *lastTagLabel = [self.tagLabels lastObject];
    CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame) + JYJTagMargin;
    
    // 更新addButton的frame
    if (self.topView.width - leftWidth >= self.addButton.width) {
        self.addButton.y = lastTagLabel.y;
        self.addButton.x = leftWidth;
    } else {
        self.addButton.x = 0;
        self.addButton.y = CGRectGetMaxY(lastTagLabel.frame) + JYJTagMargin;
    }
    
    // 整体的高度
    CGFloat oldH = self.height;
    self.height = CGRectGetMaxY(self.addButton.frame) + 45;
    self.y -= self.height - oldH;
    
}


@end
