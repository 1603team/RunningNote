//
//  RSetTableVC.m
//  RunningNote
//
//  Created by qingyun on 16/6/30.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RSetTableVC.h"
#import "UIViewController+RVCForStoryBoard.h"
#import "RUserInfoTableVC.h"
#import "AppDelegate.h"
#import <AVUser.h>
#import "RMessageManager.h"

@interface RSetTableVC ()

@end

@implementation RSetTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    self.view.backgroundColor = [UIColor colorWithRed:46/255.0 green:46/255.0 blue:46/255.0 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Tab;e view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        //编辑个人资料
        NSLog(@"编辑个人资料");
        RUserInfoTableVC *userInfoVC = [UIViewController controllerForStoryBoardName:@"RHBStoryboard" ControllerName:@"RUserInfoTableVC"];
        [self.navigationController pushViewController:userInfoVC animated:YES];
    }
    if (indexPath.section == 1 && indexPath.row ==0) {
        //绑定账号
        NSLog(@"绑定账号");
    }
    if (indexPath.section == 2 && indexPath.row ==0) {
        //问题反馈
        NSLog(@"问题反馈");
    }
    if (indexPath.section ==3 ) {
        if (indexPath.row == 0) {
            //版本更新
            NSLog(@"版本更新");
        }else if (indexPath.row == 1){
            //清除缓存
            NSLog(@"清除缓存");
        }
    }
    if (indexPath.section == 4 ) {
        //退出登录
        NSLog(@"退出登录");
        [AVUser logOut];
        [AVUser currentUser].username = nil;
        [AVUser currentUser].password = nil;
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        [delegate showLoginVC];
        RMessageManager *manager = [RMessageManager sharemessageManager];
        manager = nil;
        manager.clint = nil;
        manager.delegate = nil;
    }
    
    
    
}

#pragma mark - Table view data source

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
