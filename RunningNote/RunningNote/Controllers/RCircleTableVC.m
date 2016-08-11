//
//  RCircleTableVC.m
//  RunningNote
//
//  Created by qingyun on 16/6/30.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RCircleTableVC.h"
#import "RDynamicTableVC.h"
#import "RMyFriendsTableVC.h"
#import "RChatsListTableVC.h"

@interface RCircleTableVC ()

@end

@implementation RCircleTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.tabBarController setHidesBottomBarWhenPushed:YES];
//    self.hidesBottomBarWhenPushed = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    
    self.tabBarController.tabBar.hidden = NO;//12345678965432
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    self.navigationController.navigationBar.alpha = 1;
    self.view.backgroundColor = [UIColor colorWithRed:46/255.0 green:46/255.0 blue:46/255.0 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
}

- (IBAction)myFriends:(UIBarButtonItem *)sender {
    //我的好友
    RMyFriendsTableVC *myFriendsVC = [RMyFriendsTableVC new];
    [myFriendsVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:myFriendsVC animated:YES];
    
    
}

- (IBAction)MyMessage:(UIBarButtonItem *)sender {
    //我的消息
    RChatsListTableVC *chatsList = [[RChatsListTableVC alloc] init];
    [chatsList setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:chatsList animated:YES];
    
}



#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                //跑友动态
                RDynamicTableVC *dynamicTVC = [[RDynamicTableVC alloc] initWithStyle:UITableViewStyleGrouped];
                [dynamicTVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:dynamicTVC animated:YES];
            }else if (indexPath.row == 1){
                //我的跑团
                NSLog(@"我的跑团");
            }
        }break;
        case 1:{
            if (indexPath.row == 0) {
                //发现跑友
                NSLog(@"发现跑友");
            }else if (indexPath.row == 1){
                //发现跑团
                NSLog(@"发现跑团");
            }
        }break;
        case 2:{
            if (indexPath.row == 0) {
                //赛事预告
                NSLog(@"赛事预告");
            }else if (indexPath.row == 1){
                //2016全球马拉松指南
                NSLog(@"2016全球马拉松指南");
            }
        }break;
        case 3:{
            if (indexPath.row == 0) {
                //排行榜
                NSLog(@"排行榜");
            }
        }break;
        default:
            break;
    }
}

@end
