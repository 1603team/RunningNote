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
#import "RSendSMSCodeVC.h"
#import "SVProgressHUD.h"

@interface RRegisterVC ()

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UITextField *passWordTwo;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;

@end

@implementation RRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//点击View收回键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)registerAction:(UIButton *)sender {
    if (_userName.text.length == 0 || _passWord.text.length == 0) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户名或密码不能为空" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        [alertVC addAction:action];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    if ([self checkTel:_phoneNumber.text]) {
        //创建用户对象
        AVUser *user = [[AVUser alloc] init];
        user.username = _userName.text;
        user.password = _passWord.text;
        user.mobilePhoneNumber = _phoneNumber.text;
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error.userInfo]];
            } else {
                // 注册成功
                RSendSMSCodeVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RSendSMSCodeVC"];
                [self presentViewController:vc animated:YES completion:nil];
            }
        }];
//        //注册
//        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            if (succeeded){
//                NSLog(@"注册成功");
//                //注册成功之后,自动登录
//                [AVUser logInWithUsernameInBackground:_userName.text password:_passWord.text block:^(AVUser *user, NSError *error) {
//                    if (user != nil){
//                        NSLog(@"登录成功");
//                        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
//                        [delegate showHomeVC];
//                    }else{
//                        NSLog(@"登录失败:%@",error);
//                    }
//                }];
//            }else{
//                NSLog(@"注册失败:%@",error);
//            }
//        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)checkTel:(NSString *)str

{
    
    if ([str length] == 0) {
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"电话号码不能为空" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:nil];
        [alertVC addAction:action];
        [self presentViewController:alertVC animated:YES completion:nil];
        
        return NO;
        
    }
    
    NSString *regex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入正确的电话号码" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:nil];
        [alertVC addAction:action];
        [self presentViewController:alertVC animated:YES completion:nil];
        
        return NO;
        
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
