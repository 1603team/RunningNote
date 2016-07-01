//
//  ROutSideVC.m
//  RunningNote
//
//  Created by qingyun on 16/6/30.
//  Copyright © 2016年 张小东. All rights reserved.
//

#import "ROutSideVC.h"

@interface ROutSideVC ()
@property (weak, nonatomic) IBOutlet UIButton *chooseModeBtn;//模式选择
//涉及“文本”的注释内容不需更改只是为隐藏而做
@property (weak, nonatomic) IBOutlet UILabel *kmNumber;//距离
@property (weak, nonatomic) IBOutlet UILabel *kmText;//距离文本
@property (weak, nonatomic) IBOutlet UILabel *timeNow;//时间
@property (weak, nonatomic) IBOutlet UILabel *speedNumber;//速度
@property (weak, nonatomic) IBOutlet UILabel *speedText;//速度文本
@property (weak, nonatomic) IBOutlet UILabel *paceNumber;//配速
@property (weak, nonatomic) IBOutlet UILabel *paceText;//配速文本
@property (weak, nonatomic) IBOutlet UILabel *calorieNumber;//卡路里
@property (weak, nonatomic) IBOutlet UILabel *calorieText;//卡路里文本
@property (weak, nonatomic) IBOutlet UILabel *heartRate;//心率
@property (weak, nonatomic) IBOutlet UILabel *heartRateText;//心率文本

@end

@implementation ROutSideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //隐藏各种Label
    [self hiddenAllLabel];
#warning 之后将隐藏设为YES
    self.navigationController.navigationBarHidden = NO;
    // Do any additional setup after loading the view.
}

#pragma mark - 隐藏所有的Label

-(void)hiddenAllLabel{
    _kmNumber.hidden = YES;
    _kmText.hidden = YES;
    _timeNow.hidden = YES;
    _speedNumber.hidden = YES;
    _speedText.hidden = YES;
    _paceNumber.hidden = YES;
    _paceText.hidden = YES;
    _calorieNumber.hidden = YES;
    _calorieText.hidden = YES;
    _heartRate.hidden = YES;
    _heartRateText.hidden = YES;
}

#pragma mark - 显示所有的Label

-(void)showAllLabel{
    _kmNumber.hidden = NO;
    _kmText.hidden = NO;
    _timeNow.hidden = NO;
    _speedNumber.hidden = NO;
    _speedText.hidden = NO;
    _paceNumber.hidden = NO;
    _paceText.hidden = NO;
    _calorieNumber.hidden = NO;
    _calorieText.hidden = NO;
    _heartRate.hidden = NO;
    _heartRateText.hidden = NO;
}

#pragma mark - 模式选择

- (IBAction)chooseOneMode:(UIButton *)sender {

}

#pragma mark - 开始暂停按钮

- (IBAction)startBtn:(UIButton *)sender {
    //移除选择模式按钮
    if (_chooseModeBtn.hidden == NO) {
        [_chooseModeBtn removeFromSuperview];
#warning 添加倒计时后显示所有的Label
        [self showAllLabel];
    }
    
}

#pragma mark - 停止按钮

- (IBAction)stopBtn:(UIButton *)sender {

}

#pragma mark - 返回按钮

- (IBAction)backBtn:(UIButton *)sender {

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
