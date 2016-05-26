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
#import "JYJTopicVoiceView.h"
#import "JYJTopicVideoView.h"
#import "JYJComment.h"
#import "JYJUser.h"

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
/** 声音帖子中间的内容 */
@property (nonatomic, weak) JYJTopicVoiceView *voiceView;
/** 视频帖子中间的内容 */
@property (nonatomic, weak) JYJTopicVideoView *videoView;

/** 最热评论的内容 */
@property (weak, nonatomic) IBOutlet UILabel *topCmtContentLabel;
/** 最热评论的整体 */
@property (weak, nonatomic) IBOutlet UIView *topCmtView;
@end

@implementation JYJTopicCell

+ (instancetype)cell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

- (JYJTopicPictureView *)picPictureView {
    if (!_picPictureView) {
        JYJTopicPictureView *picPictureView = [JYJTopicPictureView pictureView];
        [self.contentView addSubview:picPictureView];
        self.picPictureView = picPictureView;
    }
    return _picPictureView;
}

- (JYJTopicVoiceView *)voiceView {
    if (!_voiceView) {
        JYJTopicVoiceView *voiceView = [JYJTopicVoiceView voiceView];
        [self.contentView addSubview:voiceView];
        self.voiceView = voiceView;
    }
    return _voiceView;
}

- (JYJTopicVideoView *)videoView {
    if (!_videoView) {
        JYJTopicVideoView *videoView = [JYJTopicVideoView videoView];
        [self.contentView addSubview:videoView];
        self.videoView = videoView;
    }
    return _videoView;
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
    [self.profileImageView setHeader:topic.profile_image];
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
        self.picPictureView.hidden = NO;
        self.picPictureView.topic = topic;
        self.picPictureView.frame = topic.pictureF;

        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
    } else if (topic.type == JYJTopicTypeVoice) { // 声音帖子
        self.voiceView.hidden = NO;
        self.voiceView.topic = topic;
        self.voiceView.frame = topic.voiceF;
        
        self.picPictureView.hidden = YES;
        self.videoView.hidden = YES;
    } else if (topic.type == JYJTopicTypeVideo) { // 视频帖子
        self.videoView.hidden = NO;
        self.videoView.topic = topic;
        self.videoView.frame = topic.videoF;
        
        self.picPictureView.hidden = YES;
        self.voiceView.hidden = YES;
    } else { // 段子帖子
        self.picPictureView.hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
    }
    
    // 处理最热评论
    if (topic.top_cmt) {
        self.topCmtView.hidden = NO;
        self.topCmtContentLabel.text = [NSString stringWithFormat:@"%@ : %@", topic.top_cmt.user.username, topic.top_cmt.content];
    } else {
        self.topCmtView.hidden = YES;
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

//    frame.origin.x = JYJTopicCellMargin;
//    frame.size.width -= 2 * JYJTopicCellMargin;
//    frame.size.height -= JYJTopicCellMargin;
    frame.size.height = self.topic.cellHeight - JYJTopicCellMargin;
    frame.origin.y += JYJTopicCellMargin;
    [super setFrame:frame];
}
- (IBAction)more {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"收藏", @"举报", nil];
    [sheet showInView:self.window];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
