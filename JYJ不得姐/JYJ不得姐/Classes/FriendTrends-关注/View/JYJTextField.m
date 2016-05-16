//
//  JYJTextField.m
//  JYJ不得姐
//
//  Created by JYJ on 16/5/11.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJTextField.h"
#import <objc/runtime.h>


static NSString *const JYJPlacerholderColorKeyPath = @"_placeholderLabel.textColor";
@implementation JYJTextField

//- (void)awakeFromNib {
//    // 设置光标的颜色和文字颜色一致
//    self.tintColor = self.textColor;
//    
//    // 不成为第一响应者
//    [self resignFirstResponder];
//}


+ (void)initialize {
    [self getIvars];
}

+ (void)getProperties {
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([UITextField class], &count);
    
    for (int i = 0; i < count; i++) {
        // 取出属性
        objc_property_t property = properties[i];
        
        // 打印属性名字
        JYJLog(@"%s --- %s", property_getName(property), property_getAttributes(property));
    }
    free(properties);
}

+ (void)getIvars {
    unsigned int count = 0;
    // 拷贝出所有的成员变量列表
    Ivar *ivars = class_copyIvarList([UITextField class], &count);
    
    for (int i = 0; i < count; i++) {
        // 取出成员变量
        Ivar ivar = ivars[i];
        // 打印成员变量名称
        NSLog(@"%s -- %s", ivar_getName(ivar), ivar_getTypeEncoding(ivar));
    }
    // 释放
    free(ivars);
}

- (void)awakeFromNib {
//    UILabel *placeholderLabel = [self valueForKeyPath:@"_placeholderLabel"];
//    placeholderLabel.textColor = [UIColor redColor];
    
//    // 修改占位文字颜色
//    [self setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
//    
    // 设置光标颜色和文字颜色一致
    self.tintColor = self.textColor;
    
    // 不成为第一响应者
    [self resignFirstResponder];
}

/**
 *  当前文本框聚焦时就会调用
 */
- (BOOL)becomeFirstResponder {
    // 修改占位文字的颜色
    [self setValue:self.textColor forKeyPath:JYJPlacerholderColorKeyPath];
    return [super becomeFirstResponder];
}
/**
 *  当前文本框失去焦点时就会调用
 */
- (BOOL)resignFirstResponder {
    // 修改占位文字的颜色
    [self setValue:[UIColor grayColor] forKeyPath:JYJPlacerholderColorKeyPath];
    return [super resignFirstResponder];
}




@end
