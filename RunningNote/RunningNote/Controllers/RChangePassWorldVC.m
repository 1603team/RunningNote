//
//  RChangePassWorldVC.m
//  RunningNote
//
//  Created by qingyun on 16/6/30.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RChangePassWorldVC.h"

@interface RChangePassWorldVC ()

@property (weak, nonatomic) IBOutlet UITextField *oldPsaaWord;
@property (weak, nonatomic) IBOutlet UITextField *passWordOne;
@property (weak, nonatomic) IBOutlet UITextField *passWordTwo;

@end

@implementation RChangePassWorldVC

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (IBAction)changePassWord:(UIButton *)sender {
    NSLog(@"确定修改密码");
#warning changePassWord
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}

@end
