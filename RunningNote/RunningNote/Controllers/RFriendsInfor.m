//
//  RFriendsInfor.m
//  RunningNote
//
//  Created by qingyun on 16/7/21.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RFriendsInfor.h"
#import "ChartVC.h"
#import <AVStatus.h>
@interface RFriendsInfor ()

@property (weak, nonatomic) IBOutlet UIButton *iconBtn;

@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *lvLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalDistance;
@property (weak, nonatomic) IBOutlet UILabel *totalTime;

@end

@implementation RFriendsInfor

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"好友信息";
    NSDictionary *localData = [_friendsUser valueForKey:@"localData"];
    _iconBtn.layer.cornerRadius = 40;
    _iconBtn.layer.masksToBounds = YES;
    _nickName.text = localData[@"nickName"];
    NSData *imageData = localData[@"iconImage"];
    [_iconBtn setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
    _addressLabel.text = localData[@"address"];
    _lvLabel.text = @"初级跑者";
    
    NSString *totalDistanceStr = [localData[@"totalDistance"] stringValue];
    _totalDistance.text = [NSString stringWithFormat:@"%@公里",totalDistanceStr];
    NSString *totalTimeStr = [localData[@"totalTime"] stringValue];
    _totalTime.text = [NSString stringWithFormat:@"%@小时",totalTimeStr];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld,%ld",indexPath.row,indexPath.section);
    if (indexPath.section == 2){
        if (indexPath.row == 0) {
            //个人最佳成绩
        }else{
            //查看好友动态
        }
    }
    if (indexPath.section == 3) {//发消息
        ChartVC *chartVC = [[ChartVC alloc] init];
        chartVC.friendUser = _friendsUser;
        self.tabBarController.tabBar.hidden=YES;
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:chartVC animated:YES];        
    }
}


@end
