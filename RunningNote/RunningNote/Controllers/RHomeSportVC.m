//
//  RHomeSportVC.m
//  RunningNote
//
//  Created by qingyun on 16/6/30.
//  Copyright © 2016年 张小东. All rights reserved.
//

#import "RHomeSportVC.h"

@interface RHomeSportVC ()
{
    NSTimer * _runTimer;            //定时器
    NSInteger _milliSeconds;        //秒数
    CAShapeLayer *arcLayer;     //
    __weak IBOutlet UIButton *runButton;//开始按钮
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;//底部约束
@property (weak, nonatomic) IBOutlet UIButton *chooseModeBtn;//选择模式的Btn
@property (weak, nonatomic) IBOutlet UIButton *stopButton;//停止按钮

@property (weak, nonatomic) IBOutlet UILabel *tishiInfo;//提示信息
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

@property (nonatomic, copy) NSString *currentTime;      //当前显示的时间
@property (nonatomic, strong) UILabel *countdownLabel;  //倒计时的label

@end

@implementation RHomeSportVC

#pragma mark - 懒加载倒计时Label

-(UILabel *)countdownLabel{
    if (_countdownLabel == nil) {
        _countdownLabel = [[UILabel alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _countdownLabel.font = [UIFont systemFontOfSize:200.0];
        _countdownLabel.textAlignment = NSTextAlignmentCenter;
        _countdownLabel.backgroundColor = [UIColor blackColor];
    }
    return _countdownLabel;
}

#pragma mark - 隐藏与显示所有Label

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

#pragma mark - 生命周期方法

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hiddenAllLabel];
    self.stopButton.enabled = NO;
#warning 之后将隐藏设为YES
    self.navigationController.navigationBarHidden = NO;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _bottomConstraint.constant = 20 + 64;//20为留白，80为按钮高度，64为tabBar高度
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 模式选择

- (IBAction)chooseOneMode:(UIButton *)sender {
    
}

#pragma mark - 开始暂停按钮

- (IBAction)startBtn:(UIButton *)sender {
    if (_chooseModeBtn.hidden == NO || _tishiInfo.hidden == NO) {
        [_chooseModeBtn removeFromSuperview];
        [_tishiInfo removeFromSuperview];
#warning 倒计时后显示所有的Label
        //改变状态
        sender.selected = !sender.selected;
        if (_stopButton.enabled == NO) {
            _stopButton.enabled = YES;
        }
        if(_runTimer == nil){
            //每隔0.01秒刷新一次页面
            _runTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(runAction) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_runTimer forMode:NSRunLoopCommonModes];
        }else{
            [_runTimer invalidate];   //让定时器失效
            _runTimer = nil;
        }
        [self showAllLabel];
    }
}

#pragma mark - 返回按钮

- (IBAction)backBtn:(UIButton *)sender {

}

#pragma mark - 停止按钮

- (IBAction)stopBtn:(UIButton *)sender {
    [_runTimer invalidate];   //让定时器失效
    _runTimer=nil;
    __weak RHomeSportVC *weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否保存本次记录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf saveRecord];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"不保存" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf replaceView];
    }];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)replaceView{
    _timeNow.text = @"00:00:00";
    _milliSeconds=0;
    runButton.selected = NO;
    _stopButton.enabled = NO;
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - 倒计时相关

-(void)intiUIOfView:(UILabel *)numLabel
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGRect rect = [UIScreen mainScreen].bounds;
    [path addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2) radius:100 startAngle:-M_PI_2 endAngle:3*M_PI clockwise:YES];
    [arcLayer removeFromSuperlayer];
    
    arcLayer = [CAShapeLayer layer];
    arcLayer.path = path.CGPath;
    arcLayer.fillColor = [UIColor clearColor].CGColor;
    arcLayer.strokeColor = numLabel.textColor.CGColor;
    arcLayer.lineWidth = 5;
    arcLayer.frame = self.view.frame;
    [numLabel.layer addSublayer:arcLayer];
    [self drawLineAnimation:arcLayer];
    
}

-(void)drawLineAnimation:(CAShapeLayer*)layer
{
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration = 1;
    bas.repeatCount = 1;
    bas.fromValue = [NSNumber numberWithInteger:0];
    bas.toValue = [NSNumber numberWithInteger:1];
    [layer addAnimation:bas forKey:@"key"];
}

- (void)removeFromView:(UIView *)view
{
    [view removeFromSuperview];
    view = nil;
}

#pragma mark - 计时更新
-(void)runAction{
    _milliSeconds++;
    NSInteger timeNum;
    if (((_milliSeconds - 1) % 100) == 0) {
        timeNum = (_milliSeconds - 1) / 100;
    }
    switch (timeNum) {
        case 0:
            [self.view addSubview:self.countdownLabel];
            _countdownLabel.text = [@(3 - timeNum) stringValue];
            _countdownLabel.textColor = [UIColor redColor];
            [self intiUIOfView:self.countdownLabel];
            break;
        case 1:
            _countdownLabel.text = [@(3 - timeNum) stringValue];
            _countdownLabel.textColor = [UIColor yellowColor];
            [self intiUIOfView:self.countdownLabel];
            break;
        case 2:
            _countdownLabel.text = [@(3 - timeNum) stringValue];
            _countdownLabel.textColor = [UIColor greenColor];
            [self performSelector:@selector(removeFromView:) withObject:_countdownLabel afterDelay:1];
            [self intiUIOfView:self.countdownLabel];
            break;
        default:
            break;
    }
    //保证显示正常
    NSInteger allSeconds = _milliSeconds - 300;
    if (allSeconds < 0) {
        allSeconds = 0;
    }
    
    //动态改变时间
    _timeNow.text = [NSString stringWithFormat:@"%02li:%02li.%02li",allSeconds / 100 / 60 % 60, allSeconds / 100 % 60, allSeconds % 100];
}

#pragma mark - 保存记录

-(void)saveRecord{
#warning create and add a plistDictionary for this record
    //取当前时间作为记录的标题，其他内容为记录的数据
    NSDate *senddate = [NSDate date];
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMddHHmmss"];
    NSString *locationString = [dateformatter stringFromDate:senddate];
    NSString *titleString = [NSString stringWithFormat:@"%@",locationString];
    
    NSDictionary *plistDict = @{@"title" : titleString, @"time" : _timeNow.text, @"kilometre" : _kmNumber.text, @"speed" : _speedNumber.text};
    //获取Document目录(本地化的数据存储位置)
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths lastObject];
    NSMutableArray *plistArray = [NSMutableArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/MyRun.plist",docPath]];
    if (plistArray == nil) {
        plistArray = [NSMutableArray array];
    }
    [plistArray insertObject:plistDict atIndex:0];
    [plistArray writeToFile:[NSString stringWithFormat:@"%@/MyRun.plist",docPath] atomically:YES];
    [self replaceView];
}

@end
