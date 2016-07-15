//
//  RLloginVC.m
//  RunningNote
//
//  Created by qingyun on 16/7/6.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RLloginVC.h"
#import "AppDelegate.h"
#import <AVUser.h>

@interface RLloginVC ()

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;

@end

@implementation RLloginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}
//点击View收回键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请用测试帐号:(帐号：1234 密码：123) 登录" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
    [alertVC addAction:action];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (IBAction)loginAction:(UIButton *)sender {
    if (_userName.text.length == 0 || _passWord.text.length == 0){
        NSLog(@"用户名或密码不能为空");
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户名或密码不能为空" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        [alertVC addAction:action];
        [self presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    
    //登录
    [AVUser logInWithUsernameInBackground:_userName.text password:_passWord.text block:^(AVUser *user, NSError *error) {
        if (user != nil){
            NSLog(@"登录成功");
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            [delegate showHomeVC];
        }else{
            NSLog(@"登录失败:%@",error);
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
