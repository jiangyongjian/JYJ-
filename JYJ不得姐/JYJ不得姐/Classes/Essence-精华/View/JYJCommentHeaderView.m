//
//  JYJCommentHeaderView.m
//  JYJ不得姐
//
//  Created by JYJ on 16/5/25.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJCommentHeaderView.h"

@interface JYJCommentHeaderView ()
/** 文字标签 */
@property (nonatomic, weak) UILabel *label;
@end

@implementation JYJCommentHeaderView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView {
    static NSString *ID = @"header";
    JYJCommentHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) { // 缓存池中没有，自己创建
        header = [[JYJCommentHeaderView alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = JYJGlobalBg;
        
        // 创建label
        UILabel *label = [[UILabel alloc] init];
        label.textColor = JYJColor(67, 67, 67);
        label.width = 200;
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:label];
        self.label = label;
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.label.text = title;
}

@end
