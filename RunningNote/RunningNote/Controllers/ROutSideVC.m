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

- (BMKLocationService *)locationService {
    if (_locationService == nil) {
        _locationService = [[BMKLocationService alloc] init];
        _locationService.distanceFilter = 15.f;
        _locationService.desiredAccuracy = kCLLocationAccuracyBest;
        _locationService.delegate = self;
    }
    return _locationService;
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
        make.bottom.mas_equalTo(_kmNumber).with.offset(10);
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
    
#pragma mark - CLLocationManagerDelegate
}
//授权状态改变的响应方法
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
}

//更新位置
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = [locations lastObject];
    //经纬度
    CLLocationCoordinate2D coordinate = location.coordinate;
    //水平精度
    CLLocationAccuracy accuracy = location.horizontalAccuracy;
    //垂直的精度
    CLLocationAccuracy acc = location.verticalAccuracy;
    //海拔高度
    CLLocationDistance distance = location.altitude;
}

//失败，或者出错
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
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
}

#pragma mark - 停止按钮

- (IBAction)stopBtn:(UIButton *)sender {
    [self.locationService stopUserLocationService];
    
    RAnnotation *anno = [[RAnnotation alloc] init];
    anno.coordinate = self.nowAnnotation.coordinate;
    anno.type = 3;
    anno.title = @"结束";
    [self.mapView addAnnotation:anno];
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

