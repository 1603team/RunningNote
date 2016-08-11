//
//  ChartVC.m
//  RunningNote
//
//  Created by qingyun on 16/7/22.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ChartVC.h"
#import "ChartBar.h"
#import "RMessageManager.h"
#import "RUserModel.h"
#import "ChartCell.h"
#import "RAudioPlayer.h"
#import "FunctionView.h"
#import <Masonry.h>
#import "MJRefresh.h"

#define limitNum 20
@interface ChartVC () <UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ChartBarDelegate,MessageManagerDelegate,FuncitonDelegate>
@property (strong, nonatomic)  UITableView *tableView;
@property (nonatomic, strong)ChartBar *chartBar;//聊天的输入栏

@property (strong, nonatomic) NSMutableArray *messagesList;
@end

@implementation ChartVC
- (ChartBar *)chartBar{
    if (!_chartBar) {
        //从xib中加载
        _chartBar = [[[NSBundle mainBundle] loadNibNamed:@"ChartBar" owner:nil options:nil] firstObject];
        [self.view addSubview:_chartBar];
        _chartBar.backgroundColor = [UIColor grayColor];
        _chartBar.delegate = self;
    }
    return _chartBar;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chart_bgimage"]];
        _tableView.backgroundView = bgImageView;
        //_tableView.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = NO;
        //cell自动适配高度
        self.tableView.estimatedRowHeight = 44;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        [self.view addSubview:_tableView];
        //添加手势取消键盘响应
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidesKeyBorad:)];
        [self.tableView addGestureRecognizer:tap];
        //注册cell
        UINib *left = [UINib nibWithNibName:@"ChartCellLeft" bundle:nil];
        UINib *leftImage = [UINib nibWithNibName:@"ChartImageCellLeft" bundle:nil];
        UINib *leftVoice = [UINib nibWithNibName:@"CharCellVoiceLeft" bundle:nil];
        [self.tableView registerNib:left forCellReuseIdentifier:@"chartcellleft"];
        [self.tableView registerNib:leftImage forCellReuseIdentifier:@"chartimagecellleft"];
        [self.tableView registerNib:leftVoice forCellReuseIdentifier:@"charcellvoiceleft"];
        
        UINib *right = [UINib nibWithNibName:@"ChartCellRight" bundle:nil];
        UINib *rightImage = [UINib nibWithNibName:@"ChartImageCellRight" bundle:nil];
        UINib *rightVoice = [UINib nibWithNibName:@"CharCellVoiceRight" bundle:nil];
        [self.tableView registerNib:right forCellReuseIdentifier:@"chartcellright"];
        [self.tableView registerNib:rightImage forCellReuseIdentifier:@"chartimagecellright"];
        [self.tableView registerNib:rightVoice forCellReuseIdentifier:@"charcellvoiceright"];
    }
    return _tableView;
}
-(NSMutableArray *)messagesList{
    if (!_messagesList) {
        _messagesList = [NSMutableArray array];
    }
    return _messagesList;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];//移除通知
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加刷新风火轮
    self.navigationController.navigationBar.translucent = NO;
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉查看更多" forState:MJRefreshStateIdle];
    [header setTitle:@"松开加载" forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    self.tableView.mj_header = header;
    
    if (_conversation == nil) {//当点击好友信息进入回话时，_conversation为nil，当点击会话列表时候_conversation有值
        [self createConversation];
    }else{
        [self findUsersUserIDWithConversation];
    }
    if (_friendUser == nil) {//当点击好友信息进入回话时，_friendUser有值，当点击会话列表时候_friendUser为nil
        NSArray *array = [_conversation.name componentsSeparatedByString:@"&"];
        for (NSString *nameStr in array) {
            if (![nameStr isEqualToString:[RUserModel sharedUserInfo].nickName]) {
                self.title  = nameStr;
            }
        }
    }else{
        self.title = _friendUser.username;
    }
    
    //    AVIMKeyedConversation *keyedConversation = [self.conversation keyedConversation];//创建一个 AVIMKeyedConversation 对象。用于序列化，方便保存在本地。
    //    [self.conversation muteWithCallback:^(BOOL succeeded, NSError *error) {
    //        //静音，不再接收此对话的离线推送。
    //    }];
    //    [self.conversation unmuteWithCallback:^(BOOL succeeded, NSError *error) {
    //        //取消静音，开始接收此对话的离线推送。
    //    }];
    //    [self.conversation quitWithCallback:^(BOOL succeeded, NSError *error) {
    //        //离开会话
    //    }];
    
  
    [self getConversationMessage];//获取该会话内最近的20条数据
    [self.chartBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(@54);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.equalTo(_chartBar.mas_top).with.offset(0);
    }];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboradWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboradWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark - refreshAction
- (void)refreshAction{//下拉加载更多聊天记录
    AVIMMessage *message = self.messagesList.firstObject;
    NSString *messageId = message.messageId;
    int64_t timeSp = message.sendTimestamp;
    __weak ChartVC *weakSelf = self;
    [self.conversation queryMessagesBeforeId:messageId timestamp:timeSp limit:limitNum callback:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"error->>>%@",error);
        }
        NSMutableArray *objMutArray = [NSMutableArray arrayWithArray:objects];
        [objMutArray addObjectsFromArray:weakSelf.messagesList];
        weakSelf.messagesList = [NSMutableArray arrayWithArray:objMutArray];;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
}

#pragma mark - Action
- (void)keyboradWillShow:(NSNotification *)notifi{//键盘升起
    NSValue *bords = notifi.userInfo[UIKeyboardBoundsUserInfoKey];
    CGRect rect = bords.CGRectValue;//取出键盘高
    NSNumber *animation = notifi.userInfo[UIKeyboardAnimationDurationUserInfoKey];//取出键盘升起时间
    [UIView animateWithDuration:animation.floatValue animations:^{
        
        [self.chartBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-rect.size.height);
        }];
        [self.view layoutIfNeeded];
    }];
}
- (void)keyboradWillHide:(NSNotification *)notifi{//键盘回收
    NSNumber *animation = notifi.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:animation.floatValue animations:^{
        [self.chartBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
        }];
        [self.view layoutIfNeeded];
    }];
}
#pragma mark - Chart
- (void)createConversation{
    AVIMClient *clint = [RMessageManager sharemessageManager].clint;
    [RMessageManager sharemessageManager].delegate = self;
    NSString *name = [NSString stringWithFormat:@"%@&%@",_friendUser[@"localData"][@"nickName"],[RUserModel sharedUserInfo].nickName];
    __weak ChartVC *weakSelf = self;
    //会话的参与用户
    NSArray *ids = @[[AVUser currentUser].username, _friendUser.username];
    if (clint.status == AVIMClientStatusOpened) {
        [clint createConversationWithName:name clientIds:ids attributes:nil options:AVIMConversationOptionNone | AVIMConversationOptionUnique callback:^(AVIMConversation *conversation, NSError *error) {
            //创建会话成功
            weakSelf.conversation = conversation;
            NSLog(@"%@",error);
            //将当前会话,标记为已读
            [weakSelf.conversation markAsReadInBackground];
            [weakSelf getConversationMessage];//获取该会话内最近的20条数据
        }];
    }else{
        [clint openWithCallback:^(BOOL succeeded, NSError *error) {
            [clint createConversationWithName:name clientIds:ids attributes:nil options:AVIMConversationOptionNone | AVIMConversationOptionUnique callback:^(AVIMConversation *conversation, NSError *error) {
                weakSelf.conversation = conversation;
                NSLog(@"%@",error);
                // 将当前会话,标记为已读
                [weakSelf.conversation markAsReadInBackground];
                [weakSelf getConversationMessage];//获取该会话内最近的20条数据
            }];
        }];
    }
}
- (void)findUsersUserIDWithConversation{//通过会话的成员username获取avuser对象
    NSArray *userNameArray = _conversation.members;
    __weak ChartVC *weekSelf = self;
    if ([userNameArray count] > 0) {
        AVQuery *q = [AVUser query];
        [q setCachePolicy:kAVCachePolicyNetworkElseCache];
        [q whereKey:@"username" containedIn:userNameArray];
        [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"error-->%@",error);
            }
            for (AVUser *user in objects) {
                if (![user.username isEqual:[AVUser currentUser].username]) {
                    _friendUser = user;
                    [weekSelf.tableView reloadData];
                }
            }
        }];
    }
}

#pragma mark - message Delegate
//接收消息的Delegate,MessageManager调用
-(void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message{
    //消息的会话,是当前会话的
    if (self.conversation == conversation) {
        [self.messagesList addObject:message];
        [self.tableView reloadData];
            //偏移到最底部
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messagesList.count-1 inSection:0];
        if (indexPath.row > 0) {
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
        }
    }
}
-(void)getConversationMessage{
    //获取该会话内的最近20条信息
    __weak ChartVC *weakSelf = self;
    [self.conversation queryMessagesWithLimit:limitNum callback:^(NSArray *objects, NSError *error) {
        //NSLog(@"%@",objects);
        [weakSelf.messagesList addObjectsFromArray:objects];
        //偏移到最底部
        [weakSelf.tableView reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messagesList.count-1 inSection:0];
        if (indexPath.row > 0) {
            [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
        }
    }];
}
#pragma mark - Chart bar delegate

-(void)sendMessage:(id)message{
    [self.conversation sendMessage:message callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"发送成功");
        }else{
            NSLog(@"error:%@", error);
        }
    }];
    //添加message到table的数据源
    [self.messagesList addObject:message];
    //[self getConversationMessage];
    [self.tableView reloadData];
    //偏移到最底部
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messagesList.count-1 inSection:0];
    if (indexPath.row > 0) {
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }
}

#pragma mark - Table View Data Source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messagesList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //根据message收发消息,选择使用cell
    AVIMTypedMessage *message = self.messagesList[indexPath.row];
    ChartCell *cell;
    if ([message.clientId isEqualToString:[AVUser currentUser].username]) {
        //自己的消息
        if (message.mediaType == kAVIMMessageMediaTypeImage) {
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"chartimagecellright" forIndexPath:indexPath];
        }else if (message.mediaType == kAVIMMessageMediaTypeAudio){
            cell = [tableView dequeueReusableCellWithIdentifier:@"charcellvoiceright" forIndexPath:indexPath];
        
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"chartcellright" forIndexPath:indexPath];
        }
    }else{
        if (message.mediaType == kAVIMMessageMediaTypeImage) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"chartimagecellleft" forIndexPath:indexPath];
        }else if (message.mediaType == kAVIMMessageMediaTypeAudio){
            cell = [tableView dequeueReusableCellWithIdentifier:@"charcellvoiceleft" forIndexPath:indexPath];
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"chartcellleft" forIndexPath:indexPath];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.friendUser = _friendUser;
    
    [cell bandingMessage:message];
    return cell;
}
- (void)hidesKeyBorad:(UITapGestureRecognizer *)tap{//tap事件 取消键盘第一响应
    [self.chartBar.inputTextView  resignFirstResponder];
    
    //找到点击的位置
    CGPoint point = [tap locationInView:self.tableView];
    //根据点击的位置找到对应的索引
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    if (!indexPath) {
        return;
    }
    AVIMTypedMessage *message = self.messagesList[indexPath.row];
    ChartCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (![cell isTapedInContent:tap]) {
        return;
    }
    //如果点击的cell是声音cell,并且在声音背景的矩形区域内,播放声音
    if (message.mediaType == kAVIMMessageMediaTypeAudio) {
        //准备播放声音
        [message.file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (error) {
                NSLog(@"播放%@",error);
            }
            //播放date
            [[RAudioPlayer shareAudioPlayer] playAudioWithData:data];
            //cell显示动画
            [cell startAnimation];
        }];
    }
    //点击cell为图片
    if (message.mediaType == kAVIMMessageMediaTypeImage) {
        
    }
}
#pragma mark - function delegate
-(void)selectAction:(NSInteger)actionIndex{
    switch (actionIndex) {
        case 1://选择图片
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
        case 2://相机
            NSLog(@"2");
            break;
        case 3://位置
            NSLog(@"3");
            break;
        default:
            break;
    }
    
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //[self.revalViewC dismissViewControllerAnimated:YES completion:nil];
    
    AVFile *file = [AVFile fileWithData:UIImageJPEGRepresentation(image, 0.3)];
    AVIMImageMessage *message = [AVIMImageMessage messageWithText:[NSString stringWithFormat:@"%f:%f",image.size.width,image.size.height] file:file attributes:nil];
    [self sendMessage:message];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end







