//
//  ROutSideVC.m
//  RunningNote
//
//  Created by qingyun on 16/6/30.
//  Copyright © 2016年 张小东. All rights reserved.
//

#import "ROutSideVC.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "RAnnotation.h"
#import "Masonry.h"

@interface ROutSideVC ()<BMKLocationServiceDelegate,BMKMapViewDelegate>
{
    NSTimer * _runTimer;            //定时器
    NSInteger _milliSeconds;        //秒数
    CAShapeLayer *arcLayer;     //
}

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
@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKLocationService *locationService;
@property (nonatomic, strong) NSMutableArray *allLocations;
@property (nonatomic, strong) RAnnotation *nowAnnotation;
@property (nonatomic) BOOL isStart;
@property (nonatomic, strong) UILabel *countdownLabel;

@property (nonatomic, strong) CLLocationManager *manager;//位置管理器

@end

@implementation ROutSideVC
//懒加载
- (BMKMapView *)mapView {
    if (_mapView == nil) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectZero];
        _mapView.delegate = self;
    }
    return _mapView;
}

//BMKLocationService
- (BMKLocationService *)locationService {
    if (_locationService == nil) {
        _locationService = [[BMKLocationService alloc] init];
        _locationService.distanceFilter = 15.f;
        _locationService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _locationService.delegate = self;
    }
    return _locationService;
}
//倒计时label
- (UILabel *)countdownLabel {
    if (_countdownLabel == nil) {
        _countdownLabel = [[UILabel alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _countdownLabel.font = [UIFont systemFontOfSize:200.0];
        _countdownLabel.textAlignment = NSTextAlignmentCenter;
        _countdownLabel.backgroundColor = [UIColor blackColor];
    }
    return _countdownLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化位置数组
    _allLocations = [NSMutableArray array];
    
    //添加mapView
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(64);
        make.bottom.mas_equalTo(_kmNumber.mas_top).with.offset(-5);
    }];
    
    self.manager = [[CLLocationManager alloc] init];
    //设置位置管理器的代理
//    self.manager.delegate = self;
    //向用户申请权限
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.manager requestWhenInUseAuthorization];
    }
    //手机定位服务是否开启
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"在设置中打开GPS");
    }
    //配置location的属性
    //精确度
//    self.manager.desiredAccuracy = kCLLocationAccuracyBest;
    //距离的频率
//    self.manager.distanceFilter = 20.f;
    //开启定位
//    [self.manager startUpdatingLocation];
    //隐藏各种Label
    [self hiddenAllLabel];
#warning 之后将隐藏设为YES
    self.navigationController.navigationBarHidden = NO;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_locationService startUserLocationService];
}

//#pragma mark - CLLocationManagerDelegate
////授权状态改变的响应方法
//-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
//    
//}
//
////更新位置
//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
//    CLLocation *location = [locations lastObject];
//    //经纬度
//    CLLocationCoordinate2D coordinate = location.coordinate;
//    //水平精度
//    CLLocationAccuracy accuracy = location.horizontalAccuracy;
//    //垂直的精度
//    CLLocationAccuracy acc = location.verticalAccuracy;
//    //海拔高度
//    CLLocationDistance distance = location.altitude;
//}
//
////失败，或者出错
//-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
//    
//}

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
    if (_isStart) {
        [_locationService stopUserLocationService];
        
        RAnnotation *anno = [[RAnnotation alloc] init];
        anno.coordinate = self.nowAnnotation.coordinate;
        anno.type = 2;
        anno.title = @"暂停";
        [self.mapView addAnnotation:anno];
    }else {
        [_locationService startUserLocationService];
    }
    _isStart = !_isStart;
//    sender.selected = !sender.selected;
//    if (_stopButton.enabled == NO) {
//        _stopButton.enabled = YES;
//    }
    if(_runTimer == nil){
        //每隔0.01秒刷新一次页面
        _runTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(runAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_runTimer forMode:NSRunLoopCommonModes];
    }else{
        [_runTimer invalidate];   //让定时器失效
        _runTimer = nil;
    }

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

#pragma mark - 停止按钮

- (IBAction)stopBtn:(UIButton *)sender {
    
    [self.locationService stopUserLocationService];
    
    RAnnotation *anno = [[RAnnotation alloc] init];
    anno.coordinate = self.nowAnnotation.coordinate;
    anno.type = 3;
    anno.title = @"结束";
    [self.mapView addAnnotation:anno];
    [_runTimer invalidate];   //让定时器失效
    _runTimer=nil;
    __weak ROutSideVC *weakSelf = self;
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

-(void)replaceView{
    _timeNow.text = @"00:00:00";
    _milliSeconds=0;
//    runButton.selected = NO;
//    _stopButton.enabled = NO;
    [self.navigationController popToRootViewControllerAnimated:NO];
}


#pragma mark - 返回按钮

- (IBAction)backBtn:(UIButton *)sender {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BMKLocationServiceDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    CLLocation *location = userLocation.location;
    
    if (self.allLocations.count == 0) {
        RAnnotation *anno = [[RAnnotation alloc] init];
        anno.coordinate = location.coordinate;
        anno.title = @"开始";
        anno.type = 1;
        [self.mapView addAnnotation:anno];
        
        BMKCoordinateSpan span;
        span.latitudeDelta = 0.005;
        span.longitudeDelta = 0.005;
        BMKCoordinateRegion region;
        region.center = location.coordinate;
        region.span = span;
        [self.mapView setRegion:region animated:YES];
    }
    [self.allLocations addObject:location];
    //添加当前点
    //每返回一个点,作为当前点添加标注,将地图的显示区域移动到定位到的位置
    RAnnotation *nowAnno = [[RAnnotation alloc] init];
    nowAnno.coordinate = location.coordinate;
    nowAnno.type = 0;
    [self.mapView addAnnotation:nowAnno];
    if (self.nowAnnotation) {
        [self.mapView removeAnnotation:self.nowAnnotation];
    }
    self.nowAnnotation = nowAnno;
    
    //将所有的点记录,添加行走的路线
    
    CLLocationCoordinate2D *coordinates = malloc(sizeof(CLLocationCoordinate2D) *self.allLocations.count);
    for (int i = 0; i < self.allLocations.count; i ++) {
        coordinates[i] = [self.allLocations[i] coordinate];
    }
    //    MKPolyline
    BMKPolyline *poly = [BMKPolyline polylineWithCoordinates:coordinates count:self.allLocations.count];
    
    [self.mapView addOverlay:poly];
}

#pragma mark - BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[RAnnotation class]]) {
        RAnnotation *anno = (RAnnotation *)annotation;
        static NSString *identifier = @"qyannotation";
        //从复用队列出队标注视图
        BMKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!annoView){
            annoView = [[BMKAnnotationView alloc] initWithAnnotation:anno reuseIdentifier:identifier];
        }
        
        //给视图绑定数据
        annoView.annotation = annotation;
        annoView.canShowCallout = YES;//显示 callout
        //自定义图片
        switch (anno.type) {
            case 0:
            {
                annoView.image = [UIImage imageNamed:@"currentlocation"];
                annoView.centerOffset = CGPointMake(0, 0);
            }
                break;
            case 1:
            {
                annoView.image = [UIImage imageNamed:@"map_start_icon"];
                annoView.centerOffset = CGPointMake(0, -12);
            }
                break;
            case 2:
            {
                annoView.image = [UIImage imageNamed:@"map_susoend_icon"];
                annoView.centerOffset = CGPointMake(0, -12);
            }
                break;
            case 3:
            {
                annoView.image = [UIImage imageNamed:@"map_stop_icon"];
                annoView.centerOffset = CGPointMake(0, -12);
            }
                break;
            default:
                break;
        }
        
        return annoView;
        
    }
    return nil;
}

//返回曲线视图
-(BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView *renderer = [[BMKPolylineView alloc] initWithPolyline:overlay];
        //配置渲染图层的属性
        renderer.strokeColor = [UIColor blueColor];
        renderer.lineWidth = 3.f;
        return renderer;
    }
    return nil;
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

