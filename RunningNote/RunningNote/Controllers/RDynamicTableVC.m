//
//  RDynamicTableVC.m
//  RunningNote
//
//  Created by qingyun on 16/7/2.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RDynamicTableVC.h"
#import "RMyTableViewCell.h"
#import "RCommentesTableVC.h"
#import "RMyFootView.h"
#import "RPublishedVC.h"
#import <SVProgressHUD.h>
#import <AVStatus.h>
#import "RDynamicModel.h"
#import "RUserModel.h"
#import "MJRefresh.h"
#define RScreenW [UIScreen mainScreen].bounds.size.width
@interface RDynamicTableVC ()<UITextViewDelegate>

@property (nonatomic, strong)NSMutableArray *dataArray;//数据源
@property (nonatomic, strong)NSMutableArray *commentesArray;//?


@property (nonatomic , strong)UITextView *commentText; //文本框
@property (nonatomic ,strong) UIView     *commentesView; //评论列表

@property (nonatomic)          NSInteger sectionNumber;//点击的评论为哪条的

@end

@implementation RDynamicTableVC
static NSString *identifire = @"mycell";
static NSString *footerIdentifier = @"myFootView";
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.edgesForExtendedLayout = UIRectEdgeAll;
    [self addTableHeardView];
    self.tableView.estimatedRowHeight = 200;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.dataArray = [NSMutableArray array];
    //注册cell
    NSString *nibNama = NSStringFromClass([RMyTableViewCell class]);
    UINib *nib = [UINib nibWithNibName:nibNama bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:identifire];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newMessage)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    //注册sectionFooterView
    [self.tableView registerClass:[RMyFootView class] forHeaderFooterViewReuseIdentifier:footerIdentifier];
    //添加一个手势，隐藏键盘
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;

    //添加刷新风火轮
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadDataArray)];
    self.tableView.mj_header.tintColor = [UIColor blackColor];
    [self.tableView.mj_header beginRefreshing];
    //上拉加载更多
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadMoreData)];
    
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"数据以全部加载完毕" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = footer;
    
}
- (void)reloadMoreData{//上拉加载
    __weak RDynamicTableVC *weakSelf = self;
    AVStatusQuery *query=[AVStatus inboxQuery:kAVStatusTypeTimeline];
    //      限制条数
    query.limit = 10;
    RDynamicModel *model = self.dataArray.lastObject;
    NSInteger n = model.messageId + 1;
    query.maxId = n;

    //设置消息类型
    query.inboxType=kAVStatusTypeTimeline;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        //获得 AVStatus 数组
        [weakSelf dataArrayFromArray:objects];
    }];
}
- (void)reloadDataArray{//下拉刷新
    __weak RDynamicTableVC *weakSelf = self;
    AVStatusQuery *query=[AVStatus inboxQuery:kAVStatusTypeTimeline];
    //      限制条数
    query.limit=10;
    //设置消息类型
    query.inboxType=kAVStatusTypeTimeline;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        //获得 AVStatus 数组
        if (objects) {
            [weakSelf.dataArray removeAllObjects];
        }
        [weakSelf dataArrayFromArray:objects];
    }];
}
- (void)dataArrayFromArray:(NSArray *)array{
    NSMutableArray *mutArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i ++){
        RDynamicModel *model = [[RDynamicModel alloc] initWithResults:array[i]];
        [mutArray addObject:model];
    }
    [self.dataArray addObjectsFromArray:mutArray];
    [self.tableView.mj_header endRefreshing];
    if (array.count < 10) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        
        [self.tableView.mj_footer endRefreshing];
    }
    [self.tableView reloadData];
    [self getCommentesArrayFromId];
}

- (void)newMessage{//发布一条动态
    RPublishedVC *publeshedVC = [[RPublishedVC alloc] init];
    [self.navigationController pushViewController:publeshedVC animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.alpha = 0.6;
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    [SVProgressHUD dismiss];
    [self.tableView reloadData];
}
-(void)getCommentesArrayFromId{
    for (int i = 0; i < self.dataArray.count; i ++) {
        RDynamicModel *model = self.dataArray[i];
        AVQuery *query = [AVQuery queryWithClassName:@"Comments"];
        query.limit = 20;
        [query whereKey:@"StatusId" equalTo:[AVObject objectWithClassName:@"_Status" objectId:model.objectid]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"error---->>%@",error);
            }
            NSArray* reversedArray = [[objects reverseObjectEnumerator] allObjects];
            [_dataArray[i] setValue:reversedArray forKey:@"comments"];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RDynamicModel *model = self.dataArray[indexPath.section];
    RMyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifire forIndexPath:indexPath];
    cell.model = model;
    cell.tempTVC = self;//把控制器传过去，确定响应者链连贯
    [cell.contentView setBackgroundColor:[UIColor colorWithRed:46/255.0 green:46/255.0 blue:46/255.0 alpha:1]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


- (void)addTableHeardView{
    //添加tableView的头部视图
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"circle"]];
    imageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
    self.tableView.tableHeaderView = imageView;
}
//设置sectionFooterView的高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

//sectionFooterView
//返回tableViewCell的尾部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    RMyFootView *footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerIdentifier];
    footView.contentView.backgroundColor = [UIColor colorWithRed:46/255.0 green:46/255.0 blue:46/255.0 alpha:1];
    __weak RDynamicTableVC *weakSelf = self;
    footView.changedSelectedBtn = ^(NSInteger tag){
        [weakSelf btnClick:tag :section];
    };
    return footView;
}


- (void)btnClick:(NSInteger )tag :(NSInteger)sectionNumber{
    if (tag == 1001) {
        [self showCommentText];
        _sectionNumber = sectionNumber;
       // NSLog(@"-------> 第%ld组",sectionNumber);
    }else if (tag == 1002){
        NSLog(@"转发");
    }
}
- (void)showCommentText {
    [self createCommentsView];
    [_commentText becomeFirstResponder];//再次让textView成为第一响应者（第二次）这次键盘才成功显示
}
- (void)createCommentsView {//创建commentsView
    UIView *commentsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RScreenW, 44)];
    commentsView.backgroundColor = [UIColor whiteColor];
    _commentText = [[UITextView alloc] initWithFrame:CGRectInset(commentsView.bounds, 5.0, 5.0)];
    _commentText.layer.borderColor   = (__bridge CGColorRef _Nullable)([UIColor blueColor]);
    _commentText.layer.borderWidth   = 1.0;
    _commentText.layer.cornerRadius  = 2.0;
    _commentText.layer.masksToBounds = YES;
    _commentText.inputAccessoryView  = commentsView;
    _commentText.backgroundColor     = [UIColor clearColor];
    _commentText.returnKeyType       = UIReturnKeyDone;
    _commentText.delegate	    = self;
    _commentText.font		= [UIFont systemFontOfSize:17.0];
    [commentsView addSubview:_commentText];
    [self.view.window addSubview:commentsView];//添加到window上或者其他视图也行，只要在视图以外就好了
    [_commentText becomeFirstResponder];//让textView成为第一响应者（第一次）这次键盘并未显示出来，（个人觉得这里主要是将commentsView设置为commentText的inputAccessoryView,然后再给一次焦点就能成功显示）
}
//回收键盘
- (void) hideKeyboard {
    [_commentText resignFirstResponder];
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    //NSLog(@"文本框内容--> %@",textView.text);
    return YES;//键盘收回时
}
//点击键盘return回收键盘
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text{
    if ([text isEqualToString:@"\n"]) {
        //添加评论
        [self createAComment:textView.text];
        [self hideKeyboard];
        return NO;
    }
    return YES;
}

- (void)createAComment:(NSString *)text{//发布一条评论
    AVObject *comment = [[AVObject alloc] initWithClassName:@"Comments"];// 构建 Comment 对象
    [comment setObject:text forKey:@"contentText"];// 留言的内容
    RDynamicModel *statuModel = self.dataArray[_sectionNumber];
    NSString *statusId = statuModel.objectid;
    [comment setObject:[AVObject objectWithClassName:@"_Status" objectId:statusId] forKey:@"StatusId"];
    //评论字段中需要添加评论人，暂时设置为数组，数组中第一个元素为评论人的id，第二个为昵称
    NSArray *array = @[[AVUser currentUser].objectId,[RUserModel sharedUserInfo].nickName];
    [comment setObject:array forKey:@"commenter_idAndName"];
//#warning 字段中 array为[userID,userNickName]   字段currentUser中为user对象包含userId，但无nickName
    [comment setObject:[AVUser currentUser] forKey:@"currentUser"];//
    [comment saveInBackground];
    SVProgressHUD.minimumDismissTimeInterval = 2.0;
    [SVProgressHUD showSuccessWithStatus:@"评论成功,刷新数据"];
    [self.tableView.mj_header beginRefreshing];
}


@end





