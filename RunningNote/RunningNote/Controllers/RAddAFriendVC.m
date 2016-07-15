//
//  RAddAFriendVC.m
//  RunningNote
//
//  Created by qingyun on 16/7/15.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RAddAFriendVC.h"
#import <Masonry.h>
@interface RAddAFriendVC ()
@property (nonatomic, strong)UITextField *textField;
@end

@implementation RAddAFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_blue"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    self.navigationItem.title = @"添加好友";
    
    _textField = [[UITextField alloc] init];
    _textField.placeholder = @"请输入好友的账号";
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.backgroundColor = [UIColor whiteColor];
    [_textField setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
    [self.view addSubview:_textField];
    [_textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(-self.view.frame.size.height/4);
        make.left.mas_equalTo(60);
        make.right.mas_equalTo(-60);
        
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
