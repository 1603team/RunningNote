//
//  RPublishedVC.m
//  RunningNote
//
//  Created by qingyun on 16/7/12.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RPublishedVC.h"
#import <AVOSCloud.h>
#import <AVUser.h>
#import <SVProgressHUD.h>

@interface RPublishedVC ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation RPublishedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.alpha = 1;
    self.view.backgroundColor = [UIColor colorWithRed:46/255.0 green:46/255.0 blue:46/255.0 alpha:1];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(creatNewDynamic)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;

    
}

- (void)creatNewDynamic{

    [SVProgressHUD showWithStatus:@"发布中..."];
    self.view.userInteractionEnabled = NO;
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    self.view.alpha = 0.5;
    
    NSString *string = self.textView.text;
    AVObject *todoFolder = [[AVObject alloc] initWithClassName:@"Dynamic"];// 构建对象
    [todoFolder setObject:[AVUser currentUser].username forKey:@"userName"];
    [todoFolder setObject:string forKey:@"body"];
#warning more
    //[todoFolder setObject:<#(id)#> forKey:@"images"];
    //[todoFolder setObject:@1 forKey:@"priority"];// 设置优先级
    [todoFolder saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [SVProgressHUD showSuccessWithStatus:@"发布成功"];
            [self performSelector:@selector(delayDismiss) withObject:nil afterDelay:2.0f];
        } else {
            [SVProgressHUD showWithStatus:@"发布失败!"];
            [SVProgressHUD dismissWithDelay:2.0f];
            self.view.userInteractionEnabled = YES;
            self.navigationController.navigationBar.userInteractionEnabled = YES;
            self.view.alpha = 1.0;
            NSLog(@"%@",error);
        }
    }];
    
    
}

- (void)delayDismiss{
    
    [self.navigationController popViewControllerAnimated:YES];
}
//
//通过 limit 语句来限定返回结果大小，比如限定返回 100 个：
//+
//
//select * from Comment limit 100
/**
 *  比较日期，使用 date 函数来转换，比如查询特定时间之前创建的对象：
 +
 
 select * from GameScore where createdAt < date('2011-08-20T02:06:57.931Z')
 */

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
