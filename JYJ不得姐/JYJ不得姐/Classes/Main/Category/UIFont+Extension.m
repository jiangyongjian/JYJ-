//
//  UIFont+Extension.m
// JYJInsurenceBroker
//
//  Created by JYJ on 16/2/23.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "UIFont+Extension.h"

@implementation UIFont (Extension)
+ (UIFont *)fontWithDevice:(CGFloat)fontSize {
    if (JYJScreenW > 375) {
        fontSize = fontSize + 3;
    }else if (JYJScreenW == 375){
        fontSize = fontSize + 1.5;
    }else if (JYJScreenW == 320){
        fontSize = fontSize;
    }
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    return font;
}

+ (UIFont *)navItemFontWithDevice:(CGFloat)fontSize {
    if (JYJScreenW > 375) {
        fontSize = fontSize + 2;
    }else if (JYJScreenW == 375){
        fontSize = fontSize + 1;
    }else if (JYJScreenW == 320){
        fontSize = fontSize;
    }
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    return font;
}

+ (UIFont *)fontWithTwoLine:(CGFloat)fontSize {
    if (JYJScreenW > 375) {
        fontSize = fontSize + 2;
    }else if (JYJScreenW == 375){
        fontSize = fontSize + 1;
    }else if (JYJScreenW == 320){
        fontSize = fontSize;
    }
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    return font;
}

+ (UIFont *)insuranceCellFont:(CGFloat)fontSize {
    if (JYJScreenW > 375) {
        fontSize = fontSize + 3.5;
    }else if (JYJScreenW == 375){
        fontSize = fontSize + 2;
    }else if (JYJScreenW == 320){
        fontSize = fontSize;
    }
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    return font;
}

@end
