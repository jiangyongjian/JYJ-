//
//  JYJTopic.m
//  JYJ不得姐
//
//  Created by JYJ on 16/5/20.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJTopic.h"
#import "MJExtension.h"

@implementation JYJTopic
{
    CGFloat _cellHeight;
    CGRect _pictureF;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"small_image" : @"image0",
             @"large_image" : @"image1",
             @"middle_image" : @"image2"
             };
}


- (NSString *)create_time
{
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置日期格式(y:年,M:月,d:日,H:时,m:分,s:秒)
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 帖子的创建时间
    NSDate *create = [fmt dateFromString:_create_time];
    
    if (create.isThisYear) { // 今年
        if (create.isToday) { // 今天
            NSDateComponents *cmps = [[NSDate date] deltaFrom:create];
            
            if (cmps.hour >= 1) { // 时间差距 >= 1小时
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1) { // 1小时 > 时间差距 >= 1分钟
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else { // 1分钟 > 时间差距
                return @"刚刚";
            }
        } else if (create.isYesterday) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:create];
        } else { // 其他
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:create];
        }
    } else { // 非今年
        return _create_time;
    }
}

- (CGFloat)cellHeight {

    if (!_cellHeight) {
        
        // 文字的最大尺寸
        CGSize maxSize = CGSizeMake(JYJScreenW - 4 * JYJTopicCellMargin, MAXFLOAT);
        
        CGFloat textH = [self.text sizeWithFont:[UIFont systemFontOfSize:14] maxSize:maxSize].height;
        
        //cell的高度
        _cellHeight = JYJTopicCellTextY + textH + JYJTopicCellMargin;
        
        // 根据段子的类型来计算cell的高度
        if (self.type == JYJTopicTypePicture) { // 图片帖子
            // 图片显示出来的宽度
            CGFloat pictureW = maxSize.width;
            // 显示显示出来的高度
            CGFloat pictureH = pictureW * self.height / self.width;
            
            if (pictureH >= JYJTopicCellPictureMaxH) {
                pictureH = JYJTopicCellPictureBreakH;
                self.bigPicture = YES; // 大图
            }
            
            // 计算图片控件的frame
            CGFloat pictureX = JYJTopicCellMargin;
            CGFloat pictureY = JYJTopicCellTextY + textH + JYJTopicCellMargin;
            _pictureF = CGRectMake(pictureX, pictureY, pictureW, pictureH);
            _cellHeight += pictureH + JYJTopicCellMargin;
        } else if (self.type == JYJTopicTypeVoice) { // 声音帖子
            
        }
        
        // 底部工具条的高度
        _cellHeight += JYJTopicCellBottomBarH + JYJTopicCellMargin;
        
    }
    return _cellHeight;
}

@end
