//
//  JYJTopicCell.m
//  JYJ不得姐
//
//  Created by JYJ on 16/5/21.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJTopicCell.h"
#import "JYJTopic.h"
#import "UIImageView+WebCache.m"
#import "JYJTopicPictureView.h"

@interface JYJTopicCell ()
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
/** 昵称 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 时间 */
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
/** 顶 */
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
/** 踩 */
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
/** 分享 */
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
/** 评论 */
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
/** 新浪加V */
@property (weak, nonatomic) IBOutlet UIImageView *sinaVView;
/** 帖子的文字内容 */
@property (weak, nonatomic) IBOutlet UILabel *text_label;
/** 图片帖子中间的内容 */
@property (nonatomic, weak) JYJTopicPictureView *picPictureView;
@end

@implementation JYJTopicCell

- (JYJTopicPictureView *)picPictureView {
    if (!_picPictureView) {
        JYJTopicPictureView *picPictureView = [JYJTopicPictureView pictureView];
        [self.contentView addSubview:picPictureView];
        self.picPictureView = picPictureView;
    }
    return _picPictureView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = bgView;
}

- (void)setTopic:(JYJTopic *)topic {
    _topic = topic;
    
    // 新浪加V
    self.sinaVView.hidden = !topic.isSina_v;
    
    // 设置其他控件
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:topic.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.nameLabel.text = topic.name;
    
//    // 日期格式化类
//    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    // 设置日期格式(y:年,M:月,d:日,H:时,m:分,s:秒)
//    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    // 帖子的创建时间
//    NSDate *create = [fmt dateFromString:topic.create_time];
//    self.createTimeLabel.text = [create ff_dateDescription];
    self.createTimeLabel.text = topic.create_time;
    
    
    // 设置按钮文字
    [self setupButtonTitle:self.dingButton count:topic.ding placeholder:@"顶"];
    [self setupButtonTitle:self.caiButton count:topic.cai placeholder:@"踩"];
    [self setupButtonTitle:self.shareButton count:topic.repost placeholder:@"分享"];
    [self setupButtonTitle:self.commentButton count:topic.comment placeholder:@"评论"];
    
    // 设置帖子的文字内容
    self.text_label.text = topic.text;
    
    // 根据模型类型(帖子类型)添加对应的内容到cell的中间
    if (topic.type == JYJTopicTypePicture) { // 图片帖子
        
        self.picPictureView.topic = topic;
        self.picPictureView.frame = topic.pictureF;
    } else if (topic.type == JYJTopicTypeVoice) { // 声音帖子
    
    } else if (topic.type == JYJTopicTypeVideo) { // 视频帖子
    
    } else if (topic.type == JYJTopicTypeAll){ // 全部
    
    }
}

- (void)setupButtonTitle:(UIButton *)button count:(NSUInteger)count placeholder:(NSString *)placeholder {
    if (count > 10000) {
        placeholder = [NSString stringWithFormat:@"%.1f", count / 10000.0];
    } else if (count > 0) {
        placeholder = [NSString stringWithFormat:@"%zd", count];
    }
    button.adjustsImageWhenHighlighted = NO;
    [button setTitle:placeholder forState:UIControlStateNormal];
}

- (void)setFrame:(CGRect)frame {

    frame.origin.x = JYJTopicCellMargin;
    frame.size.width -= 2 * JYJTopicCellMargin;
    frame.size.height -= JYJTopicCellMargin;
    frame.origin.y += JYJTopicCellMargin;
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
