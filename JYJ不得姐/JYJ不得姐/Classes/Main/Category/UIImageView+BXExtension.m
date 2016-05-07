//
//  UIImageView+BXExtension.m
//  JYJ不得姐
//
//  Created by JYJ on 16/5/4.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "UIImageView+BXExtension.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (BXExtension)
- (void)setHeader:(NSString *)url
{
    UIImage *placeholder = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = image ? [image circleImage] : placeholder;
    }];
}

@end
