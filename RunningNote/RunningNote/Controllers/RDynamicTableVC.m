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

#define RScreenW [UIScreen mainScreen].bounds.size.width
@interface RDynamicTableVC ()<UITextViewDelegate>

@property (nonatomic , strong)NSMutableArray *dataArray;//数据源


@property (nonatomic , strong)UITextView *commentText; //文本框
@property (nonatomic ,strong) UIView     *commentesView;

@end

@implementation RDynamicTableVC
static NSString *identifire = @"mycell";
static NSString *footerIdentifier = @"myFootView";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTableHeardView];
    self.tableView.estimatedRowHeight = 200;
    //注册cell
    NSString *nibNama = NSStringFromClass([RMyTableViewCell class]);
    UINib *nib = [UINib nibWithNibName:nibNama bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:identifire];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //注册sectionFooterView
    [self.tableView registerClass:[RMyFootView class] forHeaderFooterViewReuseIdentifier:footerIdentifier];
    //添加一个手势，隐藏键盘
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.alpha = 0.5;
    self.view.backgroundColor = [UIColor colorWithRed:46/255.0 green:46/255.0 blue:46/255.0 alpha:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;//temp
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RMyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifire forIndexPath:indexPath];
    cell.tempTVC = self;//把控制器传过去，确定响应者链连贯
    cell.contentArray = [NSArray arrayWithObjects:@"kong",@"空", nil];//临时
    [cell.contentView setBackgroundColor:[UIColor colorWithRed:46/255.0 green:46/255.0 blue:46/255.0 alpha:1]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)addTableHeardView{
    //添加tableView的头部视图
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"outsideSport.png"]];
    imageView.frame = CGRectMake(0, 0, 0, 200);
    self.tableView.tableHeaderView = imageView;
}
//设置sectionFooterView的高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 39;
}

//sectionFooterView
//返回tableViewCell的尾部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    RMyFootView *footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerIdentifier];
    footView.contentView.backgroundColor = [UIColor colorWithRed:46/255.0 green:46/255.0 blue:46/255.0 alpha:1];
    __weak RDynamicTableVC *weakSelf = self;
    footView.changedSelectedBtn = ^(NSInteger tag){
        [weakSelf btnClick:tag];
    };
    return footView;
}

- (void)btnClick:(NSInteger )tag{
    if (tag == 1001) {
//        sender.userInteractionEnabled = NO;
//        [sender performSelector:@selector(setUserInteractionEnabled:) withObject:@YES afterDelay:5];
        [self showCommentText];
        
    }else if (tag == 1002){
        NSLog(@"转发");
    }
}
- (void)showCommentText {
    [self createCommentsView];
    [_commentText becomeFirstResponder];//再次让textView成为第一响应者（第二次）这次键盘才成功显示
}
- (void)createCommentsView {//创建commentsView
    UIView *commentsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RScreenW, 40)];
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
    NSLog(@"文本框内容--> %@",textView.text);
    return YES;//键盘收回时
}
//点击键盘return回收键盘
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text{
    if ([text isEqualToString:@"\n"]) {
        [self hideKeyboard];
        return NO;
    }
    return YES;
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
