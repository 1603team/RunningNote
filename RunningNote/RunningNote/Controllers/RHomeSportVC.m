//
//  RHomeSportVC.m
//  RunningNote
//
//  Created by qingyun on 16/6/30.
//  Copyright © 2016年 张小东. All rights reserved.
//

#import "RHomeSportVC.h"
#import <CoreMotion/CoreMotion.h>
#import "AppDelegate.h"
#import "RUserModel.h"
#import "RUserRunRecord.h"
#import "QYDataBaseTool.h"
#import "DataBaseFile.h"
#import "AVOSCloud.h"
#import "SVProgressHUD.h"

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

/**
 *  运动相关(实现自己的计算模式)
 *  使用健康的话返回数据太慢，影响实用性
 */
@property (nonatomic, strong) CMMotionManager *mManager;
@property (nonatomic, assign) NSInteger stepNum;//步数
@property (nonatomic, assign) CGFloat lastNum;//最后一次记录的跑步值
@property (nonatomic, assign) CGFloat difference;//差值，用于判断是否最大值

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
    self.navigationController.navigationBarHidden = YES;
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
        
        //改变状态
        sender.selected = !sender.selected;
        if (_stopButton.enabled == NO) {
            _stepNum = 0;
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
    [self.navigationController popViewControllerAnimated:YES];
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
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark - 倒计时相关

-(void)intiUIOfView:(UILabel *)numLabel
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGRect rect = [UIScreen mainScreen].bounds;
    [path addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2) radius:100 startAngle:-M_PI_2 endAngle:3*M_PI_2 clockwise:YES];
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
    NSInteger timeNum;//不能设初值，否则释放不掉，程序就会有问题
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
    }else{
        //开始计步
        [self startRunning];
    }
    
    //动态改变时间
    _timeNow.text = [NSString stringWithFormat:@"%02li:%02li.%02li",allSeconds / 100 / 60 % 60, allSeconds / 100 % 60, allSeconds % 100];
    
}

#pragma mark - 计步与距离

-(void)startRunning{
    CMMotionManager *mManager = [(AppDelegate *)[[UIApplication sharedApplication] delegate] sharedManager];
    if ([mManager isAccelerometerAvailable]) {
        [mManager setAccelerometerUpdateInterval:0.02];//设置刷新频率，每秒50次
        [mManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
            CGFloat sqrtA = sqrt(accelerometerData.acceleration.x * accelerometerData.acceleration.x + accelerometerData.acceleration.y * accelerometerData.acceleration.y + accelerometerData.acceleration.z * accelerometerData.acceleration.z);//三个方向的矢量和
            if (sqrtA > 1.552188) {//这个值是走路的值，跑步的阈(yu)值应该会更大一些
                if (_lastNum != 0) {
                    //判断上一次差值为正，本次差值为负则为最大值
                    if ((_difference >= 0) && (sqrtA - _lastNum <= 0)) {
                        _stepNum++;
                        _heartRate.text = [NSString stringWithFormat:@"%ld",(long)_stepNum];
                        
                        CGFloat stepLength = [RUserModel sharedUserInfo].height * 0.4 / 100;//取出身高并计算步长，即一大步为身高的0.8
                        NSInteger kg = [RUserModel sharedUserInfo].weight;
                        
                        CGFloat km = stepLength * _stepNum / 1000;
                        _kmNumber.text = [NSString stringWithFormat:@"%.02f",km];
                        
                        NSInteger i = _milliSeconds - 300;//取出当前的秒数
                        CGFloat speed = km / i;
                        _speedNumber.text = [NSString stringWithFormat:@"%.02f",speed * 3600];
                        NSInteger pace = 1 / speed;//秒每千米
                        if (pace >= 60) {
                            _paceNumber.text = [NSString stringWithFormat:@"%ld\'%02ld\"",pace / 60,pace % 60];
                        }else{
                            _paceNumber.text = [NSString stringWithFormat:@"0\'%02ld\"",(long)pace];
                        }
                        
                        CGFloat kcal = kg * km * 1.036;
                        _calorieNumber.text = [NSString stringWithFormat:@"%.02f",kcal];
                    }
                }
                _difference = sqrtA - _lastNum;
                _lastNum = sqrtA;
            }
        }];
    }
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
    
//    NSDictionary *plistDict = @{@"title" : titleString, @"time" : _timeNow.text, @"distance" : _kmNumber.text, @"speed" : _speedNumber.text,@"isHome" : @YES};
    AVObject *runNote = [[AVObject alloc] initWithClassName:@"runNote"];
    [runNote setObject:titleString forKey:@"title"];
    [runNote setObject:_timeNow.text forKey:@"time"];
    [runNote setObject:_kmNumber.text forKey:@"distance"];
    [runNote setObject:_speedNumber.text forKey:@"speed"];
    [runNote setObject:_paceText.text forKey:@"pace"];
    [runNote setObject:_calorieNumber.text forKey:@"calorie"];
    [runNote setObject:@YES forKey:@"isHome"];
    [runNote saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
        }
    }];
//    RUserRunRecord *record = [RUserRunRecord recordModelWithDictionary:plistDict];
//    //获取Document目录(本地化的数据存储位置)
//    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docPath = [paths lastObject];
//    NSMutableArray *plistArray = [NSMutableArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/MyRun.plist",docPath]];
//    if (plistArray == nil) {
//        plistArray = [NSMutableArray array];
//    }
//    [plistArray insertObject:plistDict atIndex:0];
//    [plistArray writeToFile:[NSString stringWithFormat:@"%@/MyRun.plist",docPath] atomically:YES];
    //将纪录保存在数据库
//    [QYDataBaseTool updateStatementsSql:INSERT_MyRunNote_SQL withParsmeters:plistDict block:^(BOOL isOk, NSString *errorMsg) {
//    }];
    [self replaceView];
}

@end
