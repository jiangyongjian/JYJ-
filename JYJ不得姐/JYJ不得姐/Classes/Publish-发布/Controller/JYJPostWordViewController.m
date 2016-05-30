//
//  JYJPostWordViewController.m
//  JYJ不得姐
//
//  Created by JYJ on 16/5/27.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJPostWordViewController.h"
#import "JYJTextView.h"
#import "JYJAddTagToolbar.h"

@interface JYJPostWordViewController () <UITextViewDelegate>
/** 文本框输入控件 */
@property (nonatomic, weak) JYJTextView *textView;
/** 工具条 */
@property (nonatomic, weak) JYJAddTagToolbar *toolbar;
@end

@implementation JYJPostWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupTextView];
    
    [self setupToolbar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
}

/**
 *  监听键盘的弹出和隐藏
 */
- (void)keyboardWillChangeFrame:(NSNotification *)note {
    // 键盘最终的frame
    CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    // 动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.toolbar.transform = CGAffineTransformMakeTranslation(0, keyboardF.origin.y - JYJScreenH);
    }];
}

/**
 *  工具条
 */
- (void)setupToolbar {
    JYJAddTagToolbar *toobar = [JYJAddTagToolbar viewFromXib];
    toobar.width = JYJScreenW;
    toobar.y = self.view.height - toobar.height;
    [self.view addSubview:toobar];
    self.toolbar = toobar;
    [JYJNoteCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)setupNav {
    self.title = @"发表文字";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(post)];
    
    self.navigationItem.rightBarButtonItem.enabled = NO; // 默认不能点击
    
    // 强制刷新
    [self.navigationController.navigationBar layoutIfNeeded];
}

- (void)setupTextView {
    JYJTextView *textView = [[JYJTextView alloc] init];
    textView.frame = self.view.bounds;
    textView.delegate = self;
    textView.placehoder = @"把好玩的图片，好笑的段子或糗事发到这里，接受千万网友膜拜吧！发布违反国家法律内容的，我们将依法提交给有关部门处理。";
    [self.view addSubview:textView];
    self.textView = textView;
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)post {
    JYJLog(@"发送");
}

#pragma mark - <UITextViewDelegate>
- (void)textViewDidChange:(UITextView *)textView {
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
