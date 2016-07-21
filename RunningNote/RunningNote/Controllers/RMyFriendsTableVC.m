//
//  RMyFriendsTableVC.m
//  RunningNote
//
//  Created by qingyun on 16/7/5.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RMyFriendsTableVC.h"
#import "RAddAFriendVC.h"
#import "RFriendsInfor.h"
#import <AVStatus.h>

@interface RMyFriendsTableVC ()

@property (nonatomic ,strong) NSArray *friendsArray;//

@end

@implementation RMyFriendsTableVC
static NSString *identifier = @"mycell";
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加好友的按钮
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriend)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.navigationItem.title = @"好友列表";
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_blue"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.tableView.backgroundView = imageView;
    
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    
    [self reloadFriendsArray];
}

- (void)addFriend{//添加好友
    RAddAFriendVC *friendVC = [[RAddAFriendVC alloc] init];
    [self.navigationController pushViewController:friendVC animated:YES];
}

- (void)reloadFriendsArray{//获取好友列表
    
    //AVQuery *query= [AVUser followeeQuery:@"USER_OBJECT_ID"];
    [[AVUser currentUser] getFollowees:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"error-----> %@",error);
        }
        NSMutableArray *mutArray = [NSMutableArray array];
        for (AVUser *user in objects) {
            [mutArray addObject:user];
        }
#warning 本地化好友列表
        self.friendsArray = mutArray;//获取到好友，本地化处理⚠️
        [self.tableView reloadData];
    }];

}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.alpha = 1;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friendsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {//temp
    
    AVUser *user = self.friendsArray[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];/////////cell没有注册
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = user.username;
    //cell.backgroundColor = [UIColor colorWithRed:12/255.0 green:21/255.0 blue:59/255.0 alpha:1.0];
    cell.backgroundView.alpha = 0.3;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_cell_black"]];
//    [cell setBackgroundView:imageView];
    return cell;
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AVUser *user = self.friendsArray[indexPath.row];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"RFriends-Chat" bundle:nil];
    RFriendsInfor *friendInfor = [sb instantiateViewControllerWithIdentifier:@"rfriendsInfor"];
    friendInfor.friendsUser = user;
    [self.navigationController pushViewController:friendInfor animated:YES];
}


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
