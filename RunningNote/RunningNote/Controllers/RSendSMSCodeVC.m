//
//  RSendSMSCodeVC.m
//  RunningNote
//
//  Created by qingyun on 16/7/27.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RSendSMSCodeVC.h"
#import "AVUser.h"
#import "AppDelegate.h"

@interface RSendSMSCodeVC ()

@property (weak, nonatomic) IBOutlet UITextField *SMSCode;

@end

@implementation RSendSMSCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendSMSCode:(UIButton *)sender {
    [AVUser verifyMobilePhone:_SMSCode.text withBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            [delegate showHomeVC];
        }
    }];
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
