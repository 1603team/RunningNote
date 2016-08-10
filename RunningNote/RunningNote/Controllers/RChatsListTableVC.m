//
//  ChatsListTableVC.m
//  RunningNote
//
//  Created by qingyun on 16/7/27.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RChatsListTableVC.h"
#import "AVIMCommon.h"
#import "AVIMSignature.h"
#import "RMessageManager.h"
#import "RUserModel.h"
#import "ChartVC.h"
@interface RChatsListTableVC ()

@property (nonatomic, strong) NSArray *chatsList;

@end

@implementation RChatsListTableVC

//- (NSArray *)chatsList{
//    if (!_chatsList) {
//        _chatsList = [[NSArray alloc] init];
//    }
//    return _chatsList;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"最近会话";
    self.view.backgroundColor = [UIColor darkGrayColor];
    _chatsList = [[NSArray alloc] init];

    AVIMClient *client = [RMessageManager sharemessageManager].clint;
    AVIMConversationQuery *query = [client conversationQuery];
    query.cachePolicy = kAVCachePolicyNetworkElseCache;//关闭优先请求缓存，先从网络获取

    [query whereKey:@"m" containsAllObjectsInArray:@[[AVUser currentUser].username ]];
    [query addDescendingOrder:@"updateAt"];
    __weak RChatsListTableVC *weakSelf = self;
    // 执行查询
    if (client.status == AVIMClientStatusOpened) {
        [query findConversationsWithCallback:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
            }
            NSLog(@"%@",objects);
            weakSelf.chatsList = objects;
            [weakSelf.tableView reloadData];
        }];
    }else{
        [client openWithCallback:^(BOOL succeeded, NSError *error){
            [query findConversationsWithCallback:^(NSArray *objects, NSError *error) {
                if (error) {
                    NSLog(@"%@",error);
                }
                NSLog(@"%@",objects);
                weakSelf.chatsList = objects;
                [weakSelf.tableView reloadData];
            }];
        }];
    }
 
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    
}



#pragma mark - Table view data source
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chatsList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AVIMConversation *conversation = self.chatsList[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
    }
    //    cell.textLabel.text = conversation.name;
    NSArray *array = [conversation.name componentsSeparatedByString:@"&"];
    for (NSString *nameStr in array) {
        if (![nameStr isEqualToString:[RUserModel sharedUserInfo].nickName]) {
            cell.textLabel.text = nameStr;
        }
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AVIMConversation *conversation = self.chatsList[indexPath.row];
    ChartVC *chartVC = [[ChartVC alloc] init];
    chartVC.conversation = conversation;
    self.tabBarController.tabBar.hidden=YES;
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:chartVC animated:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.alpha = 1;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
