//
//  RChangePassWorldVC.m
//  RunningNote
//
//  Created by qingyun on 16/6/30.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RChangePassWorldVC.h"
#import <AVUser.h>
#import <SVProgressHUD.h>

@interface RChangePassWorldVC ()
{
    NSTimer *counterDownTimer;
    int freezeCounter;
}

@property (weak, nonatomic) IBOutlet UITextField *telephone;
@property (weak, nonatomic) IBOutlet UITextField *oldPsaaWord;//验证码
@property (weak, nonatomic) IBOutlet UITextField *passWordOne;//新密码
@property (weak, nonatomic) IBOutlet UITextField *passWordTwo;//再次确认
@property (weak, nonatomic) IBOutlet UIButton *getSMSBtn;

@end

@implementation RChangePassWorldVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.getSMSBtn.layer.cornerRadius = 4;
    self.getSMSBtn.layer.masksToBounds = YES;
    [self.telephone setText:[AVUser currentUser].mobilePhoneNumber];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击View收回键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)freezeMoreRequest {
    // 一分钟内禁止再次发送
    [self.getSMSBtn setEnabled:NO];
    freezeCounter = 60;
    counterDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownRequestTimer) userInfo:nil repeats:YES];
    [counterDownTimer fire];
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"验证码已发送到你请求的手机号码。如果没有收到，可以在一分钟后尝试重新发送。" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:nil];
    [alertVC addAction:action];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)countDownRequestTimer {
    static NSString *counterFormat = @"%d 秒后再获取";
    --freezeCounter;
    if (freezeCounter<= 0) {
        [counterDownTimer invalidate];
        counterDownTimer = nil;
        [self.getSMSBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.getSMSBtn setEnabled:YES];
    } else {
        [self.getSMSBtn setTitle:[NSString stringWithFormat:counterFormat, freezeCounter] forState:UIControlStateNormal];
    }
}

//获取验证码
- (IBAction)getSMSCode:(UIButton *)sender {
    [AVUser requestPasswordResetWithPhoneNumber:[AVUser currentUser].mobilePhoneNumber block:^(BOOL succeeded, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
        } else {
            [self freezeMoreRequest];
        }
        ;
    }];
}
//修改密码
- (IBAction)changePassWord:(UIButton *)sender {
    if ([_passWordOne.text isEqualToString:_passWordTwo.text]) {
        if (_oldPsaaWord.text.length < 6) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"警告" message:@"验证码无效！" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:nil];
            [alertVC addAction:action];
            [self presentViewController:alertVC animated:YES completion:nil];
            return;
        }else{
            [AVUser resetPasswordWithSmsCode:_oldPsaaWord.text newPassword:_passWordOne.text block:^(BOOL succeeded, NSError *error) {
                if (error) {
                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
                } else {
                    [SVProgressHUD showSuccessWithStatus:@"已经成功重置当前用户的密码！"];
                }
            }];
        }
    }else {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"警告" message:@"两次密码不一致！！！" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:nil];
        [alertVC addAction:action];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}

@end
