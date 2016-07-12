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

@interface RCircleTableVC ()

@end

@implementation RCircleTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    self.navigationController.navigationBar.alpha = 1;
    self.view.backgroundColor = [UIColor colorWithRed:46/255.0 green:46/255.0 blue:46/255.0 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)myFriends:(UIBarButtonItem *)sender {
    //我的好友
    RMyFriendsTableVC *myFriendsVC = [RMyFriendsTableVC new];
    [self.navigationController pushViewController:myFriendsVC animated:YES];
    
    
}

- (IBAction)MyMessage:(UIBarButtonItem *)sender {
    //我的消息
    
}



#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                //跑友动态
                RDynamicTableVC *dynamicTVC = [[RDynamicTableVC alloc] initWithStyle:UITableViewStyleGrouped];
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
