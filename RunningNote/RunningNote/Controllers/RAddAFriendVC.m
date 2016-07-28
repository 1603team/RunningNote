//
//  RAddAFriendVC.m
//  RunningNote
//
//  Created by qingyun on 16/7/15.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RAddAFriendVC.h"
#import <SVProgressHUD.h>
#import <AVStatus.h>
#import <Masonry.h>
@interface RAddAFriendVC ()<UITextFieldDelegate>
@property (nonatomic, strong)UITextField *textField;
@end

@implementation RAddAFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(btnClick)];
    self.navigationItem.rightBarButtonItem = right;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_blue"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    self.navigationItem.title = @"添加好友";
    
    _textField = [[UITextField alloc] init];
    _textField.placeholder = @"请输入好友的账号";
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.delegate = self;
    [_textField setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
    [self.view addSubview:_textField];
    [_textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(-self.view.frame.size.height/4);
        make.left.mas_equalTo(60);
        make.right.mas_equalTo(-60);
        
    }];
}
- (void)btnClick{
    [SVProgressHUD showWithStatus:@"正在处理..."];
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" containedIn:@[_textField.text]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"添加失败"];
            NSLog(@"===========%@",error);
        }
        if (objects.count > 0) {
            AVUser *user = [objects firstObject];
            [[AVUser currentUser] follow:user.objectId andCallback:^(BOOL succeeded, NSError *error) {
                if (succeeded) {//自动反向关注
                    [SVProgressHUD showSuccessWithStatus:@"添加成功"];
                    [self performSelector:@selector(dismissSelf) withObject:nil afterDelay:2.0f];
                }else{
                    NSLog(@"添加好友失败:%@",error);
                    [SVProgressHUD showErrorWithStatus:@"添加失败"];
                }
            }];
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"添加失败,账号有误"];
        }
        
    }];
}
-(void)dismissSelf{
    [self.navigationController popViewControllerAnimated:YES];
    [SVProgressHUD dismiss];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{//键盘回收
    [_textField resignFirstResponder];
}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{//键盘回收
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
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