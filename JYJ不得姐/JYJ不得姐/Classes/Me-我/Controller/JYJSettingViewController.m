//
//  JYJSettingViewController.m
//  JYJ不得姐
//
//  Created by JYJ on 16/5/30.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJSettingViewController.h"
#import "SDImageCache.h"

@interface JYJSettingViewController ()

@end

@implementation JYJSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    self.tableView.backgroundColor = JYJGlobalBg;
    
    [self getSize2];
}

- (void)getSize2 {
   // 图片缓存
    NSUInteger size = [SDImageCache sharedImageCache].getSize;
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    JYJLog(@"%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]);
    NSString *cachePath = [caches stringByAppendingPathComponent:@"default/com.hackemist.SDWebImageCache.default"];
    // 获取文件夹内部的所有内容
    //    NSArray *contents = [manager contentsOfDirectoryAtPath:cachePath error:nil];
    NSArray *subPaths = [manager subpathsAtPath:cachePath];
//    JYJLog(@"%@", subPaths);
    
}

- (void)getSize {
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    JYJLog(@"%@", caches);
    NSString *cachePath = [caches stringByAppendingPathComponent:@"default/com.hackemist.SDWebImageCache.default"];
    
    NSDirectoryEnumerator *fileEnumerator = [manager enumeratorAtPath:cachePath];
    NSUInteger totalSize = 0;
    
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [manager attributesOfItemAtPath:filePath error:nil];
        JYJLog(@"%@ -- %@", attrs, filePath);
        if ([attrs[NSFileType] isEqualToString:NSFileTypeDirectory]) continue;
        
        totalSize += [attrs[NSFileSize] integerValue];
    }
    JYJLog(@"%zd", totalSize);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    CGFloat size = [SDImageCache sharedImageCache].getSize / 1000.0 / 1000;
    cell.textLabel.text = [NSString stringWithFormat:@"清除缓存(已使用%.2fMB)", size];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[SDImageCache sharedImageCache] clearDisk];
    [self.tableView reloadData];
}

@end
