//
//  ChatsListTableVC.m
//  RunningNote
//
//  Created by qingyun on 16/7/27.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RChatsListTableVC.h"
#import "AVIMSignature.h"
#import "RMessageManager.h"
#import "RUserModel.h"
#import "ChartVC.h"
#import "RChatListCell.h"
@interface RChatsListTableVC ()

@property (nonatomic, strong) NSArray *chatsList;//会话列表
@property (nonatomic, strong) NSDictionary *unreadMessage;//未读消息数据
@end

@implementation RChatsListTableVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"最近会话";
    self.unreadMessage = [NSDictionary dictionary];
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chart_bgimage"]];
    
    self.tableView.backgroundView = bgView;
    self.tableView.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    _chatsList = [[NSArray alloc] init];
    [self reloadChtsList];
    [[RMessageManager sharemessageManager] addObserver:self forKeyPath:@"messagePara" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RChatListCell" bundle:nil] forCellReuseIdentifier:@"chatListcell"];
}
#pragma mark -kvo监听未读消息代理返回变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    self.unreadMessage = change[@"new"];
    [self.tableView reloadData];
}
- (void)reloadChtsList{//获取会话列表
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
            weakSelf.chatsList = objects;
            [weakSelf.tableView reloadData];
        }];
    }else{
        [client openWithCallback:^(BOOL succeeded, NSError *error){
            [query findConversationsWithCallback:^(NSArray *objects, NSError *error) {
                if (error) {
                    NSLog(@"%@",error);
                }
                weakSelf.chatsList = objects;
                [weakSelf.tableView reloadData];
            }];
        }];
    }
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
    RChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatListcell" forIndexPath:indexPath];
    NSArray *array = [conversation.name componentsSeparatedByString:@"&"];
    for (NSString *nameStr in array) {
        if (![nameStr isEqualToString:[RUserModel sharedUserInfo].nickName]) {
            cell.nickNameLabel.text = nameStr;
        }
    }
    AVIMConversation *unreadCon = self.unreadMessage[@"conversation"];
    if ([conversation.conversationId isEqualToString:unreadCon.conversationId]){
        //cell.hasUnread = YES;
        cell.numberLabel.text = [self.unreadMessage[@"unread"] stringValue];
        AVIMTypedMessage *message = self.unreadMessage[@"message"];
        if (message.mediaType == kAVIMMessageMediaTypeImage) {
            cell.lastMessageLabel.text = @"[图片]";
        }else if (message.mediaType == kAVIMMessageMediaTypeAudio){
            cell.lastMessageLabel.text = @"[语音]";
        }else{
            cell.lastMessageLabel.text = message.text;
        }
        if (cell.numberLabel.text.length > 0) {
            cell.numberLabel.backgroundColor = [UIColor redColor];
            cell.numberLabel.layer.cornerRadius = 10.0;
            cell.numberLabel.layer.masksToBounds = YES;
        }else{
            cell.numberLabel.backgroundColor = [UIColor clearColor];
            cell.numberLabel.hidden = YES;
        }
    }else{
        //cell.numberLabel.hidden = YES;
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
    RChatListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.numberLabel.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.alpha = 1;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
//    [self.navigationController setHidesBottomBarWhenPushed:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    [[RMessageManager sharemessageManager] removeObserver:self forKeyPath:@"messagePara"];
}


@end
