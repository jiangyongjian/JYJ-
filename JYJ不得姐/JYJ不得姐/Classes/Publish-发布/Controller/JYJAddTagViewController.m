//
//  JYJAddTagViewController.m
//  JYJ不得姐
//
//  Created by JYJ on 16/5/27.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJAddTagViewController.h"
#import "JYJTagButton.h"
#import "SVProgressHUD.h"
#import "JYJTagTextField.h"

@interface JYJAddTagViewController () <UITextFieldDelegate>
/** 内容 */
@property (nonatomic, weak) UIView *contentView;
/** 文本输入框 */
@property (nonatomic, weak) JYJTagTextField *textField;
/** 添加按钮 */
@property (nonatomic, weak) UIButton *addButton;

/** 所有的标签按钮 */
@property (nonatomic, strong) NSMutableArray *tagButtons;

@end

@implementation JYJAddTagViewController
- (NSMutableArray *)tagButtons {
    if (!_tagButtons) {
        self.tagButtons = [NSMutableArray array];
    }
    return _tagButtons;
}
- (UIButton *)addButton {
    if (!_addButton) {
        UIButton *addButton = [[UIButton alloc] init];
        addButton.height = 35;
        [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
        addButton.titleLabel.font = JYJTagFont;
        addButton.contentEdgeInsets = UIEdgeInsetsMake(0, JYJTopicCellMargin, 0, JYJTopicCellMargin);
        // 让按钮内部的文字和图片都左对齐
        addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        addButton.backgroundColor = JYJColor(74, 139, 209);
        [self.contentView addSubview:addButton];
        self.addButton = addButton;
    }
    return _addButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
}

- (void)setupTags {
#warning 做判断是为了防止viewDidLayoutSubviews方法多次调用
    if (self.tags.count > 0) {
        for (NSString *tag in self.tags) {
            self.textField.text = tag;
            [self addButtonClick];
        }
        self.tags = nil;
    }
}

- (JYJTagTextField *)textField {
    if (!_textField) {
        JYJTagTextField *textField = [[JYJTagTextField alloc] init];
        textField.delegate = self;
        JYJWeakSelf;
        textField.deleteBlock = ^{
            if (weakSelf.textField.hasText) return;
            [weakSelf tagButtonClick:[weakSelf.tagButtons lastObject]];
        };
        
        [textField addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
        [textField becomeFirstResponder];
        [self.contentView addSubview:textField];
        self.textField = textField;
    }
    return _textField;
}

- (UIView *)contentView {
    if (!_contentView) {
        UIView *contentView = [[UIView alloc] init];
        [self.view addSubview:contentView];
        self.contentView = contentView;
    }
    return _contentView;
}

- (void)setupNav {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"添加标签";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.contentView.x = JYJTopicCellMargin;
    self.contentView.width = self.view.width - 2 * self.contentView.x;
    self.contentView.y = 64 + JYJTopicCellMargin;
    self.contentView.height = JYJScreenH;
    
    self.textField.width = self.contentView.width;
    
    self.addButton.width = self.contentView.width;
    
    [self setupTags];
}

- (void)done {
    // 传递数据给上一个控制器
    // 传递tags 给这个block
    NSArray *tags = [self.tagButtons valueForKeyPath:@"currentTitle"];

    !self.tagsBlock ? :self.tagsBlock(tags);
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  监听文字改变
 */
- (void)textDidChange {
    // 更新文本框的frame
    [self updateTextFieldFrame];
    
    if (self.textField.hasText) { // 有文字
        // 显示"添加标签"的按钮
        self.addButton.hidden = NO;
        self.addButton.y = CGRectGetMaxY(self.textField.frame) + JYJTopicCellMargin;
        [self.addButton setTitle:[NSString stringWithFormat:@"添加标签: %@", self.textField.text] forState:UIControlStateNormal];
        
        // 获取最后一个字符
        NSString *text = self.textField.text;
        NSUInteger len = text.length;
        NSString *lastLetter = [text substringFromIndex:len - 1];
        if ([lastLetter isEqualToString:@","] || [lastLetter isEqualToString:@"，"]) {
            // 去除逗号
            self.textField.text = [text substringToIndex:len - 1];
            [self addButtonClick];
        }
        
    } else { // 没有文字
        // 隐藏"添加标签"的按钮
        self.addButton.hidden = YES;
    }
}


#pragma mark - 监听按钮点击

/**
 *  监听"添加标签"按钮点击
 */
- (void)addButtonClick {
    
    if (self.tagButtons.count == 5) {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD showErrorWithStatus:@"最多添加5个标签"];
        return;
    }
    
    // 添加一个“标签按钮”
    JYJTagButton *tagButton = [[JYJTagButton alloc] init];
    [tagButton addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [tagButton setTitle:self.textField.text forState:UIControlStateNormal];
    tagButton.height = self.textField.height;
    [self.contentView addSubview:tagButton];
    [self.tagButtons addObject:tagButton];
    
    // 清空textField文字
    self.textField.text = nil;
    self.addButton.hidden = YES;
    
    // 更新标签按钮的frame
    [self updateTagButtonFrame];
    [self updateTextFieldFrame];
}


/**
 *  标签按钮的点击
 */
- (void)tagButtonClick:(JYJTagButton *)tagButton {
    [tagButton removeFromSuperview];
    [self.tagButtons removeObject:tagButton];
    // 重新更新所有标签按钮的frame
    [UIView animateWithDuration:0.25 animations:^{
        [self updateTagButtonFrame];
        [self updateTextFieldFrame];
        self.addButton.y = CGRectGetMaxY(self.textField.frame) + JYJTopicCellMargin;
    }];
}

#pragma mark - 子控件的frame
/**
 *  专门用来更新标签按钮的frame,此处为核心代码
 */
- (void)updateTagButtonFrame {
    // 更新标签按钮的frame
    for (int i = 0; i < self.tagButtons.count; i++) {
        JYJTagButton *tagButton = self.tagButtons[i];
        
        if (i == 0) { // 做前面的标签按钮
            tagButton.x = 0;
            tagButton.y = 0;
        } else { // 其他标签按钮
            JYJTagButton *lastTagButton = self.tagButtons[i - 1];
            // 计算当前行左边的宽度
            CGFloat leftWidth = CGRectGetMaxX(lastTagButton.frame) + JYJTagMargin;
            // 计算当前行右边的宽度
            CGFloat rightWidth = self.contentView.width - leftWidth;
            if (rightWidth >= tagButton.width) { // 按钮显示当前行
                tagButton.y = lastTagButton.y;
                tagButton.x = leftWidth;
            } else { // 按钮显示在下一行
                tagButton.x = 0;
                tagButton.y = CGRectGetMaxY(lastTagButton.frame) + JYJTagMargin;
            }
        }
    }
}

/**
 *  更新textfield的frame
 */
- (void)updateTextFieldFrame {
    // 最后一个标签按钮
    JYJTagButton *lastTagButton = [self.tagButtons lastObject];
    CGFloat leftWidth = CGRectGetMaxX(lastTagButton.frame) + JYJTagMargin;
    
    // 更新textField的frame
    if (self.contentView.width - leftWidth >= [self textFieldTextWidth]) {
        self.textField.y = lastTagButton.y;
        self.textField.x = leftWidth;
    } else {
        self.textField.x = 0;
        self.textField.y = CGRectGetMaxY(lastTagButton.frame) + JYJTagMargin;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  textFiled的文字宽度
 */
- (CGFloat)textFieldTextWidth {
    
    CGFloat textW = [self.textField.text sizeWithFont:self.textField.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;

    return MAX(100, textW);
}

#pragma mark - <UITextFieldDelegate>
/**
 *  监听键盘右下角按钮的点击（return key , 比如“换行”, "完成"等等）
 */
- (BOOL)textFieldShouldReturn:(JYJTagTextField *)textField {
    if (textField.hasText) {
        [self addButtonClick];
    }
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
