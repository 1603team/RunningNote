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
#import "RFriendTableViewCell.h"
#import <AVStatus.h>

@interface RMyFriendsTableVC ()

@property (nonatomic ,strong) NSArray *friendsArray;//

@end

@implementation RMyFriendsTableVC
static NSString *identifier = @"friendmycell";
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加好友的按钮
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriend)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
    UIImageView *headerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"friends_bg"]];
    headerView.contentMode = UIViewContentModeScaleToFill;
    headerView.maskView.clipsToBounds = YES;
    headerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
//    CGRect frame = headerView.frame;
//    frame.size.height = 20;
//    headerView.frame = frame;
    self.tableView.tableHeaderView = headerView;
    self.tabBarController.tabBar.backgroundImage = [UIImage imageNamed:@"tabbar_bg_black"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_bg"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;

    
    
    self.navigationItem.title = @"好友列表";
    self.tableView.backgroundColor = [UIColor blackColor];
   // UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_blue"]];
  //  imageView.contentMode = UIViewContentModeScaleAspectFill;
  //  self.tableView.backgroundView = imageView;
    
    UINib *nib = [UINib nibWithNibName:@"RFriendTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:identifier];
    
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
#warning 本地化好友列表  现在好友为AVUSer 转换为模型在本地 需要nickName
        NSSortDescriptor *nickNameDesc = [NSSortDescriptor sortDescriptorWithKey:@"nickName" ascending:YES];
        NSArray *sortedArray = [mutArray sortedArrayUsingDescriptors:@[nickNameDesc]];
        self.friendsArray = sortedArray;//获取到好友，本地化处理⚠️
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
    RFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    NSDictionary *localData = [user valueForKey:@"localData"];
    NSData *icomImageData = [localData valueForKey:@"iconImage"];
    NSString *nickName = [localData valueForKey:@"nickName"];
    cell.iconImage.image = [UIImage imageWithData:icomImageData];
    cell.nickName.text = nickName;
    cell.nickName.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor lightGrayColor];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_cell_black"]];
//    [cell setBackgroundView:imageView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AVUser *user = self.friendsArray[indexPath.row];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"RFriends-Chat" bundle:nil];
    RFriendsInfor *friendInfor = [sb instantiateViewControllerWithIdentifier:@"rfriendsInfor"];
    friendInfor.friendsUser = user;
    
    self.tabBarController.tabBar.hidden=YES;
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:friendInfor animated:YES];
    self.hidesBottomBarWhenPushed=NO;
    
    //并在push后设置self.hidesBottomBarWhenPushed=NO;
    //这样back回来的时候，tabBar会恢复正常显示。
}



@end
