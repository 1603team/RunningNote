//
//  RRegisterVC.m
//  RunningNote
//
//  Created by qingyun on 16/7/6.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RRegisterVC.h"
#import <AVUser.h>
#import "AppDelegate.h"

@interface RRegisterVC ()

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UITextField *passWordTwo;

@end

@implementation RRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)registerAction:(UIButton *)sender {
    if (_userName.text.length == 0 || _passWord.text.length == 0) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户名或密码不能为空" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        [alertVC addAction:action];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    //创建用户对象
    AVUser *user = [AVUser user];
    user.username = _userName.text;
    user.password = _passWord.text;
    
    //注册
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded){
            NSLog(@"注册成功");
            //注册成功之后,自动登录
            [AVUser logInWithUsernameInBackground:_userName.text password:_passWord.text block:^(AVUser *user, NSError *error) {
                if (user != nil){
                    NSLog(@"登录成功");
                    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
                    [delegate showHomeVC];
                }else{
                    NSLog(@"登录失败:%@",error);
                }
            }];
        }else{
            NSLog(@"注册失败:%@",error);
        }
    }];
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
