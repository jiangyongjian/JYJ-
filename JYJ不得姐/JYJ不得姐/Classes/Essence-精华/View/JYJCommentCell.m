//
//  JYJCommentCell.m
//  JYJ不得姐
//
//  Created by JYJ on 16/5/25.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJCommentCell.h"
#import "JYJComment.h"
#import "UIImageView+WebCache.h"
#import "JYJUser.h"

@interface JYJCommentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;

@end

@implementation JYJCommentCell

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = bgView;
}

- (void)setComment:(JYJComment *)comment {
    _comment = comment;
    
    [self.profileImageView setHeader:comment.user.profile_image];
    
    self.sexView.image = [comment.user.sex isEqualToString:JYJGUserSexMale] ? [UIImage imageNamed:@"Profile_manIcon"] : [UIImage imageNamed:@"Profile_womanIcon"];
    self.contentLabel.text = comment.content;
    self.usernameLabel.text = comment.user.username;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%zd", comment.like_count];
    
    if (comment.voiceuri.length) {
        self.voiceButton.hidden = NO;
        [self.voiceButton setTitle:[NSString stringWithFormat:@"%zd''", comment.voicetime] forState:UIControlStateNormal];
    } else {
        self.voiceButton.hidden = YES;
    }
    
}

//- (void)setFrame:(CGRect)frame {
//    frame.origin.x = JYJTopicCellMargin;
//    frame.size.width -= 2 * JYJTopicCellMargin;
//    [super setFrame:frame];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
